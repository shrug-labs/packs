---
name: extract-memory-to-packs
description: Extract stable knowledge from memory-bank and external memory sources into governed pack content
metadata:
  owner: shrug-labs
  last_updated: 2026-03-23
---

# Extract Memory to Packs

Crystallize knowledge from `~/.config/aipack/memory-bank/` into pack content (rules, skills, workflows).

## Inputs

- **Source locations:** `~/.config/aipack/memory-bank/` (curated directories and `inbox/`), plus any external memory sources (harness auto-memory, conversation transcripts, other persistent stores)
- **Target pack:** Which pack to write to (e.g., `~/.config/aipack/packs/<your-pack>/`)
- **Scope:** Full scan, specific directory, or specific files

## Prerequisites

- Load the memory-bank skill for category definitions, anti-examples, and deprecation flow.
- Load the pack-content-craft skill before drafting any pack content.

## Steps

1. **Scan sources for promotable content**

   Read all files in `~/.config/aipack/memory-bank/` curated directories (`projects/`, `reference/`, `strategy/`, `feedback/`, `user/`) and `inbox/`.

   For each file, identify knowledge candidates — sections or patterns that match pack constructs rather than memory.

2. **Classify each candidate**

   Apply the memory-bank rule's decision tree in reverse — identify knowledge that should NOT be in memory:

   | Content pattern | Classification | Pack construct |
   |----------------|---------------|----------------|
   | "When X happens, do Y" / trigger-action pairs | Behavioral constraint | Rule |
   | Numbered steps, repeatable process | Process | Workflow |
   | Methodology, reference framework, on-demand knowledge | Methodology | Skill |
   | Constrained tool-using persona, delegation target | Persona | Agent |
   | Strategic context, project status, observations | Stays in memory | -- |
   | Stale, superseded, or completed | Prune candidate | -- |

   Weight the scan toward high-value constructs: skills (methodology, frameworks, decision trees) carry the most knowledge and are hardest to discover by pattern-matching. Workflows (repeatable processes) are next. Rules (trigger-action pairs) are easiest to spot but often produce low-value one-liner additions. Don't let rule-hunting crowd out skill and workflow extraction.

   Present the classification table to the user with:
   - Source file and section
   - Proposed classification
   - Target pack and construct (if promoting)
   - Confidence level (high/medium/low)

   Wait for approval before proceeding.

3. **Draft pack content for approved candidates**

   For each approved candidate:
   - Determine the target pack and construct type
   - Check existing pack content for overlap — extend rather than duplicate
   - Draft following pack-content-craft standards:
     - YAML frontmatter (name, description, metadata)
     - Imperative voice, concrete actions
     - Verify section with deterministic checks
     - Budget: ≤50 lines for rules, ≤500 lines for skills
   - Present each draft for review

   MUTATION: Creating or modifying pack content files. Show exact file path and content diff. Wait for approval per candidate.

4. **Write to target pack**

   Write approved content to `~/.config/aipack/packs/<pack>/<construct>/<name>.md` (or `<name>/SKILL.md` for skills).

   Update the pack's `pack.json` manifest to include any new resources.

5. **Mark sources as migrated**

   For memory-bank files that are fully promoted:
   - Before marking a file as fully promoted, enumerate every section and fact in the file. Confirm each is either (a) present in a pack construct or (b) explicitly valueless. "Most of it is in the skill" is not sufficient — residual knowledge compounds into loss across audit cycles.
   - Add deprecation callout per the memory-bank skill deprecation flow
   - Do NOT delete yet — wait for sync verification

   For partially promoted files:
   - Remove only the promoted sections
   - Leave remaining content in place

   For inbox files that are fully promoted:
   - Delete the file from `inbox/`
   - Update `inbox/MEMORY.md` if it has an entry

   MUTATION: Modifying memory-bank files. Show changes. Wait for confirmation.

6. **Verify**

   - Run `aipack sync --dry-run` to confirm new pack content syncs correctly
   - Confirm no duplicate knowledge across memory-bank and pack
   - Confirm pack.json includes new resources
   - Confirm deprecated memory-bank files have the migration callout

## Done When

- All approved candidates are written to the target pack with proper frontmatter and structure
- Pack manifest updated with new resources
- Source files marked as migrated or pruned
- `aipack sync --dry-run` shows new content would deploy correctly

## Failure Modes

- **Candidate too raw for pack content**: Leave in memory-bank. Note as "not yet ready" in the classification table. Revisit next cycle.
- **Existing pack content overlaps**: Extend the existing content. Do not create a parallel file. Check with Grep before writing.
- **aipack sync fails after adding content**: Check pack.json syntax and file paths. Run `aipack doctor` for diagnostics.
- **User rejects classification**: Adjust and re-present. The user's judgment on readiness overrides automated classification.
