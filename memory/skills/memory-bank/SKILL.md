---
name: memory-bank
description: Use when working with ~/.config/aipack/memory-bank/ content — organizing, reviewing, deprecating, or deciding what belongs where versus in packs
metadata:
  owner: shrug-labs
  last_updated: 2026-04-01
---

# Memory Bank

On-demand reference for working with the persistent memory bank at `~/.config/aipack/memory-bank/`.

## When to Use

- Reviewing or reorganizing memory-bank content
- Deciding whether new knowledge belongs in memory-bank or elsewhere
- Deprecating memory-bank content that has been promoted to a pack
- Understanding memory-bank categories and conventions

## When NOT to Use

- Writing pack content — use pack-content-craft skill
- Quick reads of a specific memory-bank file — just read it
- Routing decisions only — the memory-bank rule handles routing; this skill handles methodology

## Categories

| Directory | Purpose | Examples |
|-----------|---------|---------|
| `projects/` | Deep context for active projects — design decisions, status, audit trails | `auth-rewrite.md`, `api-v3-migration.md` |
| `strategy/` | Long-term direction, multi-project positioning, roadmaps | `platform-direction.md` |
| `reference/` | Reusable knowledge extracted from project work; patterns, conventions | `tool-inventory.md`, `deployment-topology.md` |
| `feedback/` | Behavioral corrections from the user — guidance that should change agent behavior across sessions | `no-mocking-db.md`, `terse-responses.md` |
| `user/` | User profile knowledge — role, preferences, expertise that informs how to collaborate | `role-and-expertise.md` |
| `inbox/` | Harness auto-captures — fleeting notes promoted to curated directories during audits | Auto-generated files from `autoMemoryDirectory` |
| `known-issues.md` | Fixable issues — operational blockers with known or planned resolutions (single file) | build tool version conflict, flaky test workaround |
| `constraints.md` | Permanent external limitations — platform behaviors, policy restrictions, API quirks we work around (single file) | CI provider rate limits, SSO token expiry, third-party API pagination limits |
| `pack-candidates.md` | Curated promotion queue — observations ready to crystallize into pack content (single file) | Entries with construct type, target pack, observed failure, priority |
| `archive/` | Cold storage — knowledge no longer active but preserved for historical retrieval | `archive/2026-04/12-1430-aipack-sync-design.md` |

## File Format

All files require YAML frontmatter:

```yaml
---
name: descriptive-slug
description: One-line summary — specific enough to decide relevance without opening the file
type: project | reference | strategy | feedback | user
metadata:
  created: 2026-04-04T14:30-08:00
  last_updated: 2026-04-04T16:45-08:00
---
```

Fields:
- `name`: matches filename without `.md` extension
- `description`: used for scanning — be specific, not generic
- `type`: determines retention policy and retrieval priority
- `metadata.created`: ISO 8601 datetime with timezone offset when the file was first written
- `metadata.last_updated`: ISO 8601 datetime with timezone offset of most recent substantive change

Datetime format is `YYYY-MM-DDTHH:MM±HH:MM` — always include explicit timezone offset (e.g. `-08:00` for PST, or `Z` for UTC).

Body content follows the frontmatter. Use inline status labels where applicable: `**Status:** Phase 2 complete (2026-03-09)`.

Additional conventions:
- Descriptive slugs for filenames: `aipack-core-migration.md`, not `migration.md`
- Date stamps in content, not in filename (exception: archive files use `DD-HHMM-` prefix)
- Cross-references use relative paths within memory-bank, `~/` paths for external locations
- `MEMORY.md` is the index file — pointers and brief descriptions only, no memory content

## Retrieval Guidance

When to proactively read memory-bank files:

| Task type | Check first | Why |
|-----------|------------|-----|
| Starting work on a known project | `projects/<project>.md` | Design decisions, status, prior blockers |
| Strategic or positioning questions | `strategy/` | Direction documents inform recommendations |
| Hitting an error or unexpected behavior | `known-issues.md` | May be a known issue with a workaround |
| Hitting a platform or API limitation | `constraints.md` | May be a known permanent constraint with a workaround |
| Evaluating a new tool, platform, or pattern | `reference/` | Prior research may already exist |
| Writing or reviewing pack content | `pack-candidates.md` | Candidate may already be queued with evidence |
| User corrects agent behavior | `feedback/` | May already be captured; update rather than duplicate |
| Tailoring response to user context | `user/` | Role, expertise, and preferences inform approach |
| User references prior conversation | Scan frontmatter descriptions across directories | Find the relevant capture |

Don't read everything every session. Use frontmatter descriptions and filenames to select relevant files.

## Anti-Examples

Things found in memory-bank that don't belong:

