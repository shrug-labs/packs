---
name: skill-constraints
description: Frontmatter, structure, and content requirements for pack skills
paths:
  - "**/skills/**"
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# Skill Constraints

## Frontmatter

Required for all SKILL.md files:

```yaml
---
name: <skill-name>
description: Use when <triggering conditions>...
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---
```

- `name` — matches directory name, kebab-case.
- `description` — CSO trigger. Start with "Use when...". Under 500 characters. Concrete triggers only.
- Never summarize the skill's methodology in the description — agent will shortcut the body.

Optional:
- `metadata.harnesses` — list of harnesses this skill was tested with (informational).

Every edit to a SKILL.md must leave frontmatter conformant. No "I'll add metadata later."

## Structure

- SKILL.md body under 500 lines. Split heavy reference to separate files in the same directory.
- If supporting files exist, SKILL.md links to them explicitly.

## Content

- Actionable instructions, not background knowledge. If the agent can't act on a paragraph, delete it.
- Decision trees over prose. "When X, do Y" over "X is important because...".
- If needed on every interaction → it's a rule, not a skill. Move it.
- If it's a step-by-step process with numbered steps → it's a workflow, not a skill. Move it.

## Verify

- Trigger test: give the agent a task that should activate this skill. Does the description match?
- Shortcut test: does the agent follow the full body, or just the description? If description summarizes methodology, the agent shortcuts.
