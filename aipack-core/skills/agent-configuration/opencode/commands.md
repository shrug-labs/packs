# OpenCode commands (custom slash commands)

OpenCode supports custom commands defined either in config JSON or as Markdown files.

## Where they live (scoping)

- Global: `~/.config/opencode/commands/`
- Per-project: `.opencode/commands/`

The filename becomes the command name (e.g., `test.md` → `/test`).

## Command options

Commands can set:
- `description` (shown in the UI)
- `agent` (which agent runs the command)
- `subtask` (force subagent execution to keep primary context clean)
- `model` (override model)

The Markdown body is the prompt template.

## Prompt template features

- `$ARGUMENTS`, `$1`, `$2`, … for arguments
- `@path/to/file` to inline file content
- `!`shell command`` to inline shell output (runs in project root)

Docs: https://opencode.ai/docs/commands/
