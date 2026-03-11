---
name: verification-before-completion
description: Evidence-based verification gate before claiming completion
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# Verification Before Completion

## The Gate

Before claiming any task, step, or process is complete:

1. **Identify** the specific command or observation that proves the claim
2. **Execute** the verification — fresh, complete, not a previous run
3. **Read** the full output, including exit code
4. **Confirm** the output matches the claim

Only then state the claim, WITH the evidence.

Skip any step = the claim is unverified, regardless of confidence.

## Not Sufficient

| Claim | Requires | NOT Sufficient |
|-------|----------|----------------|
| "Tests pass" | Test command output showing 0 failures | Previous run, "should pass", green checkmark memory |
| "Bug fixed" | Reproduce original symptom → now passes | "Code changed", "looks correct" |
| "Build succeeds" | Build command exits 0 | "No errors in the code" |
| "Lint clean" | Lint command exits 0, no warnings | "I followed the style guide" |
| "Change is safe" | Diff review + test suite + no unintended files | "It's a small change" |

## Red Flags

- "I already verified this earlier" — verify again. State changes between steps.
- "This is too simple to need verification" — simple things break. 10 seconds to confirm.
- "The code change is obviously correct" — obvious to whom? Run the command.
- "Tests should pass" — "should" is not evidence. Run them.

## Verify

- Every completion claim in the conversation cites a fresh command output or observable evidence.
- No claim relies on a previous run, inference, or "should."
