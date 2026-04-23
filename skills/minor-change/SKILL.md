---
name: minor-change
description: Small tweaks to existing features — no design needed, just TDD and PR
user_invocable: true
---

# Minor Change Workflow

For small adjustments: text changes, style tweaks, config updates, removing dead code, renaming, etc. No design discussion needed.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Create worktree and branch
```
git worktree add .claude/worktrees/chore-<name> -b chore/<description>   # or fix/<description>
cd .claude/worktrees/chore-<name>
```
All work happens in the worktree — main stays clean.

## 3. Make the change
- If the change touches logic, write a test first (TDD)
- If purely cosmetic (text, style, config), test is optional
- Run full test suite after changes

## 4. Verify
- Run full test suite
- Verify compilation if code changed

## 5. Code Review
- Self-review via `git diff main...HEAD`
- Or dispatch a code-review subagent if available
- Fix all issues found before proceeding

## 6. Create PR
- Commit with concise message
- Push and create PR via `gh pr create`
- **Start CI/CD watchdog loop** — do NOT block with `gh pr checks --watch`. Instead:
  1. Spawn a Haiku subagent every **60 seconds** to run `gh pr checks <number> --json name,state,conclusion`
  2. If all checks pass → notify user with PR URL, ask to review, stop loop
  3. If any check fails → escalate to main model: read logs via `gh run view <run-id> --log-failed`, diagnose, fix in worktree, commit and push, then resume monitoring
  4. If checks still pending → schedule next check in 60s via `ScheduleWakeup`
  - Do not notify the user until all checks are green
- **DO NOT merge** — wait for explicit approval

## 7. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/chore-<name>`
- `git checkout main && git pull && git branch -d chore/<description>`

## Rules
- **Never merge without explicit approval**
- **Never push directly to main**
- No dead code, no silent excepts, no string literals for constants
- Keep changes small and focused — one concern per PR

## Quality Checklist

Before every PR, answer each item and present as a markdown table:

| # | Check | Answer |
|---|-------|--------|
| 1 | **What changed** — what was tweaked and how | [brief] |
| 2 | **Root cause fix** — is the change thorough, or surface-level only? | [yes/no + evidence] |
| 3 | **Single source of truth** — no duplicate data paths or redundant caches introduced? | [yes/no + evidence] |
| 4 | **Test regression** — do all existing tests pass? | [pass count / fail count] |
| 5 | **Reuse** — did you reuse existing patterns/functions, or reinvent something? | [yes/no + evidence] |

- If any answer is unsatisfactory, fix it before creating the PR
- Be honest — don't beautify answers
