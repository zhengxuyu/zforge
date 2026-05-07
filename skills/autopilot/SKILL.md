---
name: autopilot
description: Use when the user says "autopilot", "auto mode", "替我回答", or "自动回答". Enables autonomous decision-making by answering Claude's own questions based on the user's personality profile.
---

# Autopilot

When enabled, intercept all AskUserQuestion calls. Instead of asking the user, consult `~/.claude/principles.md` to predict what the user would answer, then proceed with that answer automatically.

## Activation

User says `/autopilot` or "autopilot on". From that point forward in this session:

1. Before every question you would ask the user, STOP.
2. Read `~/.claude/principles.md`.
3. Based on the personality profile, determine what the user would most likely answer.
4. Log the auto-answer: print `[autopilot] Q: <your question> → A: <predicted answer> (based on: <which principle>)`
5. Proceed with that answer as if the user said it.

## Decision Rules

When the principles file does not cover a specific question, apply these fallbacks in order:

1. If the question is about taste or style, default to the user's documented preferences.
2. If the question is about effort or scope, choose the more ambitious option (the user tends to push for more, not less).
3. If the question is about process or workflow, choose the faster path.
4. If genuinely uncertain, choose the option that is easiest to reverse.
5. If none of the above apply, ask the user (break autopilot for this one question only).

## Logging

Every auto-answered question must be logged so the user can audit later:

```
[autopilot] Q: Should we use compute-controlled or fixed-iteration comparison?
         → A: Fixed iteration (based on: Thinking > prefers simpler experimental designs)
```

## Deactivation

User says "autopilot off" or "stop autopilot". Resume normal interactive mode.

## Important

Autopilot is not a license to skip questions entirely. It is a license to answer them on the user's behalf. The question must still be formulated; the answer just comes from the personality profile instead of waiting for input.

If autopilot makes a wrong prediction and the user corrects it, update `~/.claude/principles.md` with the correction. This is a learning signal.
