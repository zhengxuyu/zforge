# zforge

My daily-driver AI coding agent skills. Works with Claude Code, Codex, OpenClaw, Hermes Agent, etc. Take what you find useful.

## Personality

Solves the blank-slate problem — agents forget everything between sessions.

`principle` loads `~/.claude/principles.md` at session start and silently extracts new signals from your corrections and decisions as you work. After a few sessions, a fresh agent doesn't need re-training. `autopilot` goes further — the agent consults your profile to answer its own questions instead of interrupting you, and logs every decision. `memory` auto-saves a working memory (what you're doing, decisions made, blockers) via session hooks and restores it on next start. Important stuff gets promoted to long-term memory that persists across projects.

| Skill | What it does |
|-------|-------------|
| `principle` | Extracts your style, decisions, quality bar into a reusable profile |
| `autopilot` | Agent answers its own questions from your profile, doesn't interrupt |
| `memory` | Working memory (daily notes) + long-term memory across sessions |

## Engineering

Guardrails for agents. Every skill enforces TDD, branch isolation, and PR gates.

### Build

| Skill | What it does |
|-------|-------------|
| `add-feat` | New feature — design, TDD, PR |
| `fix-bug` | Root cause, regression test, PR |
| `hotfix` | Emergency — smallest fix, fast PR |
| `minor-change` | Quick tweak — branch, change, test, PR |
| `refactor` | Restructure — tests green before and after |

### Ship

| Skill | What it does |
|-------|-------------|
| `pr-review` | Isolated worktree review, structured report |
| `git-release` | Tag, release notes, GitHub release |
| `update-deps` | Changelogs, compatibility tests, PR |

### Infra

| Skill | What it does |
|-------|-------------|
| `init-project` | Bootstrap repo, structure, tooling |
| `setup-ci` | GitHub Actions via single-question flow |
| `watchdog` | Monitor CI/CD, deployments, long-running jobs |
| `audit` | Security, quality, architecture review |

## Install

### Claude Code

Plugin install. Gets all skills + session hooks (personality distillation, memory auto-save/restore). [superpowers](https://github.com/obra/superpowers-marketplace) will be auto-installed on first session if not already present.

```bash
claude plugin add zhengxuyu/zforge
```

### Codex / Kiro / OpenClaw / Hermes Agent

Skills only (no hooks). Personality and memory skills still work but need manual invocation — no auto-inject at session start.

```bash
npx skills add zhengxuyu/zforge
```

### Manual

Clone and symlink into your agent's skill directory.

```bash
git clone https://github.com/zhengxuyu/zforge.git ~/.zforge
ln -s ~/.zforge/skills ~/.agents/skills/zforge
```

## License

MIT
