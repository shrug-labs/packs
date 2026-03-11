# Harness Capability Matrix

Reference for how each harness supports pack capability vectors. Consult before making assumptions about what a harness can do.

## Support Matrix

| Vector | OpenCode | Codex | Cline | Claude Code |
|--------|----------|-------|-------|-------------|
| Rules | `.opencode/rules/` individual files | Flattened into `AGENTS.override.md` | `.clinerules/` individual files | `.claude/rules/` individual files (frontmatter preserved) |
| Agents | `.opencode/agents/` individual files | Inlined into `AGENTS.override.md` | `.clinerules/` individual files | `.claude/agents/` (frontmatter transformed) |
| Workflows | `.opencode/commands/` individual files | Inlined into `AGENTS.override.md` | `.clinerules/workflows/` | `.claude/commands/` |
| Skills | `.opencode/skills/<name>/` + JSON `skills.paths` | `.agents/skills/<name>/` | `.clinerules/skills/<name>/` | `.claude/skills/<name>/` |
| MCP | `opencode.json` (JSON) | `config.toml` (`[mcp_servers]` TOML table) | VS Code extension storage (**global only**) | `.mcp.json` (project root) |
| Settings | `opencode.json` (template + merge) | `config.toml` (template + merge) | **Not supported** | `settings.local.json` (template + merge) |
| Plugins | `oh-my-opencode.json` (pure copy) | MCP-only via MergeMode | `cline_mcp_settings.json` (always generated) | `.mcp.json` (always generated) |

## Agent Frontmatter Transformation

Pack agent files use a harness-neutral schema. Each harness transforms during sync:

| Field (pack) | Claude Code | OpenCode | Codex | Cline |
|--------------|-------------|----------|-------|-------|
| `name` | `name` (or from filename) | Pass-through | Inlined heading | Pass-through |
| `tools` (list) | `tools` (list) | Copies as-is | Inlined | Pass-through |
| `disallowed_tools` (list) | `disallowedTools` (list) | Copies as-is | Inlined | Pass-through |
| `skills` (list) | `skills` (list) | Pass-through | N/A | Pass-through |
| `mcp_servers` (list) | `mcpServers` (list) | Pass-through | N/A | Pass-through |

## MCP Tool Control

| Harness | Allow Format | Disable Support | `allow` Means | `deny` Means |
|---------|-------------|-----------------|---------------|-------------|
| OpenCode | `server_toolname: true` (boolean map) | `server_*: false` wildcard | Enable tool | Wildcard disable |
| Codex | `enabled_tools: [...]` per server | `disabled_tools: [...]` | Restrict to listed | Block listed |
| Cline | `alwaysAllow: [...]` per server | **Not exposed** | Auto-approve | N/A |
| Claude Code | `mcp__server__tool` patterns in settings | `mcp__server__tool` deny patterns | Auto-approve (still usable without, just prompts) | Block entirely |

## Scope Support

| Vector | OpenCode | Codex | Cline | Claude Code |
|--------|----------|-------|-------|-------------|
| Rules | Project + Global | Project + Global | Project + Global | Project + Global |
| MCP | Project + Global | Project + Global | **Global only** | Project + Global |
| Settings | Project | Project | N/A | Project |

## Environment Variable Expansion

| Harness | `{env:VAR}` becomes |
|---------|---------------------|
| OpenCode | `$VAR` |
| Codex | `$VAR` (shell-escaped) |
| Cline | `${VAR}` |
| Claude Code | `${VAR}` |

## Critical Constraints

1. **Cline: no project-level MCP** — only global scope
2. **Codex: no JSON Skills/Instructions keys** — rules/agents/workflows flatten to markdown
3. **Cline: no tool disabling** — `alwaysAllow` is allow-only
4. **Plugins bypass `--skip-settings`** — always synced when present
5. **OpenCode: `tools` != `permission`** — `tools` (boolean map) = MCP; `permission` (strings) = native harness tools
6. **Claude Code: MCP config != tool permissions** — `.mcp.json` defines servers; `settings.local.json` controls access via `mcp__server__tool`
7. **Claude Code: deny > allow** — deny always wins regardless of specificity; wildcard deny blocks per-tool allow
