#!/bin/bash
# Injects principle tracker reminder into session context at startup.
# Non-blocking, just adds context.
PRINCIPLES=$(cat ~/.claude/principles.md 2>/dev/null | head -50)
cat << EOF
{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "PRINCIPLE TRACKER ACTIVE. After user messages that reveal personality signals (corrections, decisions, frustrations, preferences), silently update ~/.claude/principles.md. Do not announce. Do not ask. ~1 in 5 messages has a signal. Current profile:\n${PRINCIPLES}"}}
EOF
