# Claude Code harness

## Where config lives

- Global settings: `~/.claude/settings.json` (permissions, hooks, environment variables)
- Project settings: `.claude/settings.json` (same schema, project-scoped)
- Project rules: `CLAUDE.md` at repo root (always loaded), `AGENTS.md` (same behavior)
- Conditional rules: `.claude/rules/*.md` with optional `paths` glob frontmatter for file-scoped activation
- User rules: `~/.claude/CLAUDE.md` (loaded in every project)

Settings merge: project settings layer on top of global settings.

## MCP configuration

- Config file: `~/.claude.json` under `mcpServers` key (global)
- Project-level: `.mcp.json` at repo root
- Each server entry: `command`, `args`, `env` (use env var placeholders, not raw secrets)
- Tool allowlists: managed via `allowedTools` / `disallowedTools` in settings or agent definitions

## Agents

- Location: `.claude/agents/*.md`
- Frontmatter: `name`, `description` (required), plus optional `skills`, `mcpServers`, `disallowedTools`, `permissionMode`, `maxTurns`, `model`, `memory`, `isolation`, `hooks`
- Agents appear as `/agent:<name>` in the session

## Skills

- Location: `.claude/skills/<name>/SKILL.md` (synced from pack source)
- Loaded via the Skill tool at invocation time, not pre-loaded
- Trigger matching uses frontmatter `name` + `description`
- Slash-command invocation: user types `/<skill-name>`, harness routes through Skill tool

## Commands (workflows)

- Location: `.claude/commands/*.md`
- Invoked as `/<command-name>` (user-facing slash commands)
- Support `argument-hint`, `agent`, `model`, `context` (`fork`), `allowed-tools`, `user-invocable`, `disable-model-invocation`

## Hooks

- Defined in `~/.claude/settings.json` under `hooks` key
- Hook points: `PreToolUse`, `PostToolUse`, `Notification`, `Stop`
- Each hook: `command` (shell), `matcher` (tool name pattern), `timeout`
- Use for formatting, validation, secret scanning, policy enforcement

## Key differences from other harnesses

- Conversation forking: any message can be forked into a new branch (design choices stay rewindable)
- No configurable slash commands for routing — `/` prefix triggers built-in skill/command lookup
- `paths` glob on rules enables conditional rule loading per file being touched (known bugs: may load globally regardless, only triggers on Read not Write/Edit, ignored in user-level rules)
- MCP config lives in `~/.claude.json`, not in settings.json

## Authoritative docs
- https://docs.anthropic.com/en/docs/claude-code
