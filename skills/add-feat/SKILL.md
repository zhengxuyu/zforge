---
name: add-feat
description: Add a new feature with design, TDD, and PR workflow
user_invocable: true
---

# Add Feature Workflow

Follow this exact sequence. Do NOT skip steps.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Requirements Discovery (questionnaire)

Before designing, understand what the user actually needs. Ask questions **one at a time** — wait for the answer before asking the next.

**Q1: Intent** — "What problem does this feature solve? Who needs it and why?"
- Push if vague: "Can you describe a concrete scenario where someone would use this?"

**Q2: Scope** — "What's the smallest version of this that would be useful?"
- Present options if applicable: A) minimal, B) standard, C) full
- Recommend one with a brief reason

**Q3: Existing patterns** — Review the codebase for related code, then ask:
"I found [related code/patterns]. Should this feature follow the same approach, or is there a reason to diverge?"

**Q4: Edge cases & conflicts** — Based on Q1-Q3, identify potential issues:
"I see these potential concerns: [list]. Which matter? Any others I'm missing?"

**Q5: Success criteria** — "How will we know this works? What should the tests verify?"

**Skip rule:** If the user says "skip" or the feature is trivially simple (< 20 lines of change), jump to step 3. But always ask Q1 at minimum.

After the questionnaire, summarize what you understood and get explicit confirmation before proceeding.

## 3. Design
- Based on the requirements discovery, explore the design space: options, tradeoffs, edge cases
- Present design to the user for approval before writing any code

## 4. Create worktree and branch
```
git worktree add .claude/worktrees/feat-<name> -b feat/<feature-name>
cd .claude/worktrees/feat-<name>
```
All work happens in the worktree — main stays clean.

## 5. TDD Implementation
- **Write tests FIRST**, then implement
- For each unit of work:
  1. Write a failing test
  2. Implement the minimum code to pass
  3. Refactor if needed
- Run the full test suite after each change

## 6. Verify
- Run full test suite
- Verify compilation / import checks where applicable
- Check no silent excepts, no debug prints left behind

## 7. Code Review
- Self-review via `git diff main...HEAD`
- Or dispatch a code-review subagent if available
- Fix all issues found before proceeding

## 8. Create PR
- Commit with descriptive message
- Push branch and create PR via `gh pr create`
- **Start CI/CD watchdog loop** — do NOT block with `gh pr checks --watch`. Instead:
  1. Spawn a Haiku subagent every **60 seconds** to run `gh pr checks <number> --json name,state,conclusion`
  2. If all checks pass → notify user with PR URL, ask to review, stop loop
  3. If any check fails → escalate to main model: read logs via `gh run view <run-id> --log-failed`, diagnose, fix in worktree, commit and push, then resume monitoring
  4. If checks still pending → schedule next check in 60s via `ScheduleWakeup`
  - Do not notify the user until all checks are green
- **DO NOT merge** — wait for explicit approval

## 9. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/feat-<name>`
- `git checkout main && git pull && git branch -d feat/<feature-name>`

## Rules
- **Never merge without explicit approval**
- **Never push directly to main**
- **Always TDD** — tests before implementation
- **Always run full test suite** before committing
- No dead code, no silent excepts, no string literals for constants
- No duplicate systems — same data via two paths is a critical defect

## Quality Checklist

Before every PR, answer each item and present as a markdown table:

| # | Check | Answer |
|---|-------|--------|
| 1 | **What changed** — what was built and how | [brief] |
| 2 | **Systematic design** — is the design systematic, or patch-by-patch? | [yes/no + evidence] |
| 3 | **Single source of truth** — no duplicate data paths or redundant caches introduced? | [yes/no + evidence] |
| 4 | **Test regression** — do all existing tests pass? | [pass count / fail count] |
| 5 | **Reuse** — did you reuse existing patterns/functions, or reinvent something? | [yes/no + evidence] |

- If any answer is unsatisfactory, fix it before creating the PR
- Be honest — don't beautify answers
