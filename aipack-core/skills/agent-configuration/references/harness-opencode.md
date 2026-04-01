# OpenCode harness

## Commands / workflows (slash commands)

OpenCode supports custom commands defined either in config JSON or as Markdown files.

### Where they live (scoping)

- Global: `~/.config/opencode/commands/`
- Per-project: `.opencode/commands/`

The filename becomes the command name (e.g., `test.md` → `/test`).

### Command options

Commands can set:
- `description` (shown in the UI)
- `agent` (which agent runs the command)
- `subtask` (force subagent execution to keep primary context clean)
- `model` (override model)

The Markdown body is the prompt template.

### Prompt template features

- `$ARGUMENTS`, `$1`, `$2`, ... for arguments
- `@path/to/file` to inline file content
- `` !`shell command` `` to inline shell output (runs in project root)

Docs: https://opencode.ai/docs/commands/

## Where config lives
- Global: `~/.config/opencode/opencode.json`
- Project: `./opencode.json` or `.opencode/` directories (project-local)

Agent definitions (recommended):
- Global: `~/.config/opencode/agents/*.md`
- Per-project: `.opencode/agents/*.md`

Naming constraint: any `*.md` under `agents/` is treated as an agent definition. Keep docs elsewhere.

## Key knobs
- `tools` (availability) + `permission` (ask/allow/deny): keep global default-deny; grant per-agent.
- `instructions`: include your pack's synced rules directory (sync appends this to `opencode.json`; `AGENTS.md` remains in effect).
- `skills.paths`: include your pack's skills directory (sync appends this to `opencode.json`; no skill file copies).

## Session / storage introspection (CLI)
- `opencode debug paths` (resolved roots: config/data/cache/log/state)
- `opencode debug scrap` (list known projects/worktrees)
- `opencode session list` (project-scoped session listing)
- `opencode export <sessionID>` / `opencode import <file-or-share-url>` (portability)

## Common gotchas
- Agent `description` is required; missing descriptions can make agents "disappear" from listings.
- Prefer Markdown agents for ops roles (easier to read/review than JSON).

## Write gate (policy)

Any write action requires an explicit user token:
- `WRITE_INTENT: <scope> <reason>`

## Authoritative docs
- Config precedence + locations: https://opencode.ai/docs/config/
- Tools + permissions: https://opencode.ai/docs/tools/
- Agents: https://opencode.ai/docs/agents/
- Rules (`instructions` + `AGENTS.md`): https://opencode.ai/docs/rules/
- Config schema (`skills.paths`): https://opencode.ai/config.json
