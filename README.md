# zforge

Standardized GitHub development workflow skills for AI coding agents — Claude Code, Codex, Kiro, OpenClaw, Hermes Agent, and more.

Type a slash command, get a disciplined workflow. TDD, branch isolation, PR review, quality checklist — every time, no exceptions.

## Why zforge?

AI coding agents are great at writing code, but they skip steps. They forget to branch, merge without approval, skip tests, or push broken code to main.

zforge gives your agent a complete set of development workflows so it follows the same discipline a senior engineer would: branch first, test first, review before merge, never ship without approval.

## Example Use Cases

**"Fix this login bug"** → `/zforge:fix-bug`
- Agent syncs main, creates `fix/login-bug` branch
- Reads error, traces root cause (no guessing)
- Writes a failing regression test first, then implements the fix
- Runs full test suite, self-reviews the diff
- Creates PR with root cause explanation, waits for your approval

**"Add dark mode support"** → `/zforge:add-feat`
- Agent presents design options and tradeoffs before writing code
- Creates `feat/dark-mode` branch
- TDD: writes tests first, implements incrementally
- Quality checklist before PR: what changed, is it systematic, any regressions?
- PR created, never merged without your say-so

**"Update the copyright year in the footer"** → `/zforge:minor-change`
- Quick branch, make the change, run tests, PR — no design overhead

**"Production is down, users can't checkout"** → `/zforge:hotfix`
- Smallest possible fix, regression test, fast PR
- If the fix is complex (>20 lines), automatically escalates to full `/fix-bug` workflow

**"Clean up the auth module, it's a mess"** → `/zforge:refactor`
- Verifies all tests pass before touching anything
- Refactors incrementally, tests must stay green after every change
- If a test breaks, the refactor changed behavior — revert and rethink

**"Review PR #42 before we merge"** → `/zforge:pr-review`
- Fetches diff, understands intent, reviews for correctness and security
- Runs tests locally, tries to break edge cases
- Structured report: Critical / Important / Suggestions with file:line citations

**"Cut a release"** → `/zforge:git-release`
- Reads version, generates grouped release notes from git log
- Shows you the notes before tagging — you approve, then it tags and creates GitHub release

**"Start a new project"** → `/zforge:init-project`
- Creates repo, sets up structure, tooling, .gitignore, README, optional CI

**"Update our dependencies"** → `/zforge:update-deps`
- Lists outdated deps, applies patches in bulk, minors in batches, majors one by one
- Tests after each batch, lock file committed alongside

**"Set up CI/CD for this project"** → `/zforge:setup-ci`
- Auto-detects language, package manager, test framework, build tool
- Walks you through a questionnaire: triggers, testing, coverage, linting, security, deployment
- Generates GitHub Actions workflows (ci.yml, deploy.yml, security.yml) with proper caching and concurrency
- You review and confirm before anything is written

## Skills

### Development

| Skill | When to use |
|-------|-------------|
| `/zforge:add-feat` | Building a new feature — design, TDD, PR |
| `/zforge:fix-bug` | Something's broken — systematic debugging, regression test, PR |
| `/zforge:hotfix` | Production is down — smallest possible fix, fast PR |
| `/zforge:minor-change` | Text tweak, config update, dead code removal — quick PR |
| `/zforge:refactor` | Restructuring code — tests green before and after |

### Operations

| Skill | When to use |
|-------|-------------|
| `/zforge:pr-review` | Review a PR before merge — diff, tests, structured report |
| `/zforge:git-release` | Cut a release — tag, push, GitHub release with notes |
| `/zforge:update-deps` | Update dependencies safely — changelogs, tests, PR |
| `/zforge:init-project` | Start a new project — repo, structure, tooling, first commit |
| `/zforge:setup-ci` | Set up CI/CD — interactive questionnaire, generates GitHub Actions workflows |

## Install

### npx skills add (recommended)

```bash
npx skills add zhengxuyu/zforge
```

### git clone

```bash
git clone git@github.com:zhengxuyu/zforge.git ~/.claude/skills/zforge
cd ~/.claude/skills/zforge
./setup
```

Auto-detects installed hosts and creates symlinks into their skill directories:

| Host | Directory |
|------|-----------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| Kiro | `~/.kiro/skills/` |
| Factory | `~/.factory/skills/` |

OpenClaw and Hermes Agent spawn Claude Code sessions, so they pick up skills from `~/.claude/skills/` automatically.

To install for a specific host only:

```bash
./setup --host codex
```

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
