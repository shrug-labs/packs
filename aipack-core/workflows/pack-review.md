---
name: pack-review
description: Systematic review of a pack at three levels — ecosystem fit, internal coherence, and content quality
metadata:
  owner: shrug-labs
  last_updated: 2026-03-10
---

# Pack Review

## Inputs

- Required: pack path or name (e.g., `personal-foundation`, `user`, or full path)
- Optional: specific level to focus on (ecosystem, coherence, content)

## Steps

1. **Load pack manifest**
   Read `pack.json` at the pack path. Inventory all content vectors (rules, skills, workflows, agents, MCP).
   List file count per vector.

2. **Identify ecosystem**
   List all other packs at `~/.config/aipack/packs/`. Note which are currently synced to the active harness.
   Read each pack's `pack.json` to understand scope overlap.

3. **Level 1: Ecosystem fit**
   Use pack-content-craft skill, specifically review-guide.md Level 1 criteria.
   - Check for rule overlap across packs
   - Check for skill description overlap (ambiguous triggers)
   - Calculate total always-on token budget across all loaded packs
   - Flag dependencies and conflicts
   Report findings before proceeding.

4. **Level 2: Internal coherence**
   Read ALL content files in the pack.
   Use review-guide.md Level 2 criteria.
   - Check cross-references (do workflows reference existing skills?)
   - Check for contradictions between rules and skills
   - Check profile coverage (if profiles exist)
   - Assess token balance (rules vs skills ratio)
   Report findings before proceeding.

5. **Level 3: Content quality**
   For each piece of content, apply review-guide.md Level 3 criteria.
   - Three behavioral tests (removal, specificity, rationalization)
   - Per-construct checklist
   Report findings per file.

6. **Produce review summary**
   Consolidate all findings:
   - Grouped by severity (must-fix, should-fix, nit)
   - Each finding: level, file, evidence, specific recommendation
   Present summary for discussion.

## Verify

- Every content file in the pack was read and evaluated
- Findings include specific evidence (quoted text, line numbers)
- Recommendations are actionable (not "improve this")

## Notes

- This workflow invokes the pack-content-craft skill. If that skill is not available, the review cannot proceed — the criteria live there.
- For large packs (10+ files), focus Level 3 on content changed since last review. Use git history to identify changes.
- Do NOT fix issues during review. Report them. Fixes are a separate task.
