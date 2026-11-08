[CmdletBinding()]
param(
    [string]$Model = 'gpt-5.4-mini',
    [switch]$DryRun
)

# No key is embedded here. DryRun never prompts for a key or calls a provider.
$ErrorActionPreference = 'Stop'
if ($Model -notmatch '^[A-Za-z0-9._-]+$') { throw 'Use an OpenAI model ID, without the provider prefix.' }
$runner = Join-Path $PSScriptRoot 'Run-Neobank-Strix.ps1'
if ($DryRun) {
    & $runner -Model "openai/$Model" -DryRun
    return
}

$names = @('LLM_API_KEY','OPENAI_API_KEY','STRIX_LLM','STRIX_API_TYPE',
    'LLM_PREFLIGHT_TIMEOUT','LLM_DISABLE_STREAMING','PYTHONUTF8')
$previous = @{}
foreach ($name in $names) { $previous[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
$secureKey = $null
$keyPointer = [IntPtr]::Zero
$plainKey = $null
$scanExit = 1
try {
    Write-Host 'This starts a paid source scan. Check provider access, quota, and spending limits first.'
    Write-Host 'Strix may save provider credentials in your local user configuration; never share that file.'
    $secureKey = Read-Host 'Enter your OpenAI Platform API key (hidden input)' -AsSecureString
    $keyPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
    $plainKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($keyPointer)
    if ([string]::IsNullOrWhiteSpace($plainKey)) { throw 'No API key was entered.' }
    $env:LLM_API_KEY = $plainKey
    $env:OPENAI_API_KEY = $plainKey
    $env:STRIX_LLM = "openai/$Model"
    $env:STRIX_API_TYPE = 'responses'
    $env:LLM_PREFLIGHT_TIMEOUT = '120'
    $env:LLM_DISABLE_STREAMING = 'true'
    $env:PYTHONUTF8 = '1'
    $plainKey = $null
    Write-Host 'Starting the sanitized NeoBank scan. No automatic model fallback is used.'
    Write-Host 'Provider cybersecurity safeguards still apply.'
    & $runner -Model "openai/$Model"
    $scanExit = $LASTEXITCODE
} finally {
    foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name, $previous[$name], 'Process') }
    $plainKey = $null
    if ($keyPointer -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($keyPointer) }
    if ($secureKey) { $secureKey.Dispose() }
}
exit $scanExit
