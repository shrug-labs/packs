---
name: aipack-system
description: Use when syncing, configuring, troubleshooting, or managing aipack packs — including sync-config, profiles, harness behaviors, and the delivery pipeline
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# aipack System Reference

Operational knowledge for the aipack pack management system.

## The SSOT Principle

```
Pack source (SSOT) → aipack sync → Harness locations (managed output)
```

**NEVER manually create, edit, or delete files in harness locations.**
Harness locations (`~/.claude/rules/`, `~/.claude/skills/`, `~/.claude/commands/`, `.mcp.json`, etc.) are managed output. The SSOT is the pack source at `~/.config/aipack/packs/<pack>/`.

This is a specific case of the generated-vs-authored principle: edit the input, not the output.

## Sync Procedure

Every time you modify pack content:

1. **Edit** content in pack source (`~/.config/aipack/packs/<pack>/`)
2. **Register new content** in `pack.json` — if you created a new rule, skill, workflow, or agent file, add its name to the corresponding array in `~/.config/aipack/packs/<pack>/pack.json`. Files not listed in the manifest will NOT be synced, regardless of profile settings.
3. **Verify sync defaults:** `cat ~/.config/aipack/sync-config.yaml`
   - Check `defaults.profile` — which profile will be used?
   - Check `defaults.harnesses` — which harnesses will be synced?
   - Check `defaults.scope` — global or project?
4. **Verify active profile:** `cat ~/.config/aipack/profiles/<profile>.yaml`
   - Which packs are enabled? (`enabled: true/false/null`)
   - Which content is included/excluded per vector?
   - Are the changes you made in a pack that's actually enabled?
5. **Dry-run:** `aipack sync --dry-run` — preview what would change. **Confirm new content appears in the plan.** If it doesn't, check step 2.
6. **Sync:** `aipack sync` (project scope) or `aipack sync --scope global` (user-level)
   - **MUTATION:** a real sync writes managed harness files outside the conversation. Get explicit `yes` before the non-dry-run command.
7. **Restart** harness client if needed (see below)

## Restart Requirements

After syncing, the harness client may need a restart for changes to take effect.

**This depends on two factors:**
- **The harness** — each loads and caches content differently
- **The vector** — always-on content vs on-demand content

**General principle:**
- Always-on content (rules, settings, MCP config, permissions) is typically loaded at session/client start → **restart needed**
- On-demand content (skills, workflows/commands) may be picked up without restart → **depends on harness**

**When in doubt: restart the harness client after syncing.**

## Profile Mechanics

Profiles control what content from which packs gets synced. This is how you toggle content on/off.

### Enabling/disabling packs

```yaml
packs:
  - name: pack-name
    enabled: true     # Force enabled
    enabled: false    # Force disabled
    enabled: null     # Pack default (usually enabled)
```

### Filtering content per vector

```yaml
packs:
  - name: pack-name
    rules:
      include: null          # null = include all rules from this pack
      include: []            # empty array = include NO rules
      include: ["rule-name"] # specific rules only
      exclude: ["rule-name"] # all except these
    skills:
      include: null
      exclude: null
    workflows:
      include: null
      exclude: null
    agents:
      include: null
      exclude: null
```

### Profile simplification

When a pack entry should include all content, omit the vector sections entirely:

```yaml
- name: my-pack
  enabled: true
  mcp:
    some-server:
      enabled: true
```

- Omitting `rules:`, `skills:`, etc. means "include everything" — same as `include: null` but without ceremony.
- **Footgun:** `include: []` (empty list) means "include NOTHING" — it silently blocks all content from that vector.
- Only add `include:`/`exclude:` sections when you need to filter specific items.

### Toggling after sync

To change what's active without editing pack source:
1. Edit the profile YAML at `~/.config/aipack/profiles/<name>.yaml`
2. Adjust `enabled`, `include`, or `exclude` as needed
3. Re-sync: `aipack sync`
4. Restart harness client if needed

### MCP per-server config

```yaml
packs:
  - name: pack-name
    mcp:
      server-name:
        enabled: true           # Enable/disable this MCP server
        allowed_tools: []       # Empty = use pack defaults
        disabled_tools: []      # Specific tools to block
```

## Common Commands

