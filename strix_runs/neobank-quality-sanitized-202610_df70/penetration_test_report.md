# Security Penetration Test Report

**Generated:** 2026-10-29 10:24:02 UTC

# Executive Summary

The workshop target exposes three meaningful weaknesses in the AI banking flow. The highest-risk issue is the model/tool boundary: a normal chat user can steer ARIA into disclosing another customer’s account data and the restricted internal treasury policy document. A second issue lets an attacker authenticate as any seeded customer or staff member using only a public full name, and a third allows cross-user account reads through the account lookup tool.

Overall posture: elevated for a training target, with one high-severity disclosure path and two medium-severity authentication / object-access weaknesses. The SQLite query layer itself is not the problem; the exposed authority sits in the agent/tool design and the name-only login flow.

# Methodology

This was a source-aware white-box assessment of the local workshop repository. The review combined static triage of `app.py`, `agent.py`, `database.py`, `knowledge_base.py`, and `seed_data.py` with bounded static analysis artifacts, in-memory SQLite validation, and stubbed model responses so the live OpenAI API was not required. Validation focused on prompt/tool abuse, internal-data disclosure, authentication strength, object-level authorization, and SQLite/query handling, with negative checks for SQL injection and session-reuse behavior.

# Technical Analysis

The core issue is that ARIA treats model instructions as if they were an authorization boundary. In `agent.py`, the `lookup_policy` and `query_account` tools accept attacker-influenced arguments with no ownership or role checks, and the agent executes the first tool call emitted by the model before reflecting the raw result back into the final answer. That means a standard customer session can be steered to retrieve another customer’s account or the internal-only treasury reference, which materially increases the risk of targeted fraud and sensitive operational disclosure.

A separate authentication weakness exists in `app.py` and `database.py`: the login form authenticates by full name only. Any seeded customer or staff name becomes a valid credential, so an attacker who knows or guesses a real name can sign in as that person and inherit the session identity. The database helpers themselves use parameterized SQL and did not show injection behavior, and the logout / API-key refresh path does clear session identity state, so those areas were ruled out rather than reported.

# Recommendations

**Immediate**
- Bind every account lookup to the server-side authenticated principal before any database read.
- Restrict internal policy topics to staff-only sessions and return access-denied errors for standard users.
- Replace name-only login with a real second factor or a verified account secret.

**Short-term**
- Add regression tests for cross-user account reads, staff-account access, and restricted policy disclosure.
- Align the system prompt with the real authorization model so it does not imply the tools enforce security.

**Medium-term**
- Add a narrow authorization layer around all model-facing tools, not just `query_account`.
- Keep the SQLite helpers parameterized and preserve the current session-reset behavior, which already helps prevent identity reuse across turns.

**Retest guidance**
- Re-run the tool-boundary harness after the authorization fix and confirm that own-account and public-policy paths still work while cross-user and internal-only requests fail.

