#!/bin/bash
# Flush working memory at session end.
# Summarizes the session and appends to today's daily note.
# Also checks for long-term memory promotion opportunities.

MEMORY_DIR="$HOME/.claude/memory"
WORKING_DIR="$MEMORY_DIR/working"
LONGTERM_DIR="$MEMORY_DIR/long-term"

mkdir -p "$WORKING_DIR" "$LONGTERM_DIR"

TODAY=$(date +%Y-%m-%d)
DAILY_NOTE="$WORKING_DIR/$TODAY.md"
LONGTERM_INDEX="$LONGTERM_DIR/MEMORY.md"

# Find the most recent transcript
TRANSCRIPT=$(find ~/.claude/projects -name "*.jsonl" -type f -exec stat -f '%m %N' {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
[ -z "$TRANSCRIPT" ] && exit 0

# Get recent conversation (last 30 lines for context)
RECENT=$(tail -30 "$TRANSCRIPT" 2>/dev/null)
[ -z "$RECENT" ] && exit 0

# Load existing daily note and long-term index
EXISTING_DAILY=$(cat "$DAILY_NOTE" 2>/dev/null || echo "")
EXISTING_LT=$(cat "$LONGTERM_INDEX" 2>/dev/null || echo "")

# Use claude to summarize and decide what to save
RESULT=$(claude --print --max-turns 1 --dangerously-skip-permissions -p "You are a memory manager. Analyze this conversation excerpt and produce TWO outputs.

Recent conversation:
$RECENT

Existing daily note for today:
$EXISTING_DAILY

Existing long-term memory index:
$EXISTING_LT

OUTPUT 1 — DAILY NOTE UPDATE
Append new information to today's daily note. Format:

## Session $(date +%H:%M)
### Progress
- [what was accomplished]
### Decisions
- [key decisions and rationale]
### Open Items
- [unfinished work, blockers, next steps]

Only include substantive items. Skip if the session was trivial (just a question or two).

OUTPUT 2 — LONG-TERM PROMOTION
If any information from this session is durable (architecture decisions, discovered constraints, non-obvious patterns), output it as a memory file. Otherwise skip.

Format your response as:
===DAILY===
[daily note content, or SKIP if trivial]
===LONGTERM===
[memory content with frontmatter, or SKIP if nothing to promote]
===END===" 2>/dev/null)

# Parse and save daily note update
DAILY_UPDATE=$(echo "$RESULT" | sed -n '/===DAILY===/,/===LONGTERM===/p' | sed '1d;$d')
if [ -n "$DAILY_UPDATE" ] && ! echo "$DAILY_UPDATE" | grep -q "^SKIP$"; then
    if [ ! -f "$DAILY_NOTE" ]; then
        echo "# $TODAY" > "$DAILY_NOTE"
    fi
    echo "" >> "$DAILY_NOTE"
    echo "$DAILY_UPDATE" >> "$DAILY_NOTE"
fi

# Parse and save long-term memory promotion
LT_UPDATE=$(echo "$RESULT" | sed -n '/===LONGTERM===/,/===END===/p' | sed '1d;$d')
if [ -n "$LT_UPDATE" ] && ! echo "$LT_UPDATE" | grep -q "^SKIP$"; then
    # Extract name from frontmatter for filename
    LT_NAME=$(echo "$LT_UPDATE" | grep "^name:" | head -1 | sed 's/name: *//' | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
    if [ -n "$LT_NAME" ]; then
        echo "$LT_UPDATE" > "$LONGTERM_DIR/${LT_NAME}.md"
        # Add to index if not already there
        if ! grep -q "$LT_NAME" "$LONGTERM_INDEX" 2>/dev/null; then
            LT_DESC=$(echo "$LT_UPDATE" | grep "^description:" | head -1 | sed 's/description: *//')
            echo "- [$LT_NAME](${LT_NAME}.md) — $LT_DESC" >> "$LONGTERM_INDEX"
        fi
    fi
fi
