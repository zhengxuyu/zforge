# zforge

Standardized GitHub development workflow skills for Claude Code.

## Skills

| Skill | Description |
|-------|-------------|
| `/add-feat` | Add a new feature with design, TDD, and PR workflow |
| `/fix-bug` | Fix a bug with systematic debugging, TDD, and PR workflow |
| `/hotfix` | Emergency fix — minimal change, fast PR |
| `/minor-change` | Small tweaks — no design needed, just TDD and PR |
| `/refactor` | Refactor code with safety nets — tests green before and after |
| `/pr-review` | Review a pull request — check diff, run tests, report findings |
| `/git-release` | Tag, push, and create GitHub release |
| `/init-project` | Initialize a new project — repo, structure, CI |
| `/update-deps` | Update dependencies safely — changelogs, tests, PR |

## Install

```bash
git clone git@github.com:zhengxuyu/zforge.git ~/.claude/skills/zforge
cd ~/.claude/skills/zforge
./setup
```

## Update

```bash
cd ~/.claude/skills/zforge && git pull && ./setup
```

## How it works

`setup` creates symlinks from `~/.claude/skills/<skill-name>/` to each skill in this repo, so Claude Code discovers them automatically. Same pattern as gstack.

## Philosophy

Every skill follows the same principles:

- **TDD** — write tests first, implement second
- **Branch workflow** — never push directly to main
- **PR discipline** — never merge without explicit approval
- **Quality checklist** — self-check before every PR
- **Single source of truth** — no duplicate data paths
