---
name: aipack-guardrails
description: SSOT editing, sync discipline, and content routing rules for pack authoring
metadata:
  owner: shrug-labs
  last_updated: 2026-03-23
---

# aipack Guardrails

## Editing pack content

- Pack source at `~/.config/aipack/packs/<pack>/` is the SSOT — edit here, never in harness locations (`~/.claude/`, `.opencode/`, etc.)
- Before writing or modifying any pack content, invoke the pack-content-craft skill
- No content without observed behavioral evidence — if you haven't seen the agent fail without it, you haven't earned it
- No vague guidance: "consider", "be careful", "or equivalent", "as appropriate" → rewrite with decision trees or exact instructions
- Harness-specific rendering bugs belong in the sync tool (`internal/harness/<name>/`), not in pack source. Pack source is portable SSOT — if a harness renders something wrong, fix the harness adapter.
- Content approval does not skip the delivery pipeline. Even when content has been collaboratively refined and user-approved in a conversation, delivery still requires: invoke pack-content-craft, write to pack SSOT, let `aipack sync` propagate.

## Reasoning about packs

- Before reasoning about pack architecture, composition, or layering, verify against actual sync-config (`~/.config/aipack/sync-config.yaml`) and active profile (`~/.config/aipack/profiles/<default>.yaml`).

## Syncing

- Verify sync-config defaults and active profile before syncing — see aipack-system skill
- Always dry-run first: `aipack sync --dry-run`
- After syncing rules, settings, or MCP config: harness client restart is likely needed
- Never manually create, edit, or delete files in harness-managed locations
- Never manually edit files under `~/.config/aipack/registries/` — these are cached copies of remote sources. Update the source registry repo and run `aipack registry fetch` to propagate.

## Content routing

- Always-on constraint (<60 lines) → rule
- Executable multi-step process → workflow
- On-demand knowledge or methodology → skill
- Constrained tool-using persona → agent
- When uncertain, default to skill (cheapest token budget)

## Verify

- Pack source is the only location where content was edited (not harness locations).
- `aipack sync --dry-run` exits 0 before any actual sync.