| Found in memory | Why it was wrong | Correct home |
|----------------|------------------|-------------|
| "Superseded by pack skill X" reference doc | Explicitly superseded — just delete | Nowhere (prune) |
| Go package architecture for one repo | Repo-specific developer context | That repo's AGENTS.md |
| "Agent can't fix this — tell user to run Y" | Trigger-action pair = behavioral constraint | Pack rule or skill |
| Pack design principles (runtime model, survivability) | Pack authoring methodology | Pack skill |
| Step-by-step deploy procedure | Repeatable process = workflow | Pack workflow |
| Reference data consumed by one specific skill | Unbundled skill reference — loads only at activation in `references/` | That skill's `references/` directory |
| Session-specific state (current task, temp branches) | Ephemeral, not cross-session | Don't persist — stays in conversation context |

## Protocol

### Read Before Write

Before creating a new file, search existing memory-bank files for related content. Prefer updating an existing file over creating a new one.

### Handling Upstream Renames

When an upstream entity (service, tool, repo) is renamed, don't cascade the rename across all memory files. Add a dated note instead: "Note (YYYY-MM-DD): X renamed to Y upstream." Only cascade when the old name would cause a concrete failure (broken commands, wrong API endpoints).

### Deprecation Flow

When memory-bank content is promoted to a pack:

1. Add a deprecation callout at the top of the memory-bank file:
   ```
   > **Migrated to pack:** [target pack/construct] (date).
   > This file is no longer the SSOT. Delete after confirming the pack content is synced and working.
   ```
2. Do NOT delete the memory-bank file immediately — the pack content must be synced and verified first.
3. After verification, delete the memory-bank file (with user confirmation per the memory-bank rule).

### Retention

- `known-issues.md`: Remove entries when the issue is resolved. Keep the file lean. Items that turn out to be unfixable graduate to `constraints.md`.
- `constraints.md`: Long-lived. Update workarounds as they improve. Remove only when the external binding changes (platform upgrade, policy change). Each entry has a "Bound to" field identifying what makes it permanent.
- `projects/`: Archive when the project is complete and useful knowledge has been extracted. Delete only if the project context has zero future retrieval value.
- `reference/`: Archive when superseded or when historical context has value. Delete only when fully migrated to pack content and the memory adds nothing the pack doesn't carry.
- `strategy/`: Long-lived. Update as direction evolves. Archive when direction is abandoned (the evolution of thinking has value).
- `feedback/`: Long-lived. Delete when the correction is embedded in pack content (a rule or skill) and the memory adds no extra context. Feedback doesn't archive — the pack is the SSOT.
- `user/`: Long-lived. Update as the user's role or preferences evolve.
- `inbox/`: Ephemeral. Promote to curated directories during knowledge audits or session retros. Delete after promotion.

## Archive

Cold storage for knowledge that is no longer actively relevant but shouldn't be destroyed. A distinct tier from the active memory bank — different organization, different retrieval strategy, different access patterns.

### Structure

```
archive/
  2026-04/
    12-1430-aipack-sync-design.md
    18-0915-prereq-stack-v23.md
  2026-03/
    28-1100-old-project.md
```

- Organized by `YYYY-MM/` directories (month of archival, not creation)
- Filenames prefixed with `DD-HHMM-` (day and time of archival) for sort order within a month
- Original filename follows the timestamp prefix

### Frontmatter

Archived files retain their original frontmatter and gain:

```yaml
archived: 2026-04-12T14:30-08:00
archive_reason: completed | superseded | promoted | stale
```

- `archived`: when the file was moved to archive
- `archive_reason`: why it left active memory
  - `completed` — project finished, learnings extracted
  - `superseded` — replaced by newer strategy, design, or understanding
  - `promoted` — content migrated to pack; archive preserves historical context the pack doesn't carry
  - `stale` — no longer relevant but may have historical value

### Retrieval

The archive is pull-only. Never proactively scanned. Search the archive only when:

- A topic resurfaces and active memory is insufficient
- Doing explicit historical analysis ("what did we decide about X?")
- A knowledge audit reveals a gap that archived content might fill
- The user asks to recall something from a past project or decision

To search: `grep -ri '<topic>' ~/.config/aipack/memory-bank/archive/`. For broader discovery within a time period: `ls ~/.config/aipack/memory-bank/archive/2026-04/` and scan filenames.

### Archive vs. Delete

| Situation | Archive | Delete |
|-----------|---------|--------|
| Completed project with extracted learnings | Yes — project context may resurface | |
| Superseded strategy doc | Yes — evolution of thinking has value | |
| Feedback promoted to pack content | | Yes — pack is SSOT, memory adds nothing |
| Reference about a point-in-time understanding | Yes — historical context | |
| Reference data that was just wrong | | Yes — no value preserving errors |
| Stale project with no learnings extracted | Extract learnings first, then archive | |

### MEMORY.md

Archived files are removed from MEMORY.md. The archive is outside the active index by design.

## Verify

- No duplicate knowledge across memory-bank and packs.
- Every file in memory-bank has valid YAML frontmatter with all required fields.
- No files marked as deprecated for more than one sync cycle without follow-up.

## Failure Modes

- If unsure whether content is "stable enough" for a pack: leave it in memory-bank. Use the extract-memory-to-packs workflow when ready to promote.
- If memory-bank and pack content conflict: the pack is the SSOT. Update or delete the memory-bank file.
