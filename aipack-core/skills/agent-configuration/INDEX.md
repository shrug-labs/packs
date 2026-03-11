# agent-configuration

This is an umbrella skill. Use this index to load only what you need.

## What to load (decision guide)

### If you’re changing tool access / MCP allowlists
- `mcp/INDEX.md`
- `opencode/INDEX.md` (if OpenCode is the harness)

### If you’re enabling vendor/org-specific MCP servers
- See your org’s domain-specific skill (if available). This skill stays framework-agnostic.

### If you’re onboarding a harness
- pick one:
  - `opencode/INDEX.md`
  - `cline/INDEX.md`
  - `cursor/INDEX.md`
  - `codex/INDEX.md`
- then: `validation/INDEX.md`

### If you’re debugging “agent can’t do X”
- `validation/INDEX.md`
- the relevant harness INDEX (opencode/cline/cursor/codex)

### If you’re authoring pack content and need to know what frontmatter fields each harness supports
- `frontmatter-mapping.md`

### If you’re designing a portable, multi-harness setup
- `layers/INDEX.md`
- `validation/INDEX.md`

## Facets
- `layers/` — portable layering model
- `mcp/` — MCP governance (default-deny, ops-agent routing)
- `validation/` — post-change verification checklist
- `frontmatter-mapping.md` — pack frontmatter → harness-native field mapping
- `mcp-inventory.md` — MCP tool inventory and minimization
- `opencode/`, `cline/`, `cursor/`, `codex/` — per-harness configuration notes
