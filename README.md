# Strix Security Testing Demo

This repository is a beginner-friendly exercise for learning how to use
[Strix](https://github.com/usestrix/strix) to review a local source-code project.
The supplied NeoBank application uses fictional data and is intended only for
authorized educational security testing.

## What is included

- `neobank-project/` — the sanitized source-code target
- `scope.txt` — safety boundaries and review areas for Strix
- `scripts/` — a key-entry helper, scan runner, and optional Windows repair recipes
- [Demo walkthrough](docs/DEMO_WALKTHROUGH.txt) — one file in video order
- [Viewer follow-along](docs/VIEWER_FOLLOW_ALONG.txt) — links and commands
- [Windows setup](docs/setup/WINDOWS_SETUP.txt), [Mac notes](docs/setup/MAC_SETUP.txt),
  [model setup](docs/setup/MODEL_SETUP.txt), and
  [troubleshooting](docs/setup/issuesyoumightcomeacross.txt)
- [Reviewed findings](docs/reports/NEOBANK_STRIX_RESULTS.txt),
  [trial history](docs/reports/STRIX_NEOBANK_TRIAL_REPORT.txt), and
  [data-handling choices](docs/reports/levels%20of%20access.txt)
- [How Strix works](docs/images/01_HOW_STRIX_WORKS.png) and
  [model-access options](docs/images/02_MODEL_ACCESS_OPTIONS.png) — video visuals
- [Saved completed run](strix_runs/neobank-quality-sanitized-202610_df70/README.txt) —
  original findings, execution/console logs, usage, and coverage

The saved example includes the findings discussed in the video. If you want to
try discovering them yourself, run your scan before reading the example reports.
No API keys, real databases, presenter narration/notes, local tool runtimes, or
internal resumable session databases are included.

## 1. Install the required tools

Install Docker for your operating system and then install Strix:

- [Strix quick start](https://docs.strix.ai/quickstart)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Docker Desktop for macOS](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)
- [Strix model-provider setup](https://docs.strix.ai/llm-providers/overview)

Windows uses Docker Desktop with WSL 2. macOS uses Docker Desktop directly.
Linux can use Docker Engine. Strix also needs access to a supported model
provider with enough credits and request quota for the scan.
Follow [model setup](docs/setup/MODEL_SETUP.txt) before starting. A paid account
does not bypass provider cybersecurity safeguards. Mac/Linux installation has
not been verified on this presenter's machine; use the official OS instructions.

Check the installation in PowerShell or a terminal:

```text
docker info
docker run --rm hello-world
strix --version
```

The first Strix run may download a sandbox image. This is a ready-made package
of Linux and security tools that Docker uses to create an isolated test
container.

## 2. Understand the safe test copy

`neobank-project/` contains only the source, dependency list, and project
documentation needed for this exercise. Environment files, real credentials,
databases, virtual environments, caches, logs, and generated files are excluded.

The folder supplied with `--target` is made available inside a Docker container
so Strix can inspect and test it. Treat the target as writable: keep an untouched
copy and review any changes after a scan. Source snippets may be sent to the
configured model provider, so never scan private code without authorization.

## 3. Review the scope

Read `scope.txt` before running the command. It restricts the exercise to the
local NeoBank folder and fictional data. Instructions guide the scanner, but
they are not a substitute for Docker, provider, network, or account controls.

## 4. Run the scan

You do not need a new scan or an API key to review the
[saved demonstration](strix_runs/neobank-quality-sanitized-202610_df70/README.txt).

From this repository's root directory, run:

```text
strix -n --target ./neobank-project --scan-mode quick --scope-mode full --instruction-file ./scope.txt --max-budget 5 --max-turns 80
```

The budget is an estimate rather than a guaranteed spending cap, and in-flight
model calls can exceed it. The turn limit applies per agent. Monitor usage in
your model-provider account and stop the run if it exceeds your approved limit.

For Windows, the supplied helper creates a new sanitized copy automatically and
prompts for an OpenAI Platform key without showing it. First preview it safely:

```powershell
.\scripts\RUN_NEOBANK_WITH_OPENAI.ps1 -DryRun
```

Then, only when ready to use your model account:

```powershell
.\scripts\RUN_NEOBANK_WITH_OPENAI.ps1
```

The helper defaults to `gpt-5.4-mini`, the historical successful example. Confirm
your account's current access and compatibility before running. It does not
automatically fall back to other models. It is specific to this NeoBank target.
Your key may be persisted by Strix in your local user configuration outside this
repository; never show or share that file.

## 5. Review the result

Strix normally writes a new folder under `strix_runs/`. Our completed example is
`strix_runs/neobank-quality-sanitized-202610_df70/`; future runs are ignored by
Git by default. Start with:

- `penetration_test_report.md` for the summary
- `vulnerabilities/` for individual findings
- `run.json` for status and model usage
- `coverage.json` for what was and was not tested

For every reported issue:

1. Locate the cited code.
2. Confirm that the behavior is actually possible within the approved scope.
3. Merge duplicate reports that describe the same root cause.
4. Record the evidence, impact, and a practical fix.
5. After fixing it, test one allowed case and one denied case.

A completed scan is not proof that the project is secure. The expected exercise
output is a short human-reviewed report separating confirmed findings,
duplicates, false positives, coverage gaps, and recommended fixes.

## Saved demonstration facts

The completed Windows scan on 29 October 2026 used Strix 1.7.0 and OpenAI
`gpt-5.4-mini`. It made **163 model requests**, took about **9 minutes 22 seconds**,
and reported an estimated **$2.24** model cost. This is not a price guarantee or
an independently verified invoice. It was a quick source review using fictional
data and simulated replies from the banking app, not a live banking deployment
test. Strix itself used the connected model. Review the evidence README for the
overlapping findings, original path references, and source-integrity caveats.

## Safety rules

- Test only systems and source code you own or have written permission to assess.
- Never commit or share API keys.
- Do not test unrelated external systems.
- Use fictional data and a disposable project copy.
- Check model costs, quotas, and cybersecurity access requirements before starting.
- Treat scanner findings as leads that require human verification.

## Disclaimer

NeoBank, its users, accounts, balances, and transactions are fictional. This
repository is for controlled education and authorized security testing only.
