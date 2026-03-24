---
name: save-session
description: Save the current conversation to memory with a summary, key insights, artifacts, and transcript location
metadata:
  owner: shrug-labs
  last_updated: 2026-03-23
---

# Save Session

Persist the current conversation's key context to memory so future sessions can pick up where this one left off.

## When to use

Use when a session produced project context, decisions, or artifacts that a future session needs to continue the work. The goal is continuity — capturing *what happened* and *where to find it*.

Not the same as session-retro. A retro extracts *behavioral learnings* (what should the agent do differently?). Save-session captures *project state* (what did we build, decide, or discover?). They can run together but serve different purposes — you may retro a session that doesn't need saving, or save a session that has no behavioral learnings.

## Steps

1. **Identify the session**

   Determine how to find this conversation again:
   - **Working directory or workspace:** the project directory or IDE workspace this session operated in
   - **Session identifier:** conversation ID, task ID, or session name — whatever the harness provides for locating this session later
   - Record both, since most harnesses scope sessions to a project directory

2. **Summarize the session**

   Review the full conversation and extract:
   - **What happened:** 2-3 sentence summary of the session's arc
   - **Key decisions made:** anything the user committed to or chose between
   - **Key insights:** non-obvious realizations, reframings, or connections discovered
   - **Artifacts produced:** files written, with full paths
   - **Open threads:** things discussed but not resolved, questions deferred
   - **People/systems referenced:** names, pages, tickets that would help future context loading

   Present the summary to the user for review before writing.

3. **Choose memory location**

   Apply the memory-bank routing table:
   - Cross-session project context → `~/.config/aipack/memory-bank/projects/`
   - Strategic direction → `~/.config/aipack/memory-bank/strategy/`
   - Reference material → `~/.config/aipack/memory-bank/reference/`
   - If an existing memory file covers this topic, UPDATE it rather than creating a new one

   Check existing files first: `ls ~/.config/aipack/memory-bank/projects/` and scan root MEMORY.md index for related entries.

4. **Write the memory file**

   Create or update the memory file with standard frontmatter:
   ```
   ---
   name: <descriptive-name>
   description: <one-line description for MEMORY.md index>
   type: project
   ---
   ```

   Include in the body:
   - Summary and key insights (from step 2)
   - Artifact locations with full paths
   - Transcript reference: enough to locate the session later. The format depends on the harness — resume command, conversation/task ID, session name. Include the project context so the reference is actionable.
   - "How to apply" section explaining when future sessions should load this context

   MUTATION: Writing to memory-bank. Show the full file content. Wait for approval.

5. **Update MEMORY.md index**

   Add a pointer to the new/updated file in `~/.config/aipack/memory-bank/MEMORY.md` under the appropriate section. Keep it to one line: `[filename](relative/path) — brief description`.

   MUTATION: Modifying MEMORY.md index.

6. **Optionally name the session**

   If the harness supports session naming and the session doesn't have a descriptive name yet, offer to rename it so it's findable by search.

## Done When

- Memory file written with summary, insights, artifacts, transcript pointer, and working directory
- MEMORY.md index updated
- User has confirmed the summary is accurate

## Notes

- Don't persist ephemeral task details (debugging steps, intermediate attempts) — only knowledge useful in future sessions.
- Don't duplicate what's already in artifacts (the meeting prep doc has the detail — the memory file points to it).
- If the session touched multiple unrelated topics, write separate memory entries rather than one mega-file.
- The transcript pointer is critical — include the working directory and session identifier so a future session can locate this one.
