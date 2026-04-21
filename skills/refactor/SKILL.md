---
name: refactor
description: Refactor code with safety nets — tests green before and after, no behavior change
user_invocable: true
---

# Refactor Workflow

Restructure code without changing behavior. Tests are your safety net.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Verify baseline
- Run full test suite — **all tests must pass before you touch anything**
- If tests fail, fix them first (that's a `/fix-bug`, not a refactor)

## 3. Create worktree and branch
```
git worktree add .claude/worktrees/refactor-<name> -b refactor/<description>
cd .claude/worktrees/refactor-<name>
```
All work happens in the worktree — main stays clean.

## 4. Plan the refactor
- Identify what to change and why (readability, performance, deduplication, etc.)
- List the files that will be affected
- Present the plan to the user for approval

## 5. Refactor incrementally
- Make one logical change at a time
- Run tests after each change — they must stay green
- If a test breaks, your refactor changed behavior — revert and rethink
- Commit at each stable point

## 6. Verify
- Run full test suite — same pass count as baseline
- Verify no behavior change: same inputs produce same outputs
- Check no dead code left behind

## 7. Code Review
- Self-review via `git diff main...HEAD`
- Or dispatch a code-review subagent if available

## 8. Create PR
- Commit with message explaining what was refactored and why
- Push and create PR via `gh pr create`
- Wait for CI/CD checks to complete: `gh pr checks <number> --watch`
- If checks fail, fix the issues and push again — do not notify the user until all checks are green
- Once all checks pass, return the PR URL and ask the user to review
- **DO NOT merge** — wait for explicit approval

## 9. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/refactor-<name>`
- `git checkout main && git pull && git branch -d refactor/<description>`

## Rules
- **Tests must pass before AND after** — the whole point of refactoring
- **No behavior changes** — if you need to change behavior, that's a feature or bugfix
- **Never merge without explicit approval**
- **Never push directly to main**
- Incremental commits — don't lump everything into one giant diff

## Quality Checklist

Before every PR, answer each item and present as a markdown table:

| # | Check | Answer |
|---|-------|--------|
| 1 | **What changed** — what was refactored and why | [brief] |
| 2 | **Behavior preserved** — does the code behave identically? | [yes/no + evidence] |
| 3 | **Single source of truth** — no duplicate data paths or redundant caches introduced? | [yes/no + evidence] |
| 4 | **Test regression** — do all existing tests pass? Same count as baseline? | [pass count / fail count] |
| 5 | **Reuse** — did you reuse existing patterns/functions, or reinvent something? | [yes/no + evidence] |

- If any answer is unsatisfactory, fix it before creating the PR
- Be honest — don't beautify answers
