# Strix Security Testing Demo

This repository is a beginner-friendly exercise for learning how to use
[Strix](https://github.com/usestrix/strix) to review a local source-code project.
The supplied NeoBank application uses fictional data and is intended only for
authorized educational security testing.

## What is included

- `neobank-project/` — the sanitized source-code target
- `scope.txt` — safety boundaries and review areas for Strix
- this guide — the shortest path from setup to reviewing a result

No API keys, databases, scan answers, instructor notes, local tool runtimes, or
previous scan output are included.

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

From this repository's root directory, run:

```text
strix -n --target ./neobank-project --scan-mode quick --scope-mode full --instruction-file ./scope.txt --max-budget 5 --max-turns 80
```

The budget is an estimate rather than a guaranteed spending cap, and in-flight
model calls can exceed it. The turn limit applies per agent. Monitor usage in
your model-provider account and stop the run if it exceeds your approved limit.

## 5. Review the result

Strix normally writes a new folder under `strix_runs/`. Start with:

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
