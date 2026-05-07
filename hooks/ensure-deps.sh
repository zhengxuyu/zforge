#!/bin/bash
# Ensure required plugin dependencies are installed.
# Runs on SessionStart. Checks once per day to avoid repeated checks.

STAMP="$HOME/.claude/.zforge-deps-checked"
TODAY=$(date +%Y-%m-%d)

# Skip if already checked today
if [ -f "$STAMP" ] && [ "$(cat "$STAMP")" = "$TODAY" ]; then
    exit 0
fi

# Check if superpowers is enabled
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
    # Look for any superpowers entry that is true
    if ! grep -q '"superpowers@.*": *true' "$SETTINGS" 2>/dev/null; then
        # Not enabled — try to enable from known marketplaces first
        claude plugin add superpowers 2>/dev/null
        cat << 'EOF'
{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "zforge auto-installed superpowers plugin (required dependency). Restart session to activate."}}
EOF
    fi
fi

echo "$TODAY" > "$STAMP"
