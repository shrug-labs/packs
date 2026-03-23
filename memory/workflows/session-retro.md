---
name: session-retro
description: End-of-session review — extract conventions, knowledge gaps, workflow friction, and memory corrections from the conversation
metadata:
  owner: shrug-labs
  last_updated: 2026-03-11
---

# Session Retrospective

Review what happened in this session and extract learnings worth persisting.

## When to use

Use when a session exposed behavioral corrections, knowledge gaps, or workflow friction worth capturing. The goal is improvement — extracting *what should change* for future sessions.

Not the same as save-session. Save-session captures *project state* for continuity (what did we build?). A retro captures *behavioral learnings* (what should the agent do differently?). You may retro a throwaway session that doesn't need saving, or save a productive session that has no behavioral learnings to extract.

## Prerequisites

- Fork the conversation if mid-session (preserve main context).
- If end-of-session, no fork needed.

## Steps

1. **Tally pack invocations**

   Scan the conversation for pack content that was invoked during this session:
   - `/command-name` invocations (workflows)
   - `@agent-name` dispatches (agents)
   - Skill tool calls (skills)
   - Rules referenced by the agent in its reasoning

   For each invocation found, update the pack usage tally in your persistent memory store:
   - If the resource already has a row, increment its Count and update Last Used.
   - If it's new, add a row with Count = 1.

   This is a running tally — one row per resource, not per session.

2. **Scan the conversation** for each category:

   **Conventions discovered** — Did the agent do something wrong that was corrected?
   - What was the misbehavior?
   - What should the agent have done?
   - Is this likely to recur?

   **Knowledge gaps exposed** — Did the agent lack knowledge it needed?
   - What was missing?
   - Where should that knowledge live?

   **Workflow friction** — Were there repeated manual steps that could be automated?
   - What was the repetitive sequence?
   - Could it be a workflow or skill?

   **Memory corrections** — Did the agent state something from memory that turned out wrong?
   - What was stated incorrectly?
   - What's the correct information?
   - Where is the wrong information stored?

   **Things that worked well** — What approaches were effective?
   - Are they already captured in pack content?

3. **Classify findings into two buckets**

   **Memory captures** — items that belong in persistent memory:
   - Strategic context, decisions, project status
   - Known issues and workarounds
   - Observations not yet confirmed as durable
   - Corrections to existing memory content

   **Pack candidates** — items that belong in pack content:
   - Conventions (agent misbehavior corrections → pack rules)
   - Knowledge gaps (missing domain knowledge → pack skills)
   - Workflow friction (repeatable processes → pack workflows)
   - Patterns confirmed across multiple sessions

   Present both buckets. For each finding:
   - Category (convention / gap / friction / correction / success)
   - Description (one sentence)
   - Bucket: `memory` or `pack-candidate`
   - For memory: destination file
   - For pack-candidate: construct type, target pack, observed failure evidence

   MUTATION GATE: Wait for user approval before writing anything. User may skip, modify, re-bucket, or reprioritize.

4. **Execute approved memory captures**

   For each approved memory item, use the remember workflow:
   - Classify → determine destination → draft → write
   - Keep each capture atomic

5. **Record approved pack candidates**

   For each approved pack candidate, write a TODO entry to persistent memory:
   ```
   ## Pack Candidate: [short name]
   - Construct: [rule | skill | workflow]
   - Pack: [target pack]
   - Evidence: [observed failure from this session]
   - Priority: [user-assigned or default: normal]
   ```

   Do NOT write the pack content itself during a retro. Pack content requires dedicated attention with pack-content-craft discipline — not end-of-session leftovers.

6. **Summary**

   | Bucket | Count | Action |
   |--------|-------|--------|
   | Memory captures | | Written via remember |
   | Pack candidates | | TODOs recorded — execute via knowledge-audit or dedicated session |
   | Deferred | | Noted for future review |

   If pack candidates were recorded, note: "Run knowledge-audit or start a pack-writing session to process these."

## Notes

- This is a reflective workflow, not a documentation workflow. Focus on behavior change opportunities, not session notes.
- If the session produced 0 findings, that's fine. Not every session has novel learnings.
- Prioritize corrections (wrong memory is actively harmful) over new captures.
- The key discipline: **memory writes are fast and cheap, pack writes require deliberate craft.** This workflow handles the fast captures and queues the deliberate work.
