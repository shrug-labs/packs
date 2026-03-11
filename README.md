# packs

Community packs for [aipack](https://github.com/shrug-labs/aipack) — portable AI agent configuration that works across Claude Code, OpenCode, Codex, Cline, and other harnesses.

## Packs

### aipack-core

Meta-governance pack for authoring, reviewing, and maintaining pack content. Provides constraints and quality gates for rules, skills, workflows, agents, and MCP configurations.

- 7 rules (content constraints and governance)
- 3 skills (pack-content-craft, aipack-system, agent-configuration)
- 1 workflow (pack-review)

### essentials

Essential agentic capabilities — rules, skills, and workflows that fill behavioral and capability gaps in AI agents for software engineering. Covers debugging, test-driven development, planning, code review, operational triage, and knowledge management.

- 5 rules (anti-slop, verification-before-completion, show-your-work, multi-session-awareness, mutation-awareness)
- 15 skills (systematic-debugging, test-driven-development, brainstorming, writing-plans, and more)
- 7 workflows (brainstorm, write-plan, execute-plan, pr-readiness-code, session-retro, and more)
- 1 agent (code-reviewer)

## Install

Requires [aipack](https://github.com/shrug-labs/aipack).

```bash
# Install a pack from this repo
aipack pack install --url https://github.com/shrug-labs/packs.git --sub-path aipack-core
aipack pack install --url https://github.com/shrug-labs/packs.git --sub-path essentials

# Preview changes
aipack sync --dry-run

# Sync to your harness
aipack sync
```

## License

Copyright (c) 2025, 2026 The aipack Authors.

Released under the Universal Permissive License v1.0. See [LICENSE.txt](./LICENSE.txt).
