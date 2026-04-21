---
name: update-deps
description: Update dependencies safely — check changelogs, run tests, create PR
user_invocable: true
---

# Update Dependencies Workflow

Update project dependencies with safety checks.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Check current state
- List outdated dependencies (e.g., `npm outdated`, `pip list --outdated`)
- Identify which updates are available: patch, minor, major
- Present the list to the user

## 3. Create worktree and branch
```
git worktree add .claude/worktrees/chore-update-deps -b chore/update-deps
cd .claude/worktrees/chore-update-deps
```
All work happens in the worktree — main stays clean.

## 4. Update incrementally
- **Patch updates**: apply all at once, low risk
- **Minor updates**: apply in batches by package, run tests after each
- **Major updates**: one at a time, check changelog for breaking changes

After each batch:
- Run full test suite
- Check for deprecation warnings
- Verify the app builds and starts

## 5. Create PR
- Commit with message listing what was updated and to which versions
- Push and create PR via `gh pr create`
- Include the dependency diff in the PR description
- Return PR URL
- **DO NOT merge** — wait for explicit approval

## 6. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/chore-update-deps`
- `git checkout main && git pull && git branch -d chore/update-deps`

## Rules
- **Never merge without explicit approval**
- **Never push directly to main**
- **Run tests after every update batch** — catch breakage early
- Major version bumps deserve their own PR if they're risky
- Lock file must be committed alongside version changes
