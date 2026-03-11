# Pack Authoring Standard

Prescriptive standard for authoring pack content (rules, skills, workflows, agents, MCP configs, docs).

## Quality principles

All pack artifacts must be:

- **Actionable**: operators can follow steps without guessing.
- **Verifiable**: success criteria are explicit and machine-checkable when possible.
- **Safe by default**: least privilege, no secrets, no accidental mutation.
- **Portable**: no absolute paths; no user/machine assumptions.

## Voice & tone

Write in consumer-facing, prescriptive language.

- Use imperative verbs for steps.
- State obligations with "must / must not".
- Put constraints and required outputs before the steps.
- Never write meta-breaking prose ("as an AI/agent...", "I will...", "here is my thought process...").

Examples:

- "You must run validation and fix all findings before pushing."
- "Do not paste tokens, keys, or credential material. Use `{env:VAR}` placeholders."
- "If a step mutates state, require an explicit confirmation step before it."

## Non-negotiables

### Secrets

- Never commit secrets (tokens, passwords, private keys, `.env`, credential files).
- Represent sensitive values only as placeholders (`{env:MY_TOKEN}`) or local-file references documented as operator-provided.

### Portability

- No absolute paths (`/Users/...`, `/home/...`, `C:\\Users\\...`).
- Use relative paths inside the pack or placeholders like `${HOME}` / `{env:HOME}`.

### Least privilege

- Default to read-only tooling and instructions.
- Keep tool allowlists minimal and explicit.
- Separate read-only discovery from write/destructive actions.
- Require explicit operator confirmation before any mutation step.

## Standard structure for operator-facing markdown

1. **Scope** (what this file applies to)
2. **When to use / When not to use** (entry criteria)
3. **Prerequisites** (inputs, environment, required tools)
4. **Steps** (numbered when sequence matters)
5. **Verify** (deterministic checks and pass criteria)
6. **Failure modes** (at least one common failure + recovery)
7. **References** (canonical links; avoid duplicating inventories)

## Progressive disclosure quality contract

Content is organized in layers: rules/workflows (always loaded) -> skills/SKILL.md (loaded on demand) -> skill facets/subresources (loaded from SKILL.md). Each deeper layer must meet or exceed the quality of the layer above it:

- A routing rule promises the target resource delivers. The target must honor that promise.
- A SKILL.md that routes to a facet file is making a quality claim about that facet. If the facet is vague or incomplete, the routing is a lie.
- Quality does not degrade with depth. If a rule has a verify section, every facet it routes to must also have one.

## Frontmatter standard

All markdown under `agents/`, `rules/`, `workflows/`, `skills/` must have YAML frontmatter (`---` delimiter).

### Universal fields (all constructs)

| Field | Required | Description |
|---|---|---|
| `name` | Yes | Identifier, kebab-case, matches filename or directory name |
| `description` | Yes | Purpose (rules/agents/workflows) or trigger conditions (skills) |
| `metadata.owner` | Yes | Team/person responsible, e.g. `myteam/jdoe` |
| `metadata.last_updated` | Yes | ISO date (`YYYY-MM-DD`) |
| `metadata.harnesses` | No | List of harnesses tested with (informational, e.g. `[claudecode, opencode]`) |

### Construct-specific fields

**Rule** (`rules/*.md`) — optional:
- `paths` — array of globs for conditional activation (honored by Claude Code and Cline)

**Agent** (`agents/*.md`) — optional:
- `skills` — list of skill names to preload
- `mcp_servers` — list of MCP server names available to agent
- `disallowed_tools` — list of tools/patterns to deny (portable denylist)

**Skill** (`skills/**/SKILL.md`) — no additional fields. `name` must match directory name.

**Workflow** (`workflows/*.md`) — no additional fields. `name` becomes the slash command.

## Templates

### Rule (`rules/<name>.md`)

```markdown
---
name: <rule-name>
description: <what this rule enforces>
paths:
  - "<glob pattern>"
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---

# <Rule title>

## Scope

- Applies to: <explicit scope>

## Requirements

- You must: <requirement>
- You must not: <prohibited behavior>

## Verify

- <how to check compliance>
```

### Skill (`skills/<skill-name>/SKILL.md`)

```markdown
---
name: <skill-name>
description: Use when <triggering conditions>...
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---

## When to use

- <entry criteria>

## Procedure

1) <imperative step>

## Verify

- Run: `<verification command>`
- Pass criteria: <what must be true>

## Failure modes

- If <failure>: <recovery>
```

### Agent (`agents/<name>.md`)

```markdown
---
name: <agent-name>
description: <purpose and scope>
disallowed_tools:
  - <tool_name>
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---

## When to use

- <entry criteria>

## When not to use

- <out-of-scope criteria>

## Steps

1) <imperative step>

## Verify

- <command or observable output>

## Failure modes

- If <common failure>: <recovery steps>
```

### Workflow (`workflows/<name>.md`)

```markdown
---
name: <workflow-name>
description: <what the workflow accomplishes>
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---

## Inputs

- Required: <inputs>

## Steps

1) <imperative step>
2) If a step mutates state, stop and ask for explicit confirmation.

## Verify

- Run: `<verification command(s)>`
- Pass criteria: <explicit expected output>

## Done when

- <observable outcomes>
```

## Per-vector checklists

### Agents

- Include `disallowed_tools` to restrict the default toolset.
- Document: when to use, when not to use, inputs, steps, verify, failure mode.

### Skills

- Keep the skill self-contained; prefer `./...` references within the skill folder.
- Include at least one deterministic verification step.

### Workflows

- State inputs and defaults.
- Include a "Verify" section with machine-checkable checks where possible.
- Separate discovery vs mutation; require explicit confirmation before mutation.

### Rules

- State scope and activation conditions.
- Include an explicit compliance check ("Verify").

### Docs

- Use scannable headings and put the fast path first.
- Avoid duplicating inventories; link to canonical sources.
