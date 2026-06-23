#!/usr/bin/env bash
# pack-audit.sh — Structural audit of a pack source tree
# Usage:
#   pack-audit.sh <pack-root>                          per-file structural audit (one pack)
#   pack-audit.sh --aggregate <rules-dir> [skills-dir] cross-profile always-on budget
#
# Per-file mode outputs a table: path, line count, budget compliance,
# frontmatter field presence, and notes (CSO trigger check for skills).
# Aggregate mode sums the RENDERED harness output (e.g. ~/.claude/rules,
# ~/.claude/skills): rule count, rule tokens, and skill-description payload.
# Designed to be run as the first step of a pack review.
set -euo pipefail

# --aggregate mode: cross-profile always-on budget over the RENDERED harness output
# (synced rules/skills). Counts the synced copies the model actually loads every
# turn — not pack source.
if [[ "${1:-}" == "--aggregate" ]]; then
    rules_dir="${2:?Usage: pack-audit.sh --aggregate <rules-dir> [skills-dir]}"
    rules_dir="${rules_dir%/}"
    skills_dir="${3:-}"; skills_dir="${skills_dir%/}"
    if [[ ! -d "$rules_dir" ]]; then
        printf "error: rules dir does not exist: %s\n" "$rules_dir" >&2
        exit 2
    fi
    if [[ -n "$skills_dir" && ! -d "$skills_dir" ]]; then
        printf "error: skills dir does not exist: %s\n" "$skills_dir" >&2
        exit 2
    fi

    # Token ceiling has an established default (20K). Count and skill-description
    # thresholds are opt-in (0 = report only) until calibrated against measured
    # removal-test data — set AIPACK_MAX_RULES / AIPACK_MAX_SKILL_DESC_TOKENS to enforce.
    max_rule_tokens="${AIPACK_MAX_RULE_TOKENS:-20000}"
    max_rules="${AIPACK_MAX_RULES:-0}"
    max_skill_desc_tokens="${AIPACK_MAX_SKILL_DESC_TOKENS:-0}"

    rule_count=0; rule_lines=0; rule_chars=0
    while IFS= read -r f; do
        rule_count=$((rule_count + 1))
        rule_lines=$((rule_lines + $(wc -l < "$f")))
        rule_chars=$((rule_chars + $(wc -c < "$f")))
    done < <(find "$rules_dir" -maxdepth 1 -name '*.md' -type f | sort)
    rule_tokens=$((rule_chars / 4))

    skill_count=0; desc_chars=0
    if [[ -n "$skills_dir" && -d "$skills_dir" ]]; then
        while IFS= read -r sf; do
            skill_count=$((skill_count + 1))
            desc=$(grep -m1 '^description:' "$sf" 2>/dev/null | sed 's/^description:[[:space:]]*//' || true)
            desc_chars=$((desc_chars + ${#desc}))
        done < <(find "$skills_dir" -mindepth 1 -maxdepth 2 -name 'SKILL.md' -type f | sort)
    fi
    desc_tokens=$((desc_chars / 4))

    # Print "  ok" or "  OVER (>N)"; threshold 0 means report-only.
    flag() { if [[ "$2" -gt 0 && "$1" -gt "$2" ]]; then printf "  OVER (>%s)" "$2"; else printf "  ok"; fi; }

    echo "AGGREGATE ALWAYS-ON BUDGET"
    echo "  rendered rules dir:  ${rules_dir}"
    printf "  rule count:          %d%s\n" "$rule_count" "$(flag "$rule_count" "$max_rules")"
    printf "  rule lines:          %d\n" "$rule_lines"
    printf "  rule tokens (~):     %d%s\n" "$rule_tokens" "$(flag "$rule_tokens" "$max_rule_tokens")"
    if [[ -n "$skills_dir" ]]; then
        printf "  skills:              %d (descriptions ~%d tokens)%s\n" "$skill_count" "$desc_tokens" "$(flag "$desc_tokens" "$max_skill_desc_tokens")"
    fi
    exit 0
fi

root="${1:?Usage: pack-audit.sh <pack-root>}"
root="${root%/}"

printf "%-50s %5s %7s %4s %s\n" "FILE" "LINES" "BUDGET" "FM" "NOTES"
printf "%-50s %5s %7s %4s %s\n" "----" "-----" "------" "--" "-----"

find "$root" \( -path "*/rules/*.md" -o -path "*/skills/*.md" -o -path "*/workflows/*.md" -o -path "*/agents/*.md" \) -type f | sort | while IFS= read -r f; do
    rel="${f#$root/}"
    lines=$(wc -l < "$f")

    # Frontmatter boundary (second --- line)
    fm_end=$(awk '/^---$/{n++; if(n==2){print NR; exit}}' "$f")

    # Frontmatter is required on rules, workflows, agents, and SKILL.md entry points.
    # Supporting files within skill directories (references/, scripts/, facets) are exempt.
    notes=""
    fm=""
    needs_fm=false
    case "$rel" in
        rules/*|workflows/*|agents/*|skills/*/SKILL.md) needs_fm=true ;;
    esac

    if $needs_fm; then
        if [[ -n "$fm_end" ]]; then
            fm=$(head -n "$fm_end" "$f")
            missing=""
            echo "$fm" | grep -q '^name:'          || missing="${missing}name "
            echo "$fm" | grep -q '^description:'   || missing="${missing}desc "
            echo "$fm" | grep -q 'owner:'          || missing="${missing}owner "
            echo "$fm" | grep -q 'last_updated:'   || missing="${missing}updated "
            fm_ok=$([[ -z "$missing" ]] && echo "ok" || echo "MISS")
            [[ -n "$missing" ]] && notes="missing: ${missing% }"
        else
            fm_ok="NONE"
            notes="no frontmatter"
        fi
    else
        fm_ok="-"
        [[ -n "$fm_end" ]] && fm=$(head -n "$fm_end" "$f")
    fi

    # Budget check (rules: 60, SKILL.md: 500)
    budget="-"
    case "$rel" in
        rules/*)           [[ $lines -le 60 ]]  && budget="ok" || budget="OVER" ;;
        skills/*/SKILL.md) [[ $lines -le 500 ]] && budget="ok" || budget="OVER" ;;
    esac

    # CSO check for skill descriptions
    if [[ "$rel" == skills/*/SKILL.md && -n "$fm" ]]; then
        desc=$(echo "$fm" | grep '^description:' | head -1)
        if ! echo "$desc" | grep -qi 'use when'; then
            notes="${notes:+$notes; }CSO: missing trigger"
        fi
    fi

    printf "%-50s %5d %7s %4s %s\n" "$rel" "$lines" "$budget" "$fm_ok" "$notes"
done
