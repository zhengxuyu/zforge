---
name: fix-bug
description: Fix a bug with systematic debugging, TDD, and PR workflow — no plan needed
user_invocable: true
---

# Fix Bug Workflow

Follow this exact sequence. No plan needed — go straight to debugging.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Systematic Debugging (superpowers:systematic-debugging)
- **DO NOT guess fixes** — follow the debugging protocol
- Phase 1: Read errors, reproduce, check recent changes, gather evidence
- Phase 2: Find working examples, compare
- Phase 3: Form hypothesis, test minimally
- Phase 4: Implement fix with test

## 3. Create branch
- Branch naming: `fix/<bug-description>`
- No worktree needed for simple fixes; use worktree for larger changes

## 4. TDD Fix (superpowers:test-driven-development)
- **Write a failing test that reproduces the bug FIRST**
- Then implement the fix
- The test must pass after the fix
- Run full test suite

## 5. Verify (superpowers:verification-before-completion)
- Run all tests: `.venv/bin/python -m pytest tests/unit/ -x -q`
- Verify the original bug is fixed
- Check no regressions

## 6. Code Review (superpowers:requesting-code-review)
- Dispatch code-reviewer subagent
- Fix ALL issues: Critical, Important, AND Suggestions
- **Verify each finding** — if reviewer is hallucinating (claiming a bug that doesn't exist), gather evidence (read the code, run the test) and reject the finding with reasoning
- Re-run review after fixes until zero issues remain

## 7. Create PR
- Commit with message explaining the root cause
- Push branch and create PR via `gh pr create`
- Return the PR URL to boss
- **DO NOT merge** — wait for boss to say "merge"

## 8. Merge (only when boss says)
- `gh pr merge <number> --admin --merge`
- Clean up: `git checkout main && git pull && git branch -d <branch>`

## Rules
- **Never merge without boss confirmation**
- **Never push directly to main**
- **Always write a regression test** — the bug must never come back
- **No plan needed** — bugs are urgent, go straight to debugging
- **Zero tolerance for code smells:**
  - No dead code (empty functions, unused variables, commented-out blocks)
  - No string literals for values that should be constants/enums
  - No duplicate systems (same data via two paths = Critical defect)
  - No technical debt left behind — fix it now or don't write it
- **Never commit planning materials** — `docs/superpowers/` (specs, plans) is .gitignored. Never `git add -f` to override.
- If 3+ fix attempts fail, stop and question the architecture

## Quality Checklist (每次提交 PR 前必须逐项检查并输出)

完成所有代码修改后，**必须**逐项回答以下问题，格式化输出给 CEO：

| # | 检查项 | 回答 |
|---|--------|------|
| 1 | **解决方式** — 修了什么、怎么修的 | [简述] |
| 2 | **根本性修复** — 是否解决了 root cause，还是只修了表面症状 | [是/否 + 依据] |
| 3 | **唯一真源** — 是否遵循磁盘即唯一真源原则，有没有引入内存缓存或重复数据路径 | [是/否 + 依据] |
| 4 | **测试回归** — 现有 unit test 是否全部通过 | [通过数/失败数] |
| 5 | **重复造轮子** — 是否复用了已有模式/函数，有没有重新实现已存在的功能 | [是/否 + 依据] |

- 如果任何一项答案不理想，**必须先修复再提交 PR**
- 不要美化答案 — 如实回答，CEO 会自己判断
