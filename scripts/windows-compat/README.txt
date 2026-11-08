OPTIONAL HISTORICAL WINDOWS COMPATIBILITY RECIPES
================================================
These are source recipes from the Windows Strix 1.7.0 demonstration, not tools
every student must install. Try the official installation first. Confirm the
same defect before applying a workaround; newer releases can behave differently.

BLANK COMMAND OUTPUT
The old Python Docker named-pipe transport closed both directions when the
Agents SDK requested a write-only half-close. The small patch preserves the
read side. No provider policy, authentication, or model safety setting changes.

If using the same affected Python installation with strix-agent installed:
  python scripts/windows-compat/run_strix_repaired.py --version
Use that entry point in place of strix only after confirming the defect.
A standalone bundled executable does not automatically gain access to your
system Python packages. Installing this launcher alone is not installing Strix.

BROKEN SANDBOX CERTIFICATE
For the confirmed InvalidP12 defect in the historical 1.3.0 base image only:
  docker build --pull=false -t strix-sandbox:1.3.0-fixed scripts/windows-compat
Choose that local image via STRIX_IMAGE only for the compatible affected setup.
This makes a new test CA inside the container image. It does not install trust
on the Windows host. Do not export or publish the generated CA private key.

See docs/setup/issuesyoumightcomeacross.txt for the symptoms and limitations.
Portable Python distributions, binaries, generated certificates, Docker disks,
and private local launcher settings are intentionally not distributed.
