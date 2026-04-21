---
name: setup-ci
description: Set up CI/CD workflows via interactive questionnaire — unit tests, build, coverage, linting, deploy, and custom actions
user_invocable: true
---

# Setup CI/CD Workflow

Generate GitHub Actions CI/CD workflows by collecting project requirements through a questionnaire.

## 1. Sync main
```
git checkout main && git pull
```

## 2. Create worktree and branch
```
git worktree add .claude/worktrees/chore-setup-ci -b chore/setup-ci
cd .claude/worktrees/chore-setup-ci
```
All work happens in the worktree — main stays clean.

## 3. Auto-detect project context

Before asking questions, scan the project to pre-fill answers:

- **Language/runtime**: check for `package.json` (Node.js), `pyproject.toml`/`setup.py`/`requirements.txt` (Python), `Cargo.toml` (Rust), `go.mod` (Go), `pom.xml`/`build.gradle` (Java), `Gemfile` (Ruby), etc.
- **Package manager**: npm/yarn/pnpm/bun, pip/poetry/uv, cargo, go, maven/gradle
- **Test framework**: detect from config or dependencies (jest, pytest, cargo test, go test, etc.)
- **Build command**: check `scripts.build` in package.json, Makefile targets, etc.
- **Existing CI**: check if `.github/workflows/` already exists — if so, ask if user wants to replace or extend
- **Monorepo**: check for `workspaces`, `turbo.json`, `nx.json`, `lerna.json`

Present findings: "I detected: [language], [package manager], [test framework], [build tool]. Is this correct?"

## 4. Interactive questionnaire

Ask the user each section. Use the auto-detected defaults where available. Skip questions that don't apply.

### Section A: Basics

| # | Question | Options |
|---|----------|---------|
| A1 | **Trigger branches** — which branches should trigger CI? | `main` only / `main` + PR / all branches / custom |
| A2 | **Node/Python/Go version(s)** — which version(s) to test against? | single version / matrix (e.g., 3.11, 3.12, 3.13) |
| A3 | **OS matrix** — which OS to run on? | ubuntu-latest only / ubuntu + macos / ubuntu + macos + windows |

### Section B: Testing

| # | Question | Options |
|---|----------|---------|
| B1 | **Unit tests** — enable? | yes / no |
| B2 | **Test command** — what runs your tests? | auto-detected or custom |
| B3 | **Coverage check** — enable minimum coverage threshold? | no / yes → ask threshold (e.g., 80%) |
| B4 | **Coverage tool** — which tool? | auto-detect (coverage.py, istanbul/c8, tarpaulin, etc.) or custom |
| B5 | **Upload coverage report?** — to Codecov, Coveralls, or artifact? | none / codecov / coveralls / artifact |

### Section C: Build & Lint

| # | Question | Options |
|---|----------|---------|
| C1 | **Build step** — enable? | yes / no / not applicable |
| C2 | **Build command** | auto-detected or custom |
| C3 | **Linting** — enable? | yes / no |
| C4 | **Lint command** | auto-detected (eslint, ruff, clippy, golangci-lint, etc.) or custom |
| C5 | **Type checking** — enable? | yes / no (for TS: tsc --noEmit, Python: mypy/pyright, etc.) |
| C6 | **Format check** — enable? | yes / no (prettier, black, rustfmt, gofmt, etc.) |

### Section D: Security & Quality

| # | Question | Options |
|---|----------|---------|
| D1 | **Dependency audit** — check for known vulnerabilities? | yes / no |
| D2 | **Secret scanning** — add trufflehog or gitleaks? | yes / no |
| D3 | **SAST** — static analysis (CodeQL, semgrep)? | none / codeql / semgrep / custom |

### Section E: Deployment

| # | Question | Options |
|---|----------|---------|
| E1 | **Auto-deploy** — deploy on merge to main? | no / yes → ask target |
| E2 | **Deploy target** | Vercel / Netlify / AWS / GCP / Fly.io / Docker registry / npm publish / PyPI publish / custom |
| E3 | **Preview deploys** — on PR? | yes / no |
| E4 | **Release automation** — auto-create GitHub release on tag? | yes / no |

### Section F: Custom additions

| # | Question | Options |
|---|----------|---------|
| F1 | **Additional workflows** — anything else you need? | free text — user describes custom needs |

Examples to suggest if user is unsure:
- Scheduled jobs (cron-based cleanup, stale issue bot)
- Performance benchmarks on PR
- Docker image build and push
- Database migration check
- E2E tests (Playwright, Cypress)
- Changelog generation
- PR labeling / auto-assign
- Notification (Slack, Discord, email)

## 5. Generate workflows

Based on answers, generate GitHub Actions YAML files:

- **`.github/workflows/ci.yml`** — main CI pipeline (test, build, lint, coverage)
- **`.github/workflows/deploy.yml`** — deployment pipeline (if E1 = yes)
- **`.github/workflows/security.yml`** — security checks (if any D section = yes)
- **Additional files** — one per custom workflow from Section F

### CI workflow template structure

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up <runtime>
        uses: actions/setup-<runtime>@v5
        with:
          <runtime>-version: '<version>'
      - name: Install dependencies
        run: <install-command>
      - name: Lint
        run: <lint-command>
      - name: Type check
        run: <typecheck-command>
      - name: Test
        run: <test-command>
      - name: Coverage check
        run: <coverage-command>
        # fail if below threshold
```

### Rules for generation
- Use the latest stable action versions (checkout@v4, setup-node@v5, setup-python@v5, etc.)
- Pin action versions to major tags, not SHA (readable + auto-patches)
- Add `concurrency` group to cancel stale runs on same PR
- Cache dependencies (actions/cache or built-in caching in setup actions)
- Keep jobs parallelized where possible (lint and test can run concurrently)
- Add meaningful job names and step names
- Use `fail-fast: false` in matrix builds so one failure doesn't cancel others

## 6. Present and confirm

Show the user:
- List of files to be created
- Summary of what each workflow does
- Any secrets or environment variables they'll need to configure

Ask for confirmation before writing files.

## 7. Write files and create PR

- Write all workflow files to `.github/workflows/`
- Commit with descriptive message
- Push and create PR via `gh pr create`
- Wait for CI/CD checks to complete: `gh pr checks <number> --watch`
- If checks fail, fix the issues and push again — do not notify the user until all checks are green
- Once all checks pass, return the PR URL and ask the user to review
- **DO NOT merge** — wait for explicit approval

## 8. Merge (only when approved)
- `gh pr merge <number> --merge`
- Clean up worktree: `cd <project-root> && git worktree remove .claude/worktrees/chore-setup-ci`
- `git checkout main && git pull && git branch -d chore/setup-ci`

## Rules
- **Never merge without explicit approval**
- **Never push directly to main**
- **Always auto-detect first** — don't ask questions you can answer by reading the project
- **Present defaults** — user should only need to confirm or override, not type from scratch
- **One concern per workflow file** — don't cram everything into one giant YAML
- **Never hardcode secrets** — always use `${{ secrets.XXX }}` and tell user what to configure
