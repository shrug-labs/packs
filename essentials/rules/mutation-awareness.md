---
name: mutation-awareness
description: Structured mutation gating for any state-changing action
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# Mutation Awareness

## The Gate

Before any action that changes state outside this conversation — git push, API write, file deploy, ticket update, infrastructure change — you must:

1. **Label it.** State "MUTATION" explicitly.
2. **Name the target.** What exactly will change? (resource, repo, ticket, system)
3. **Name the action.** What will you do? (create, update, delete, merge, deploy)
4. **State the expected outcome.** What does success look like?
5. **State the rollback.** What do you do if it goes wrong?
6. **Wait for explicit "yes"** before proceeding.

This applies even when:
- The tool claims to be safe or has `--dry-run` defaults
- The change seems small or reversible
- You've already been given broad permission for the session
- The user seems impatient

Example: A tool that writes configuration files across multiple locations is a mutation even if it offers a dry-run mode. Dry-run first, then wait for explicit "yes" before the real operation.

## Read-Only First

Default to read-only operations. Prefer list/get/describe/search/query before any state change. If discovery reveals the need for mutation, apply the gate.

## Evidence After Mutation

After any approved mutation, capture:
- What changed (sanitized output or diff)
- When (timestamp)
- What the user approved (quote or reference the confirmation)

## Verify

- Every mutation in the conversation has a MUTATION label, explicit confirmation, and post-mutation evidence.
- No state-changing action was taken without completing all 6 gate steps.
