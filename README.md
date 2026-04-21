# zforge

Standardized GitHub development workflow skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Type a slash command, get a disciplined workflow. TDD, branch isolation, PR review, quality checklist — every time, no exceptions.

## Skills

### Development

| Skill | When to use |
|-------|-------------|
| `/add-feat` | Building a new feature — design, TDD, PR |
| `/fix-bug` | Something's broken — systematic debugging, regression test, PR |
| `/hotfix` | Production is down — smallest possible fix, fast PR |
| `/minor-change` | Text tweak, config update, dead code removal — quick PR |
| `/refactor` | Restructuring code — tests green before and after |

### Operations

| Skill | When to use |
|-------|-------------|
| `/pr-review` | Review a PR before merge — diff, tests, structured report |
| `/git-release` | Cut a release — tag, push, GitHub release with notes |
| `/update-deps` | Update dependencies — changelogs, incremental testing, PR |
| `/init-project` | Start a new project — repo, structure, tooling, first commit |

## Install

```bash
git clone git@github.com:zhengxuyu/zforge.git ~/.claude/skills/zforge
cd ~/.claude/skills/zforge
./setup
```

This creates symlinks from `~/.claude/skills/<skill-name>/` to each skill, so Claude Code discovers them automatically.

## Update

```bash
cd ~/.claude/skills/zforge && git pull && ./setup
```

## Principles

Every skill enforces the same discipline:

- **TDD** — write tests first, implement second
- **Branch workflow** — never push directly to main
- **PR gate** — never merge without explicit approval
- **Quality checklist** — self-check before every PR (what changed, root cause, single source of truth, test regression, reuse)
- **Systematic debugging** — no guessing, find root cause first

## Adding your own skills

Create a directory under `skills/` with a `SKILL.md` file:

```
skills/my-skill/SKILL.md
```

SKILL.md format:

```markdown
---
name: my-skill
description: One-line description shown in Claude Code
user_invocable: true
---

# My Skill

Your workflow steps here...
```

Run `./setup` to register the new skill.

## License

MIT
