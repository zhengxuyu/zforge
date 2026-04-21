---
name: add-feat
description: Add a new feature with TDD, worktree isolation, PR workflow, and code review
user_invocable: true
---

# Add Feature Workflow

Follow this exact sequence. Do NOT skip steps.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Brainstorm (superpowers:brainstorming)
- Invoke the brainstorming skill to explore the design
- Present design to CEO for approval before writing any code
- If the feature is simple and CEO says to skip design, proceed directly

## 3. Plan (superpowers:writing-plans)
- Write an implementation plan
- Get CEO approval on the plan

## 4. Create worktree (superpowers:using-git-worktrees)
- Create an isolated git worktree for the feature branch
- Branch naming: `feat/<feature-name>`

## 5. TDD Implementation (superpowers:test-driven-development)
- **Write tests FIRST**, then implement
- For each unit of work:
  1. Write a failing test
  2. Implement the minimum code to pass
  3. Refactor if needed
- Run the full test suite after each change

## 6. Verify (superpowers:verification-before-completion)
- Run all tests: `.venv/bin/python -m pytest tests/unit/ -x -q`
- Verify compilation: `.venv/bin/python -c "from onemancompany.api.routes import router; print('OK')"`
- Check no silent excepts, no print statements

## 7. Create PR
- Commit with descriptive message
- Push branch and create PR via `gh pr create`
- Return the PR URL to CEO
- **DO NOT merge** — wait for CEO to say "merge"

## 8. Code Review (superpowers:requesting-code-review)
- Dispatch code-reviewer subagent
- Fix ALL issues: Critical, Important, AND Suggestions
- **Verify each finding** — if reviewer is hallucinating (claiming a bug that doesn't exist), gather evidence (read the code, run the test) and reject the finding with reasoning
- Re-run review after fixes until zero issues remain
- Push fixes and notify CEO

## 9. Merge (only when CEO says)
- `gh pr merge <number> --admin --merge`
- Clean up: `git checkout main && git pull && git branch -d <branch>`
- If using worktree: remove worktree first

## Rules
- **Never merge without CEO confirmation**
- **Never push directly to main**
- **Always TDD** — tests before implementation
- **Always run full test suite** before committing
- **Zero tolerance for code smells:**
  - No dead code (empty functions, unused variables, commented-out blocks)
  - No string literals for values that should be constants/enums
  - No duplicate systems (same data via two paths = Critical defect)
  - No technical debt left behind — fix it now or don't write it
- **Never commit planning materials** — `docs/superpowers/` (specs, plans) is .gitignored. Never `git add -f` to override. These are local working docs, not repo artifacts.
- Read `vibe-coding-guide.md` before starting if unfamiliar with codebase conventions

## Quality Checklist (每次提交 PR 前必须逐项检查并输出)

完成所有代码修改后，**必须**逐项回答以下问题，格式化输出给 CEO：

| # | 检查项 | 回答 |
|---|--------|------|
| 1 | **解决方式** — 做了什么、怎么实现的 | [简述] |
| 2 | **根本性解决** — 设计是否系统性的，还是补丁式逐个修 | [是/否 + 依据] |
| 3 | **唯一真源** — 是否遵循磁盘即唯一真源原则，有没有引入内存缓存或重复数据路径 | [是/否 + 依据] |
| 4 | **测试回归** — 现有 unit test 是否全部通过 | [通过数/失败数] |
| 5 | **重复造轮子** — 是否复用了已有模式/函数，有没有重新实现已存在的功能 | [是/否 + 依据] |

- 如果任何一项答案不理想，**必须先修复再提交 PR**
- 不要美化答案 — 如实回答，CEO 会自己判断
