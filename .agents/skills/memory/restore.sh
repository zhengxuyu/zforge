#!/bin/bash
# Restore working memory at session start.
# Injects today's + yesterday's daily notes + long-term memory index.

MEMORY_DIR="$HOME/.claude/memory"
WORKING_DIR="$MEMORY_DIR/working"
LONGTERM_DIR="$MEMORY_DIR/long-term"

# Ensure directories exist
mkdir -p "$WORKING_DIR" "$LONGTERM_DIR"

TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "yesterday" +%Y-%m-%d 2>/dev/null)

CONTEXT=""

# Load today's daily note
if [ -f "$WORKING_DIR/$TODAY.md" ]; then
    TODAY_CONTENT=$(cat "$WORKING_DIR/$TODAY.md" | head -100)
    CONTEXT="${CONTEXT}\n--- TODAY ($TODAY) ---\n${TODAY_CONTENT}"
fi

# Load yesterday's daily note
if [ -n "$YESTERDAY" ] && [ -f "$WORKING_DIR/$YESTERDAY.md" ]; then
    YESTERDAY_CONTENT=$(cat "$WORKING_DIR/$YESTERDAY.md" | head -60)
    CONTEXT="${CONTEXT}\n--- YESTERDAY ($YESTERDAY) ---\n${YESTERDAY_CONTENT}"
fi

# Load long-term memory index
if [ -f "$LONGTERM_DIR/MEMORY.md" ]; then
    LT_CONTENT=$(cat "$LONGTERM_DIR/MEMORY.md" | head -60)
    CONTEXT="${CONTEXT}\n--- LONG-TERM MEMORY INDEX ---\n${LT_CONTENT}"
fi

# Clean up old daily notes (>7 days)
if [ -d "$WORKING_DIR" ]; then
    find "$WORKING_DIR" -name "*.md" -mtime +7 -delete 2>/dev/null
fi

if [ -n "$CONTEXT" ]; then
    # Escape for JSON
    ESCAPED=$(echo -e "$CONTEXT" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))" 2>/dev/null | sed 's/^"//;s/"$//')
    cat << EOF
{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "WORKING MEMORY RESTORED. Review and continue from where you left off. Update today's daily note (~/.claude/memory/working/$TODAY.md) as you work.\n${ESCAPED}"}}
EOF
else
    cat << EOF
{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "NO WORKING MEMORY FOUND. Start fresh — create today's daily note at ~/.claude/memory/working/$TODAY.md when you begin meaningful work."}}
EOF
fi
