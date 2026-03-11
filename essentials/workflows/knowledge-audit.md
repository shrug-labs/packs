---
name: knowledge-audit
description: Audit persistent memory and knowledge stores for misplaced, stale, or misclassified content — classify, propose migrations, execute with confirmation
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# Knowledge Audit

Periodic audit of knowledge stores. Finds content in the wrong place and migrates it.

## Prerequisites

- knowledge-hygiene skill (this pack) — provides classification framework and routing decision tree
- Serial execution required — the auditing agent needs full context across all locations

## Steps

1. **Enumerate locations**

   Identify all knowledge stores in the current environment:
   - Persistent memory (cross-session stores, memory banks, knowledge bases)
   - Harness auto-memory (session/project-scoped memory files)
   - Pack source directories (all packs)
   - Repo-scoped agent config (AGENTS.md, CLAUDE.md in active repos)

   List each location and its purpose. No reads yet — just build the inventory.

2. **Scan each location**

   For each store, read every file. For each item (file or distinct section), record:
   - Location (file path + section heading if multi-section file)
   - One-line summary of content
   - Last modified (git log or file timestamp)

   Present the inventory as a table grouped by location. Do not classify yet.

3. **Classify**

   Invoke the knowledge-hygiene skill. For each item, apply the classification categories and routing decision tree. Record:
   - Current location
   - Actual category (from the skill's framework)
   - Correct destination (from the routing tree)
   - Verdict: `correct` | `migrate` | `prune` | `revisit`

   Present ONLY items where verdict is NOT `correct`. Group by verdict:
   - **Prune** — superseded or duplicate. Show what replaces it.
   - **Migrate** — wrong location. Show source, destination, and transform needed.
   - **Revisit** — not ready to move. Show why and what signal would trigger re-evaluation.

   If all items are `correct`, state that and stop. Not every audit finds debt.

4. **Propose migrations**

   For each `prune` item:
   - What's being removed
   - What replaces it (confirm replacement exists — read it)

   For each `migrate` item:
   - Source → destination
   - Transform needed (per the skill's transform guidance table)
   - Draft the transformed content (or describe the transform if content is long)

   For each `revisit` item:
   - Why it's not ready
   - Revisit trigger

   MUTATION GATE: Present the full proposal as a table. Wait for explicit approval. User may approve all, approve selectively, modify destinations, or defer items.

5. **Execute approved changes**

   Order: prune first, then migrate. This prevents writing content that duplicates something about to be deleted.

   **For each prune:**
   - Confirm replacement is current (read it)
   - Delete the stale item
   - If git-tracked, stage the deletion

   **For each migration:**
   - Read source content
   - Transform to destination format (apply the skill's transform guidance)
   - Write to destination
   - If pack content was written: run pack validation (e.g., `aipack doctor`)
   - Update or delete source:
     - If source location is still consulted by other processes → replace with one-line pointer to new location
     - If source location has no other consumers → delete

   Each write is a separate mutation. If batch approval was given, proceed without per-item confirmation. Otherwise, confirm each.

6. **Post-migration validation**

   - Re-scan each location from step 2. Confirm no items classified as `migrate` remain in their original location.
   - If any pack content was written: run `aipack doctor` — must exit 0.
   - If any pack content was written: note that harness sync is needed (do not auto-sync — that's a separate mutation).
   - If any repo docs were updated: note files for commit.
   - Read back each destination to confirm content landed correctly.
   - Report any validation failures — fix before proceeding.

7. **Summary**

   | Metric | Count |
   |--------|-------|
   | Items audited | |
   | Correct (no action) | |
   | Migrated | |
   | Pruned | |
   | Deferred (revisit) | |

   List locations that need: commits, PRs, pack sync, or manual follow-up.

## Notes

- Run this after extended work periods, before publishing packs, or when you notice knowledge debt accumulating.
- This workflow writes pack content when migrating. Pack content should meet the bar defined by the pack-content-craft skill (if available). For migrations that require significant rewriting, flag them as pack-candidate TODOs rather than writing low-quality pack content in the audit.
- If audit reveals 5+ migrations, consider batching by destination pack to minimize validation/sync cycles.
