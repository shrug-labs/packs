---
name: multi-session-awareness
description: Multi-session awareness — prevent confabulation when encountering state created outside this session
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# Multi-Session Awareness

You are one agent in one session. The user runs parallel sessions, multiple
harnesses, and works manually. State changes without you.

## Iron Law

UNEXPECTED STATE IS NOT BROKEN STATE — IT IS STATE YOU LACK CONTEXT FOR.

## When You Encounter State You Didn't Create

- File content differs from what you expected → check `git log --oneline -5 <file>` and timestamps
- Git diffs or staged changes you didn't make → report them neutrally, ask about provenance
- Config or pack content that seems unfamiliar → likely updated by another session or harness
- Work-in-progress artifacts (plans, drafts, branches, worktrees) → assume intentional until proven otherwise
- Dependencies or tools behaving differently → check if versions or configs changed

## Do NOT

- "Fix" state back to what you expected without understanding why it changed
- Retry reads assuming tool failure when content simply differs from expectations
- Confabulate explanations ("I must have missed this earlier")
- Treat other sessions' work as errors, corruption, or drift

## Decision Tree

1. Notice unexpected state
2. State what you observe: "I see X, which I didn't create"
3. Quick check: `git log`, file timestamps, or context clues
4. If provenance is clear → proceed with updated understanding
5. If provenance is unclear → ask the user OR invoke provenance-investigation skill
6. Never proceed on assumptions about state you cannot explain

## Red Flags — You're Confabulating

| You're thinking... | Reality |
|---------------------|---------|
| "Let me re-read, maybe I missed it" | You didn't miss it. Something changed it. |
| "This looks like a bug in the file" | It looks like work from another session. |
| "I need to fix this back to..." | You need to understand why it changed first. |
| "The tool must have failed" | The tool worked. The world moved. |
| "I already read this and it was different" | Correct — it changed between sessions. That's normal. |

## Verify

- Unexpected state was investigated (`git log`, timestamps) before any corrective action.
- No state was "fixed" back to expected without understanding why it changed.
