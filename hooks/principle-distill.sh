#!/bin/bash
# Distill personality from the latest conversation turn.
# Triggered by Stop hook after each assistant response.
# Reads the most recent transcript entries to get conversation context.

PRINCIPLES_FILE="$HOME/.claude/principles.md"

# Find the most recently modified transcript
TRANSCRIPT=$(find ~/.claude/projects -name "*.jsonl" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2)
if [ -z "$TRANSCRIPT" ]; then
    # macOS fallback (no -printf)
    TRANSCRIPT=$(find ~/.claude/projects -name "*.jsonl" -type f -exec stat -f '%m %N' {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
fi

[ -z "$TRANSCRIPT" ] && exit 0

# Get last ~20 lines of transcript (recent turns)
RECENT=$(tail -20 "$TRANSCRIPT" 2>/dev/null | grep -o '"content":"[^"]*"' | tail -5)
[ -z "$RECENT" ] && exit 0

CURRENT=$(cat "$PRINCIPLES_FILE" 2>/dev/null || echo "")

# Call claude to check for personality signals
RESULT=$(claude --print --max-turns 1 --dangerously-skip-permissions -p "You are a personality distiller. Analyze this recent conversation excerpt for personality signals.

Recent conversation:
$RECENT

Current personality profile:
$CURRENT

Look for: corrections, decision patterns, frustrations, preferences, work style signals.
Only record genuine NEW patterns not already in the profile.
Write in Chinese where the user uses Chinese. Be specific, not generic.

If a new signal found, output:
UPDATE
<new section or addition to append to the file>

If nothing new, output:
NO_UPDATE" 2>/dev/null)

if echo "$RESULT" | head -1 | grep -q "^UPDATE"; then
    echo "" >> "$PRINCIPLES_FILE"
    echo "$RESULT" | tail -n +2 >> "$PRINCIPLES_FILE"
fi