| Command | Purpose |
|---------|---------|
| `aipack sync --dry-run` | Preview what would change |
| `aipack sync` | Apply pack content (project scope) |
| `aipack sync --scope global` | Apply to user-level harness config |
| `aipack sync --force --yes` | Overwrite all managed files, even if digest matches |
| `aipack doctor` | Validate pack structure and config |
| `aipack save` | Reverse: save harness content back to pack source |
| `aipack clean --scope project --yes` | Remove project-level managed files |
| `aipack clean --scope global --yes` | Remove global managed files |
| `aipack clean --scope project --ledger --yes` | Clean + remove `.aipack/` ledger |
| `aipack render` | Render pack content to standalone output directory |
| `aipack pack create <dir>` | Scaffold a new pack directory with pack.json |

### Sync skip behavior

`aipack sync` compares the digest of each harness file against the pack source. If they match, it prints `skip(existing)` and does nothing. This means:
- After editing pack source, you need `--force` if the harness copy's digest still matches (e.g., the harness copy was synced before your edit but the file wasn't modified in-place).
- When in doubt after editing pack source: `aipack sync --force --scope global --yes`

### Scope and targeting

- `--scope global` — writes to `~/` prefixed locations (user-level config)
- `--scope project` (default) — writes to current project directory
- **Note:** Always pass `--scope` explicitly (see Troubleshooting below)
- `--harness <name>` — target specific harness (claudecode, opencode, codex, cline)
- `--profile <name>` — use specific profile (overrides sync-config default)
- `--profile-path <path>` — use a profile file outside config directory

### Scope duplication hazard

Do NOT sync both `--scope global` and `--scope project` for the same project. Claude Code loads rules from both `~/.claude/rules/` (global) and `<project>/.claude/rules/` (project) — identical content in both means double token cost and duplicate system prompt entries.

Pick one scope per project. For workspace-meta repos, use global only.

### OpenCode settings vs plugin files

- In pack manifests, `configs.harness_settings.opencode` maps to `opencode.json`.
- `configs.harness_plugins.opencode` maps to `oh-my-opencode.json`.
- For OpenCode, `--skip-settings` skips `opencode.json` but does **not** skip `oh-my-opencode.json`.
- If you update OpenCode model or plugin behavior, verify both pack source files before syncing.

### OpenCode global verification checklist

Use this exact sequence when OpenCode config changes are supposed to land in `~/.config/opencode/`:

1. Read `~/.config/aipack/sync-config.yaml` and the active profile to confirm `opencode` + `global` are intended.
2. Confirm the source files in the pack:
   - `configs/opencode/opencode.json`
   - `configs/opencode/oh-my-opencode.json`
3. Dry-run the exact target:
   - `aipack sync --profile <name> --harness opencode --scope global --dry-run`
4. After explicit approval, run the real sync:
   - `aipack sync --profile <name> --harness opencode --scope global --force --yes`
5. Read back both managed outputs:
   - `~/.config/opencode/opencode.json`
   - `~/.config/opencode/oh-my-opencode.json`
6. If model pins were the reason for the change, grep both source and output for old model names to prove cleanup.
7. Restart OpenCode if the changed behavior is always-on or plugin-driven.

### Clean details

`aipack clean` removes only files tracked in the sync ledger — non-managed files (e.g., `settings.local.json`, memory directories) are untouched.

- No `--dry-run` flag — read `.aipack/ledger.json` to preview what would be removed
- `--ledger` also deletes the `.aipack/` directory itself
- `--yes` skips confirmation (required in non-interactive contexts)
- `--harness <name>` cleans only one harness

## Harness Write Targets

Each harness writes content to different locations:

| Vector | Claude Code | OpenCode |
|--------|-------------|----------|
| Rules | `.claude/rules/` | `.opencode/rules/` |
| Skills | `.claude/skills/<name>/` | `.opencode/skills/<name>/` |
| Workflows | `.claude/commands/` | `.opencode/commands/` |
| Agents | `.claude/agents/` | `.opencode/agents/` |
| MCP | `.mcp.json` | `opencode.json` |
| Settings | `settings.local.json` | `opencode.json` |
| Plugin config | N/A | `oh-my-opencode.json` |

Global scope prefixes with `~/` (e.g., `~/.claude/rules/`). Project scope writes to the project directory.

**Codex** flattens rules + agents into a single `AGENTS.override.md` file.

## Pack Manifest (pack.json)

