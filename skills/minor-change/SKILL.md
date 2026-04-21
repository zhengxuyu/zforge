---
name: minor-change
description: Small tweaks to existing features — no brainstorming or plan needed, just TDD and PR
user_invocable: true
---

# Minor Change Workflow

For small adjustments to existing features: text changes, style tweaks, config updates, removing dead code, renaming, etc. No brainstorming or plan needed.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Create branch
- Branch naming: `fix/<description>` or `chore/<description>`

## 3. Make the change
- If the change touches logic, write a test first (TDD)
- If purely cosmetic (text, style, config), test is optional
- Run full test suite after changes

## 4. Verify
- Run all tests: `.venv/bin/python -m pytest tests/unit/ -x -q`
- Verify compilation if Python changed

## 5. Code Review (superpowers:requesting-code-review)
- Dispatch code-reviewer subagent before creating PR
- Fix ALL issues: Critical, Important, AND Suggestions
- **Verify each finding** — if reviewer is hallucinating (claiming a bug that doesn't exist), gather evidence (read the code, run the test) and reject the finding with reasoning
- Re-run review after fixes until zero issues remain

## 6. Create PR
- Commit with concise message
- Push and create PR via `gh pr create`
- Return PR URL to boss
- **DO NOT merge** — wait for boss to say "merge"

## 7. Merge (only when boss says)
- `gh pr merge <number> --admin --merge`
- Clean up: `git checkout main && git pull && git branch -d <branch>`

## Rules
- **Never merge without boss confirmation**
- **Never push directly to main**
- **Zero tolerance for code smells:**
  - No dead code (empty functions, unused variables, commented-out blocks)
  - No string literals for values that should be constants/enums
  - No duplicate systems (same data via two paths = Critical defect)
  - No technical debt left behind — fix it now or don't write it
- **Never commit planning materials** — `docs/superpowers/` (specs, plans) is .gitignored. Never `git add -f` to override.
- Keep changes small and focused — one concern per PR

## Quality Checklist (每次提交 PR 前必须逐项检查并输出)

完成所有代码修改后，**必须**逐项回答以下问题，格式化输出给 CEO：

| # | 检查项 | 回答 |
|---|--------|------|
| 1 | **解决方式** — 改了什么、怎么改的 | [简述] |
| 2 | **根本性解决** — 改动是否到位，还是只改了表面 | [是/否 + 依据] |
| 3 | **唯一真源** — 是否遵循磁盘即唯一真源原则，有没有引入内存缓存或重复数据路径 | [是/否 + 依据] |
| 4 | **测试回归** — 现有 unit test 是否全部通过 | [通过数/失败数] |
| 5 | **重复造轮子** — 是否复用了已有模式/函数，有没有重新实现已存在的功能 | [是/否 + 依据] |

- 如果任何一项答案不理想，**必须先修复再提交 PR**
- 不要美化答案 — 如实回答，CEO 会自己判断
