# zforge

Personal development workflow skills for Claude Code.

## Skills

| Skill | Description |
|-------|-------------|
| `/fix-bug` | Fix a bug with systematic debugging, TDD, and PR workflow |
| `/add-feat` | Add a new feature with TDD, worktree isolation, PR workflow |
| `/minor-change` | Small tweaks — no brainstorming, just TDD and PR |
| `/git-release` | Tag, push, and create GitHub release |
| `/mp` | Switch to main and pull |

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
