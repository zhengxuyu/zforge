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

## 2. Design
- Explore the design space: what are the options, tradeoffs, edge cases?
- Present design to the user for approval before writing any code
- If the feature is simple and user says to skip design, proceed directly

## 3. Create branch
```
git checkout -b feat/<feature-name>
```

## 4. TDD Implementation
- **Write tests FIRST**, then implement
- For each unit of work:
  1. Write a failing test
  2. Implement the minimum code to pass
  3. Refactor if needed
- Run the full test suite after each change

## 5. Verify
- Run full test suite
- Verify compilation / import checks where applicable
- Check no silent excepts, no debug prints left behind

## 6. Code Review
- Self-review via `git diff main...HEAD`
- Or dispatch a code-review subagent if available
- Fix all issues found before proceeding

## 7. Create PR
- Commit with descriptive message
- Push branch and create PR via `gh pr create`
- Return the PR URL
- **DO NOT merge** — wait for explicit approval

## 8. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up: `git checkout main && git pull && git branch -d <branch>`

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
