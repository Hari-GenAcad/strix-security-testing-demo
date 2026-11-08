[CmdletBinding()]
param(
    [string]$Model = $env:STRIX_LLM,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot 'neobank-project'
$scope = Join-Path $repoRoot 'scope.txt'
$names = @('.gitignore','README.md','agent.py','app.py','database.py',
    'knowledge_base.py','requirements.txt','seed_data.py')
foreach ($name in $names) {
    if (-not (Test-Path -LiteralPath (Join-Path $source $name) -PathType Leaf)) { throw "Missing target file: $name" }
}
if (-not (Test-Path -LiteralPath $scope -PathType Leaf)) { throw 'Missing scope.txt.' }
if ([string]::IsNullOrWhiteSpace($Model)) { throw 'Configure STRIX_LLM or supply -Model before scanning.' }

# Preserve support for the presenter's optional local repaired runtime. A fresh
# clone uses the officially installed Strix CLI and needs none of these files.
$localWrapper = Join-Path $repoRoot 'strix.ps1'
$localBootstrap = Join-Path $repoRoot '.tools\run_strix_repaired.py'
if ((Test-Path -LiteralPath $localWrapper) -and (Test-Path -LiteralPath $localBootstrap)) {
    $launcher = $localWrapper
} else {
    $launcher = 'strix'
}
$runLabel = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,8)
$target = Join-Path $repoRoot ".scan-targets\neobank-$runLabel"
$consoleLog = Join-Path $repoRoot ".tmp\neobank-$runLabel-console.log"
$arguments = @('-n','--target',$target,'--scan-mode','quick','--scope-mode','full',
    '--instruction-file',$scope,'--max-budget','5','--max-turns','80','--fail-on','critical')

Write-Host "Model: $Model"
Write-Host "Source: $source"
Write-Host "Disposable scan copy: $target"
Write-Host "Instructions: $scope"
Write-Host "Launcher: $launcher"
Write-Host "Console log: $consoleLog"
if ($DryRun) {
    Write-Host ('Planned arguments: ' + (($arguments | ForEach-Object { '"' + $_ + '"' }) -join ' '))
    Write-Host 'Dry run only: no files copied, no key read, no provider call, no Docker container, no scan.'
    return
}
if ($launcher -eq 'strix' -and -not (Get-Command strix -ErrorAction SilentlyContinue)) { throw 'Install Strix and make strix available on PATH first.' }

$baseline = @{}
foreach ($name in $names) { $baseline[$name] = (Get-FileHash -LiteralPath (Join-Path $source $name) -Algorithm SHA256).Hash }
New-Item -ItemType Directory -Path $target | Out-Null
New-Item -ItemType Directory -Path (Split-Path -Parent $consoleLog) -Force | Out-Null
foreach ($name in $names) { Copy-Item -LiteralPath (Join-Path $source $name) -Destination (Join-Path $target $name) }

$environmentNames = @('STRIX_LLM','NO_COLOR','PATH','TEMP','TMP','STRIX_IMAGE',
    'DOCKER_CONTEXT','STRIX_TELEMETRY','PYTHONUNBUFFERED')
$previousEnvironment = @{}
foreach ($name in $environmentNames) { $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
$scanExit = 1
Push-Location -LiteralPath $repoRoot
try {
    $env:STRIX_LLM = $Model
    $env:NO_COLOR = '1'
    # Windows PowerShell can turn native stderr into an error record. Preserve
    # the output and use the native exit status instead of stopping at stderr.
    $savedErrorPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $global:LASTEXITCODE = 1
    try { & $launcher @arguments 2>&1 | Tee-Object -FilePath $consoleLog }
    finally { $scanExit = $LASTEXITCODE; $ErrorActionPreference = $savedErrorPreference }
} finally {
    foreach ($name in $environmentNames) { [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name], 'Process') }
    Pop-Location
    $changed = @()
    foreach ($name in $names) {
        foreach ($directory in @($source,$target)) {
            $path = Join-Path $directory $name
            if (-not (Test-Path -LiteralPath $path -PathType Leaf) -or
                (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $baseline[$name]) { $changed += $path }
        }
    }
    $extra = @(Get-ChildItem -LiteralPath $target -File -Force -Recurse | Where-Object {
        $_.DirectoryName -ne $target -or $_.Name -notin $names
    })
    if ($changed.Count -or $extra.Count) {
        'Integrity check: changed or additional files require review, even if Strix exited successfully.' | Tee-Object -FilePath $consoleLog -Append
        $changed | Tee-Object -FilePath $consoleLog -Append
        $extra.FullName | Tee-Object -FilePath $consoleLog -Append
    } else {
        'Integrity check: all eight source files and scan-copy files unchanged; no additional target files.' | Tee-Object -FilePath $consoleLog -Append
    }
    "Strix exit code: $scanExit" | Tee-Object -FilePath $consoleLog -Append
}
exit $scanExit
