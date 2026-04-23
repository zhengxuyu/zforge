---
name: hotfix
description: Emergency fix — minimal change, fast PR, no design overhead
user_invocable: true
---

# Hotfix Workflow

For urgent production fixes. Minimal change, fast turnaround.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Create worktree and branch
```
git worktree add .claude/worktrees/hotfix-<name> -b hotfix/<description>
cd .claude/worktrees/hotfix-<name>
```
All work happens in the worktree — main stays clean.

## 3. Identify and fix
- Read the error carefully — stack trace, logs, error message
- Make the **smallest possible change** that fixes the issue
- No refactoring, no cleanup, no "while I'm here" improvements

## 4. Test
- Write a regression test for the bug
- Run full test suite — must pass with zero failures
- If test infrastructure doesn't cover this path, manually verify and document how

## 5. Create PR
- Commit with message: what broke, why, and what the fix does
- Push and create PR via `gh pr create`
- Mark PR as urgent in the description
- **Start CI/CD watchdog loop** — do NOT block with `gh pr checks --watch`. Instead:
  1. Spawn a Haiku subagent every **60 seconds** to run `gh pr checks <number> --json name,state,conclusion`
  2. If all checks pass → notify user with PR URL, ask to review, stop loop
  3. If any check fails → escalate to main model: read logs via `gh run view <run-id> --log-failed`, diagnose, fix in worktree, commit and push, then resume monitoring
  4. If checks still pending → schedule next check in 60s via `ScheduleWakeup`
  - Do not notify the user until all checks are green
- **DO NOT merge** — wait for explicit approval

## 6. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/hotfix-<name>`
- `git checkout main && git pull && git branch -d hotfix/<description>`
- Consider whether a release is needed immediately

## Rules
- **Scope discipline** — fix ONLY the bug, nothing else
- **Never merge without explicit approval**
- **Never push directly to main**
- Always write a regression test
- If the fix is complex (>20 lines changed), switch to `/fix-bug` workflow instead
