---
name: memory-bank
description: Persistent memory routing — what knowledge goes where, when to retrieve it
metadata:
  owner: shrug-labs
  last_updated: 2026-03-23
---

# Memory Bank

Location: `~/.config/aipack/memory-bank/` — lives under aipack's config directory, persists across sessions, projects, and harnesses.

## Routing Table

| Knowledge type | Location | NOT here |
|---|---|---|
| Project status, decisions, context | `~/.config/aipack/memory-bank/projects/` | pack content |
| Strategic direction, multi-project plans | `~/.config/aipack/memory-bank/strategy/` | pack content |
| Reference material, patterns | `~/.config/aipack/memory-bank/reference/` | pack content |
| Behavioral corrections from user | `~/.config/aipack/memory-bank/feedback/` | pack content |
| User profile knowledge | `~/.config/aipack/memory-bank/user/` | pack content |
| Recurring issues with known fixes | `~/.config/aipack/memory-bank/known-issues.md` | pack content |
| Permanent external limitations | `~/.config/aipack/memory-bank/constraints.md` | pack content |
| Behavioral rules, skills, workflows | `~/.config/aipack/packs/` | memory bank |
| Repo-specific developer context | That repo's AGENTS.md / CLAUDE.md | memory bank |

## Decision Tree

Before persisting knowledge:

1. Is it a behavioral rule, skill, or workflow? → Pack content (`~/.config/aipack/packs/`)
2. Is it specific to one repo's codebase? → That repo's AGENTS.md
3. Everything else worth remembering → `~/.config/aipack/memory-bank/`

If step 3: re-check. Does it contain trigger-action pairs, numbered steps, or a methodology? → It's pack content, not memory. See memory-bank skill for anti-examples.

## Retrieval Imperative

Before starting work that involves project context, strategic direction, or operational issues — check relevant memory-bank files first. Don't rely on conversation context or inference for information that may already be captured. Use frontmatter descriptions and filenames to select; don't read everything.

## File Format

All files in `~/.config/aipack/memory-bank/` require YAML frontmatter. See memory-bank skill for the schema and conventions.

## Inbox Lifecycle

Harness auto-captures land in `~/.config/aipack/memory-bank/inbox/`. During knowledge audits or session retros, classify and promote items to curated directories (`projects/`, `reference/`, `strategy/`, `feedback/`, `user/`). Promoted items are removed from inbox.

## Session Protocol

- Read existing memory-bank files before creating new ones.
- Update on significant learning — do not wait for session end.
- One SSOT per piece of knowledge. If it exists in a pack, do not duplicate in memory-bank.
- Deleting memory-bank files requires user confirmation.

## Verify

- Knowledge is stored in one location only.
- Memory-bank files do not contain content that should be pack rules, skills, or workflows.
- All files have valid YAML frontmatter.