```json
{
  "schema_version": 1,
  "name": "pack-name",
  "version": "YYYY.MM.DD",
  "root": ".",
  "rules": ["rule-name"],
  "skills": ["skill-name"],
  "workflows": ["workflow-name"],
  "agents": ["agent-name"],
  "profiles": ["profiles/name.yaml"],
  "mcp": { "servers": { ... } },
  "configs": { "harness_settings": { ... } }
}
```

Content listed in pack.json is what's available to profiles. If it's not in the manifest, it won't be synced regardless of profile settings.

## Configuration Locations

| File | Purpose |
|------|---------|
| `~/.config/aipack/sync-config.yaml` | Sync defaults (profile, harness, scope) + installed packs registry |
| `~/.config/aipack/profiles/<name>.yaml` | Profile: which packs/content to sync |
| `~/.config/aipack/packs/<name>/pack.json` | Pack manifest |
| `~/.config/aipack/packs/<name>/` | Pack content source (SSOT) |

## Registry and Pack Installation

| Command | Purpose |
|---------|---------|
| `aipack registry fetch` | Clone upstream repo and merge entries into local registry |
| `aipack pack install <name>` | Install pack by registry name (resolves from local registry) |
| `aipack pack delete <name>` | Remove installed pack |
| `aipack pack add <name>` | Register installed pack in active profile |

- The SSOT registry lives in the upstream repo, not `~/.config/aipack/registry.yaml`. Edit upstream, push, then `aipack registry fetch`.
- To convert a local/copy pack to clone-based: `aipack pack delete <name>` then `aipack pack install <name>`.
- Reinstalled packs register in the sync-config default profile, which may differ from the profile they were previously in.

### Profile params after install

When a new profile is the active default, carry over `params` from any previous profile — otherwise MCP servers with `{params.*}` references will be skipped with unresolved param warnings.

### Skill collisions

When two packs ship a skill with the same ID (e.g., `agent-configuration` in two different packs), sync fails. Fix by excluding the duplicate in the profile: `skills.exclude: [skill-name]`.

## Troubleshooting

### sync-config defaults not respected

`sync-config.yaml` `defaults.scope` may not be honored by bare `aipack sync`. Always pass `--scope global` explicitly. Also: `--force` is required to update existing files when digest matching gives false "no change" results.

**Canonical sync command:** `aipack sync --scope global --force --yes`
**Canonical dry-run:** `aipack sync --scope global --force --dry-run`

## Personal Pack MCP Override

When a team pack's MCP server is broken (e.g., `uvx`-based server failing due to registry timeouts), override it from a personal pack without modifying the team pack:

1. Install the MCP server locally (e.g., venv at `~/.local/share/mcp-servers/<name>/`)
2. Create `~/.config/aipack/packs/<personal>/mcp/<server>.json` pointing to the local binary
3. In the active profile, disable the team pack's server: `packs[<team-pack>].mcp.<server>.enabled: false`
4. The personal pack provides the server instead — no collision, no override key needed

This works because profiles control which pack provides each MCP server. Disabling in one pack and enabling in another is clean composition, not a hack.

## Discipline (Observed Anti-Patterns)

These are behavioral failures observed in real sessions. Each one wasted significant time.

| Anti-pattern | Correction |
|---|---|
| Running aipack operations without invoking aipack-system skill first | Always invoke this skill before any aipack CLI work. "I can figure it out from --help" is the rationalization the skill warns against. |
| Ignoring sync-config values you already read | If you read a config file, extract the operational implications before acting. `scope: global` means pass `--scope global`. |
| Hand-editing generated artifacts (registry.yaml, harness locations) | Check whether the artifact is generated or authored. Generated → find and modify the SSOT input. |
| Proposing CLI flags without checking `--help` | Verify CLI capabilities before proposing commands. `aipack <cmd> --help` takes 2 seconds. |
| Editing shared config without checking SSOT | Ask "where is the SSOT?" before editing any config file that might have an upstream source. |

## Content Lifecycle

```
Observed failure → Draft in personal pack → Battle-test → Promote to team pack
```

1. Notice agent misbehavior or knowledge gap
2. Draft content in personal pack (using pack-content-craft methodology)
3. Sync and test — does it change behavior? (TDD loop)
4. After proving value, promote to team pack via PR
5. Team pack content flows to all team members via their profiles and sync
