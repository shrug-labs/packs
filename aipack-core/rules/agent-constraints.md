---
name: agent-constraints
description: Frontmatter, tool restrictions, scope, and verification requirements for pack agents
paths:
  - "**/agents/**"
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# Agent Constraints

## Frontmatter

Required for all agent definitions:

```yaml
---
name: <agent-name>
description: <purpose and scope>
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---
```

- `name` — matches filename (without `.md`), kebab-case.
- `description` — when to use this agent and what it does.

Optional functional fields:
- `skills` — list of skill names to preload into agent context.
- `mcp_servers` — list of MCP server names available to agent.
- `disallowed_tools` — list of tools/patterns to deny (portable denylist).
- `metadata.harnesses` — list of harnesses this agent was tested with (informational).

Every edit to an agent definition must leave frontmatter conformant. No "I'll add metadata later."

## Tool Restrictions

- An agent without tool restrictions has no constraint value — it's a prompt, not an agent.
- Use `disallowed_tools` to deny tools the agent should not use. Supports glob patterns (e.g., `atlassian_*`).
- Least privilege: start broad, deny what's unnecessary, tighten when proven.
- If the agent needs the same toolset as the default context → it's a system prompt or skill, not an agent.

## Scope and Persona

- First paragraph of body: what this agent does AND what it does not do.
- Define the operational posture: read-only observer, mutation-gated operator, etc.
- If the agent can mutate state, it must include its own mutation gate (stop + confirm).

## Domain Specialist, Not Tool Holder

- Include domain knowledge via `skills` frontmatter — agents without loaded context are tool filters.
- Define output contract in body — callers must know the response format.
- Before creating a tool-only agent: would a skill invocation achieve the same result without the agent overhead?

## Verify

- Constraint test: remove the agent definition, give the same task to default context. If behavior is identical, the agent adds no value.
- Privilege test: can the agent accomplish its task with fewer tools? If yes, tighten the allowlist.
