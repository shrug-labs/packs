---
name: remember
description: Capture knowledge into persistent memory — for strategic context, decisions, known issues, and observations not yet ready for pack content
metadata:
  owner: shrug-labs
  last_updated: 2026-04-01
---

# Remember

Quick capture to `~/.config/aipack/memory-bank/`. Memory only — not packs, not repo docs.

## Prerequisites

- If your harness supports conversation branching, branch before invoking this workflow — the branch is expendable, its only job is the capture.
- If already in a branch or your harness doesn't support branching, proceed.

## Scope

This workflow writes to `~/.config/aipack/memory-bank/` only. It does NOT write pack content (rules, skills, workflows) or repo docs (AGENTS.md). See the memory-bank rule for the full routing decision tree.

Why: Pack content requires deliberate craft — format constraints, validation, behavioral testing, sync. Memory is fast and cheap. Mixing the two in one workflow biases toward the easy path, producing proto-rules that languish in memory instead of becoming real pack content.

## Steps

1. **Classify and route**

   | Classification | Destination |
   |---|---|
   | Project status, decision, blocker | `~/.config/aipack/memory-bank/projects/<project>.md` |
   | Strategic direction, positioning | `~/.config/aipack/memory-bank/strategy/<topic>.md` |
   | Reference material, lookup table | `~/.config/aipack/memory-bank/reference/<topic>.md` |
   | Behavioral correction from user | `~/.config/aipack/memory-bank/feedback/<topic>.md` |
   | User profile knowledge | `~/.config/aipack/memory-bank/user/<topic>.md` |
   | Fixable issue, workaround, env quirk | `~/.config/aipack/memory-bank/known-issues.md` |
   | Permanent external limitation (platform, policy, API) | `~/.config/aipack/memory-bank/constraints.md` |
   | Correction to existing memory | Find and update at source |

   If the item is any of these, it is NOT memory — flag as a pack candidate instead:
   - Behavioral constraint (trigger-action pair, agent misbehavior correction) → Rule
   - Executable process (numbered steps, repeatable procedure) → Workflow
   - Domain knowledge (methodology, reference framework) → Skill
   - Constrained tool-using persona or delegation target → Agent
   - Repo-specific context (architecture, build commands for one codebase) → that repo's AGENTS.md

2. **Check for duplicates**

   Search existing memory-bank files for related content. If the topic is already covered, update the existing file rather than creating a new one.

3. **Draft the content**

   For memory captures:
   - Concise, factual, link to source if applicable
   - No imperative voice or trigger-action format — that's pack content format
   - For corrections: show old text and replacement

   Quality bar — every memory file must answer: **why does this matter to a future session?** A bare fact without context ("X uses port 8080") won't help. Include:
   - **Why it matters** — what goes wrong without this knowledge, or what decision it informs
   - **When it applies** — what task or situation makes this relevant
   - **How to verify** — how a future session can check if this is still true

   If you can't articulate why a future session needs it, it's conversation context, not memory.

   For pack candidate flags — append to `~/.config/aipack/memory-bank/pack-candidates.md`:
   ```
   ### [One-line description]
   - **Construct:** rule | skill | workflow
   - **Pack:** which pack it belongs in
   - **Evidence:** observed failure or need that justifies it
   - **Priority:** high | normal | low
   - **Notes:** additional context
   ```

   All new files require YAML frontmatter per the memory-bank skill's file format section. When updating existing files, bump `metadata.last_updated`.

4. **Write**

   MUTATION: Writing to memory-bank. Show the full content. Wait for approval.

   Write the content to the destination.

5. **Verify**

   Read back the destination file. Confirm: content is present, no duplicates, frontmatter is valid.

## Notes

- Keep captures atomic. One thing per remember invocation.
- For corrections: ALWAYS update at source. A correction means stored content is wrong — fix it, don't layer over it.
- If you find yourself wanting to write detailed methodology or step-by-step instructions, stop. That's pack content. Flag it as a pack candidate and move on.
