---
name: mcp-config-constraints
description: Portability, wiring, and allowlist requirements for MCP server configuration
paths:
  - "**/.mcp.json"
  - "**/.mcp/*.json"
  - "**/mcp/**"
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# MCP Config Constraints

## Portability

- No absolute paths. Use `{env:HOME}`, `{env:TOKEN}`, or relative paths.
- No hardcoded secrets, tokens, or credentials. Use environment variable placeholders.
- Config must work on any machine with the right env vars set.

## Wiring a New Server

1. Add the server config with minimal tool allowlist.
2. Validate with a read-only call (list/search/get) before using in workflows.
3. If the read-only call fails (401/403), fix auth before proceeding — do not retry hoping for a different result.

## Tool Allowlists

- Prefer explicit tool allowlists per server over granting full access.
- Read-only tools first. Add write tools only when a workflow requires mutation.
- Document why each write tool is included.

## After Config Changes

- Harness restart is likely required for MCP config changes to take effect.
- Re-run a read-only warmup call to confirm the server is reachable after restart.

## Verify

- Portability test: does the config contain any absolute paths or literal secrets? If yes, replace with placeholders.
- Connectivity test: can a read-only call succeed against each configured server?
