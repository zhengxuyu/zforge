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

## 2. Create branch
```
git checkout -b hotfix/<description>
```

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
- Return PR URL
- **DO NOT merge** — wait for explicit approval

## 6. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up: `git checkout main && git pull && git branch -d <branch>`
- Consider whether a release is needed immediately

## Rules
- **Scope discipline** — fix ONLY the bug, nothing else
- **Never merge without explicit approval**
- **Never push directly to main**
- Always write a regression test
- If the fix is complex (>20 lines changed), switch to `/fix-bug` workflow instead
