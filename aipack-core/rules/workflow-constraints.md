---
name: workflow-constraints
description: Frontmatter, structure, gates, and delegation requirements for pack workflows
paths:
  - "**/workflows/**"
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# Workflow Constraints

## Frontmatter

Required for all workflows:

```yaml
---
name: <workflow-name>
description: <what the workflow accomplishes>
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---
```

- `name` — matches filename (without `.md`), kebab-case. Becomes the slash command name.
- `description` — what the workflow accomplishes, one sentence.

Optional:
- `metadata.harnesses` — list of harnesses this workflow was tested with (informational).

Every edit to a workflow must leave frontmatter conformant. No "I'll add metadata later."

## Structure

- Numbered steps. Each step: one action, one specific tool or command.
- No prose between steps. A workflow is not a tutorial.
- Decision trees at branch points — never "or equivalent", "or language-appropriate".
- Explicit tool invocations: exact command, MCP tool name, or unambiguous instruction.

## Gates

- Workflows that include state-changing steps must prescribe a mutation gate in those steps: stop, label as MUTATION, confirm before proceeding.
- Verification gate at completion: specific command + expected exit code, not "ensure success".
- Entry conditions: what must be true before starting. Exit criteria: what the workflow produces.

## Delegation

- Complex sub-tasks → invoke a skill. Don't embed methodology in workflow steps.

## Verify

- Execution test: can an agent follow this workflow without asking clarifying questions?
- Determinism test: two agents running this workflow on the same input should produce equivalent results.
