# zforge

Personality distillation and development workflow skills for AI coding agents — Claude Code, Codex, Kiro, OpenClaw, Hermes Agent, and more.

## Distill Yourself

The `principle` skill reads `~/.claude/principles.md` at session start and operates according to your communication style, decision patterns, and quality bar. As you work together it silently distills new signals from your corrections and choices, so the agent gets sharper without you repeating yourself. After a few sessions, a fresh agent can read that file and behave indistinguishably from one that's worked with you for weeks.

Pair it with `autopilot`: the agent answers its own questions by consulting your profile, logs every auto-decision with reasoning, and keeps going. Wrong prediction? Your correction feeds back into the profile.

## Development Workflows

Every development skill enforces TDD, branch isolation, PR gate, and a quality checklist. Type a slash command, get a disciplined workflow.

`/fix-bug` — systematic debugging, regression test, PR. `/add-feat` — design discussion, TDD, incremental PR. `/hotfix` — smallest possible fix, fast PR, auto-escalates if complex. `/minor-change` — quick branch, change, test, PR. `/refactor` — tests green before and after every change. `/audit` — security, quality, architecture report with file:line citations. `/watchdog` — cheap Haiku subagent polls CI/deployments, escalates on failure. `/pr-review` — isolated worktree, diff review, structured findings. `/git-release` — grouped release notes, you approve before tagging. `/update-deps` — patches in bulk, majors one by one, tests after each. `/init-project` — repo, structure, tooling, first commit. `/setup-ci` — interactive questionnaire, generates GitHub Actions workflows.

## Skills

### Personality Distillation

| Skill | Description |
|-------|-------------|
| `/zforge:principle` | Distill yourself — agent learns your style, decisions, quality bar |
| `/zforge:autopilot` | Autonomous mode — agent answers its own questions from your profile |

### Development Workflows

| Skill | Description |
|-------|-------------|
| `/zforge:add-feat` | New feature — design, TDD, PR |
| `/zforge:fix-bug` | Debugging — root cause, regression test, PR |
| `/zforge:hotfix` | Emergency — smallest fix, fast PR |
| `/zforge:minor-change` | Quick tweak — branch, change, test, PR |
| `/zforge:refactor` | Restructure — tests green before and after |
| `/zforge:watchdog` | Monitor — CI/CD, deployments, long-running jobs |
| `/zforge:audit` | Audit — security, quality, architecture |
| `/zforge:pr-review` | Review — isolated worktree, structured report |
| `/zforge:git-release` | Release — tag, notes, GitHub release |
| `/zforge:update-deps` | Dependencies — changelogs, tests, PR |
| `/zforge:init-project` | Bootstrap — repo, structure, tooling |
| `/zforge:setup-ci` | CI/CD — GitHub Actions via questionnaire |

## Install

```bash
npx skills add zhengxuyu/zforge
```

Or clone manually:

```bash
git clone git@github.com:zhengxuyu/zforge.git ~/.claude/skills/zforge
cd ~/.claude/skills/zforge && ./setup
```

The setup script auto-detects installed hosts (Claude Code, Codex, Kiro, Factory) and creates symlinks. OpenClaw and Hermes Agent use Claude Code's skill directory automatically.

## Update

```bash
npx skills update zhengxuyu/zforge
```

Or `cd ~/.claude/skills/zforge && git pull && ./setup`.

## Adding Skills

Create `skills/my-skill/SKILL.md` with frontmatter (`name`, `description`, `user_invocable: true`) and your workflow steps. Run `./setup` to register.

## License

MIT
