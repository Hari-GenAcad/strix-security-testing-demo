SAVED STRIX RUN: HOW TO READ THIS EXAMPLE
========================================
This is the completed 29 October 2026 run, not a new or live scan.

Start with docs/reports/NEOBANK_STRIX_RESULTS.txt for the human-reviewed summary.
penetration_test_report.md and vulnerabilities/ contain Strix's original claims.
run.json records completion, timing, agent activity, and usage. coverage.json
records 12 surfaces with one coverage gap. findings.sarif, vulnerabilities.json,
and vulnerabilities.csv are structured exports. strix.log is the execution log;
console.log is a byte-for-byte copy of the successful saved terminal transcript.
It uses the original Windows UTF-16 encoding; console-readable.txt is a UTF-8
text copy for reading directly in GitHub. They contain the same console text.

Verified summary: quick/full source scan; openai/gpt-5.4-mini; completed;
163 requests; about 9m22s; estimated cost $2.24178915. Cost is an estimate.

The raw reports overlap: one combined tool-authorization finding repeats the
account-access evidence of another. Merge those when counting root causes.
Raw severity scores and suggested fixes are scanner output, not automatically
correct judgments. In particular, two known public identifiers are not secure
authentication. No implemented fix or successful fix retest is claimed here.

Validation used fictional data and stubbed replies from the BANKING APP's model.
Strix itself still used the connected cloud model. No running bank deployment
or successful live-model prompt injection is established by this source scan.

The original paths D:\pentesting and /target in these records are historical.
Use neobank-project/ for the distributed source. Its six Python/dependency files
match the scanned snapshot; the packaged README and .gitignore were updated.
The optional architecture.html and security_guide.html pages were added to the
public app package after recording and are outside this saved scan's scope.
The eight files in the original scan were verified unchanged afterward. Four
temporary Python cache files triggered the console integrity warning and were
later removed; they were not source edits.

Internal .state session databases/checkpoints are excluded. They are not needed
to read the complete reports, usage, coverage, or logs, and this public evidence
bundle is not offered as a resumable session. Future scans have their own output.

The original 11 report/log artifacts were checked for credential patterns and
credential-bearing URLs before publication; no such values were identified.
Treat any newly generated output as private until you have reviewed it yourself.
