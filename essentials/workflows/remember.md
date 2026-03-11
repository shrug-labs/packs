---
name: remember
description: Capture knowledge into persistent memory — for strategic context, decisions, known issues, and observations not yet ready for pack content
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# Remember

Quick capture to persistent memory. Memory only — not packs, not repo docs.

## Prerequisites

- Fork the conversation BEFORE invoking this workflow. The fork is expendable — its only job is the capture.
- If already in a fork, proceed.

## Scope

This workflow writes to **persistent memory only** (memory bank, harness auto-memory). It does NOT write pack content (rules, skills, workflows) or repo docs (AGENTS.md).

Why: Pack content requires deliberate craft — format constraints, validation, behavioral testing, sync. Memory is fast and cheap. Mixing the two in one workflow biases toward the easy path, producing proto-rules that languish in memory instead of becoming real pack content.

## Inputs

- Required: what to remember (user states it, or agent identifies it from context)

## Steps

1. **Classify the capture**

   - **Strategic context:** Decision, direction, positioning, stakeholder note → memory
   - **Project status:** Progress, blockers, completed work → memory
   - **Known issue:** Transient bug, workaround, environment quirk → memory
   - **Observation:** Pattern noticed, not yet confirmed as durable → memory
   - **Correction to memory:** Wrong information in existing memory → update at source

   If the item is any of these, proceed:
   - **Behavioral constraint** (trigger-action pair, agent misbehavior correction)
   - **Executable process** (numbered steps, repeatable procedure)
   - **Domain knowledge** (methodology, reference material)
   - **Repo-specific context** (architecture, build commands for one codebase)

   → **Do not write to memory.** Capture as a pack candidate TODO instead:
   ```
   ## Pack Candidate
   - What: [one-line description]
   - Construct: [rule | skill | workflow]
   - Pack: [which pack it belongs in]
   - Evidence: [observed failure or need that justifies it]
   ```
   Write the TODO to memory as a flagged item, not as the content itself. The actual pack writing happens through knowledge-audit or a dedicated session with pack-content-craft discipline.

2. **Determine destination**

   ```
   Correction to memory content   → find and update at source
   Strategic / project / status   → persistent memory: projects/ or strategy/
   Known issue / workaround       → persistent memory: known-issues
   Observation (not yet durable)  → harness auto-memory (cheapest location)
   Pack candidate TODO            → persistent memory (flagged for future migration)
   ```

3. **Draft the content**

   - Concise, factual, link to source if applicable
   - For corrections: show old text and replacement
   - For pack candidate TODOs: use the template from step 1
   - No imperative voice or trigger-action format — that's pack content format, not memory format

4. **Write to destination**

   Read the target file first. Update existing content if the topic is already covered — do not create duplicates.

5. **Verify**

   Read back the destination file. Confirm the content is present and no duplicates were created.

6. **Done**

   State what was captured and where. If a pack candidate was flagged, note that it needs future attention via knowledge-audit or a pack-writing session.

## Notes

- Keep captures atomic. One thing per remember invocation.
- For corrections: ALWAYS update at source. A correction means stored content is wrong — fix it, don't layer over it.
- If you find yourself wanting to write detailed methodology or step-by-step instructions, stop. That's pack content. Flag it as a TODO and move on.
