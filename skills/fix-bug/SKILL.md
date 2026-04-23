---
name: fix-bug
description: Fix a bug with systematic debugging, TDD, and PR workflow
user_invocable: true
---

# Fix Bug Workflow

Follow this exact sequence. No plan needed — go straight to debugging.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Systematic Debugging
- **DO NOT guess fixes** — find root cause first
- Phase 1: Read errors, reproduce, check recent changes (`git log --oneline -10`), gather evidence
- Phase 2: Find working examples in the codebase, compare
- Phase 3: Form a single hypothesis, test minimally
- Phase 4: Implement fix with test

## 3. Create worktree and branch
```
git worktree add .claude/worktrees/fix-<name> -b fix/<bug-description>
cd .claude/worktrees/fix-<name>
```
All work happens in the worktree — main stays clean.

## 4. TDD Fix
- **Write a failing test that reproduces the bug FIRST**
- Then implement the fix
- The test must pass after the fix
- Run full test suite to check for regressions

## 5. Verify
- Run full test suite
- Verify the original bug is fixed
- Check no regressions

## 6. Code Review
- Self-review via `git diff main...HEAD`
- Or dispatch a code-review subagent if available
- Fix all issues found before proceeding

## 7. Create PR
- Commit with message explaining the root cause
- Push branch and create PR via `gh pr create`
- **Start CI/CD watchdog loop** — do NOT block with `gh pr checks --watch`. Instead:
  1. Spawn a Haiku subagent every **60 seconds** to run `gh pr checks <number> --json name,state,conclusion`
  2. If all checks pass → notify user with PR URL, ask to review, stop loop
  3. If any check fails → escalate to main model: read logs via `gh run view <run-id> --log-failed`, diagnose, fix in worktree, commit and push, then resume monitoring
  4. If checks still pending → schedule next check in 60s via `ScheduleWakeup`
  - Do not notify the user until all checks are green
- **DO NOT merge** — wait for explicit approval

## 8. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/fix-<name>`
- `git checkout main && git pull && git branch -d fix/<bug-description>`

## Rules
- **Never merge without explicit approval**
- **Never push directly to main**
- **Always write a regression test** — the bug must never come back
- **No plan needed** — bugs are urgent, go straight to debugging
- If 3+ fix attempts fail, stop and question the architecture
- No dead code, no silent excepts, no string literals for constants

## Quality Checklist

Before every PR, answer each item and present as a markdown table:

| # | Check | Answer |
|---|-------|--------|
| 1 | **What changed** — what was fixed and how | [brief] |
| 2 | **Root cause fix** — does this fix the root cause, or just the symptom? | [yes/no + evidence] |
| 3 | **Single source of truth** — no duplicate data paths or redundant caches introduced? | [yes/no + evidence] |
| 4 | **Test regression** — do all existing tests pass? | [pass count / fail count] |
| 5 | **Reuse** — did you reuse existing patterns/functions, or reinvent something? | [yes/no + evidence] |

- If any answer is unsatisfactory, fix it before creating the PR
- Be honest — don't beautify answers
