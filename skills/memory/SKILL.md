---
name: memory
description: Manage working memory (session-scoped) and long-term memory (cross-session). Automatically triggered by hooks at session start/stop. Invoke manually with /memory to review or curate.
user_invocable: true
---

# Memory

Two-tier memory system: **working memory** for session context, **long-term memory** for durable facts. Inspired by OpenClaw's daily notes and Hermes' bounded curation.

## Architecture

```
~/.claude/memory/
├── working/                    # Session-scoped daily notes
│   ├── 2026-05-07.md          # Today's context
│   └── 2026-05-06.md          # Yesterday's context
└── long-term/                  # Curated durable facts
    ├── MEMORY.md               # Index (loaded every session)
    ├── decisions_*.md          # Architecture/design decisions
    ├── context_*.md            # Project context
    └── learnings_*.md          # Technical learnings
```

## Tier 1: Working Memory (Daily Notes)

File: `~/.claude/memory/working/YYYY-MM-DD.md`

Format:
```markdown
# YYYY-MM-DD

## Active Tasks
- [task description] — [status: in-progress/blocked/done]

## Decisions Made
- [decision]: [rationale]

## Key Context
- [anything needed to resume work if session restarts]

## Open Questions
- [unresolved questions or blockers]
```

### When to write working memory

Write to today's daily note when:
1. Starting a non-trivial task (record what and why)
2. Making a significant decision (record decision + rationale)
3. Hitting a blocker or switching tasks (record state for resumption)
4. Before any large code generation that might trigger compaction (pre-flush)
5. Session ending (the Stop hook handles this automatically)

### Rules

Working memory is append-only within a session. Overwrite sections only to update status (in-progress → done).

Daily notes older than 7 days are automatically archived by the cleanup hook. Keep today + yesterday loaded at session start.

## Tier 2: Long-term Memory

Directory: `~/.claude/memory/long-term/`

Index: `~/.claude/memory/long-term/MEMORY.md` — one-line pointers, max 50 entries.

### What belongs in long-term memory

Only facts that satisfy ALL of:
1. Not derivable from code, git history, or config files
2. Useful in future sessions (not just this one)
3. Non-obvious — someone reading the codebase wouldn't guess this

Examples: why a certain approach was rejected, a user preference discovered mid-session, an external constraint (deadline, dependency on another team).

### When to promote working memory to long-term

At session end (or when manually invoked), review today's daily notes and ask:
- Would losing this information cost future-me more than 5 minutes?
- Is this a pattern, not a one-off?

If yes, extract and save to long-term. Deduplicate against existing entries.

### Bounded curation

Long-term memory index (MEMORY.md) is capped at 50 entries. When approaching the limit, merge related entries or remove stale ones. The test: if nobody has looked at a memory in 30 days and it hasn't influenced any decision, it's probably stale.

## Session Hooks

### SessionStart: Restore context

The `restore.sh` hook runs at session start and injects:
1. Today's daily note (if exists)
2. Yesterday's daily note (if exists)
3. Long-term memory index

This gives the new session immediate context about recent work.

### Stop: Flush working memory

The `flush.sh` hook runs at session end. It:
1. Summarizes the session's key decisions, progress, and open items
2. Appends to today's daily note
3. Checks if anything should be promoted to long-term memory

## Manual Commands

When the user invokes `/memory`:

1. **Review**: Show today's working memory + long-term memory index
2. **Curate**: If user says "curate" or "整理", review long-term memory for staleness, merge duplicates, remove obsolete entries
3. **Search**: If user provides a query, search across all memory files
4. **Promote**: If user says "remember [X]" or "记住", save to long-term memory immediately

## Pre-compaction Flush

When the conversation is getting long (you notice tool results being truncated or prior context feeling thin), proactively save critical working memory before it's lost. This is a safety net — don't wait for automatic triggers.

Signs you should flush:
- You can't recall details from earlier in the conversation
- The system mentions context compression
- You're about to generate a very large output

## Integration with Existing Systems

This skill complements but does not replace:
- `principles.md` — personality (SOUL), managed by the principle skill
- Project-level `memory/` in `.claude/projects/` — Claude Code's built-in memory (continue using for project-specific feedback/user/reference memories as the system prompt instructs)

The `~/.claude/memory/` directory is for cross-project working memory and curated long-term facts. Project-specific memories stay in their respective `.claude/projects/*/memory/` directories.
