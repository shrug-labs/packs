---
name: rule-constraints
description: Frontmatter, budget, voice, and structure requirements for pack rules
paths:
  - "**/rules/**"
metadata:
  owner: shrug-labs
  last_updated: 2026-03-09
---

# Rule Constraints

## Frontmatter

Required for all rules:

```yaml
---
name: <rule-name>
description: <what this rule enforces>
metadata:
  owner: <team/person>
  last_updated: <YYYY-MM-DD>
---
```

- `name` — matches filename (without `.md`), kebab-case.
- `description` — human context for pack tooling and discovery.

Optional:
- `paths` — array of globs for conditional loading (honored by Claude Code and Cline). Use `**/construct/**` for portability.
- `metadata.harnesses` — list of harnesses this rule was tested with (informational).

Every edit to a rule must leave frontmatter conformant. No "I'll add metadata later."

## Budget

- 60 lines max. No exceptions.
- Over 60 lines → split: concise rule (seed) + detailed skill (methodology).
- Every line must change agent behavior. Remove lines that restate model defaults.

## Voice

- Imperative: "Do X", "Never Y", "When [situation], do [action]".
- No hedging: "consider", "be careful", "or equivalent", "as appropriate" → rewrite as decision tree or exact instruction.
- No prose paragraphs. Trigger-action pairs.

## Structure

- Organize by themed sections (Budget, Voice, Scope, etc.) with imperative constraints in each.
- Each section: trigger-action pairs, not prose. Every line changes behavior.
- One Good/Bad example if the distinction isn't obvious from the constraint text alone.

## Verify

- Removal test: remove the rule, run the same task. If behavior is identical, delete the rule.
- Specificity test: can the agent follow every line without judgment calls? If not, rewrite.
