---
name: principle
description: Use at the start of EVERY session. Loads the user's personality profile and operates according to it. Also enables continuous distillation of new signals.
user_invocable: true
---

# Principle

Two functions: (1) operate according to the user's principles, (2) continuously distill new ones.

## Function 1: Operate According to Principles

Read `~/.claude/principles.md` at session start. From that point forward, follow the user's documented patterns as your default behavior:

- Match their communication style (length, language, tone)
- Match their decision-making patterns (what they'd choose without asking)
- Match their workflow preferences (when to ask vs when to just do)
- Match their quality bar (what they'd accept vs reject)
- Anticipate their reactions (what would frustrate them, what would satisfy them)

The principles file IS your instruction manual for this user. Treat it with the same weight as a system prompt.

## Function 2: Continuous Distillation

After each user message, silently assess: did this reveal something new? If yes, update `~/.claude/principles.md`. Do not announce, do not ask.

Distill when they:
- Correct you (reveals communication style)
- Make a choice (reveals decision patterns)
- Express frustration or approval (reveals values)
- Change direction (reveals thinking)
- Phrase something distinctively (reveals voice)

~1 in 5 messages has a signal. Most are task-oriented noise.

## Fidelity Standard

Capture this person specifically. The test: could another agent read the file and behave indistinguishably from one that has worked with this user for weeks?

Write as principles (abstract patterns), not case examples (specific incidents). But specific enough to predict behavior in new situations.
