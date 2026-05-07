---
name: init-project
description: Initialize a new project — repo, structure, CI, and first commit
user_invocable: true
---

# Init Project Workflow

Set up a new project with progressive single-question flow. Each step has a sensible default — user can just press Enter to accept.

## Interaction Model

Ask ONE question at a time. Show the default/recommendation in brackets. If the user provides no answer or says "ok/好/嗯/默认", use the default.

## Flow

### Step 1: Project name
Ask: "Project name?" — infer default from current directory name or user's earlier context.

### Step 2: Language/framework
Ask: "Language/framework? [recommended: TypeScript + Node.js]"
Recommend based on:
- If user mentioned a language earlier, use that
- If inside an existing repo with code, detect from files
- Otherwise default to TypeScript + Node.js

### Step 3: Repo visibility
Ask: "Public or private? [private]"
Default: private

### Step 4: CI/CD
Do NOT ask a generic "any CI/CD requirements?" question. Instead:
- Infer appropriate CI/CD from the chosen language/framework
- Present a concrete recommendation with explanation
- Example: "CI: GitHub Actions — lint + test on PR, build on push to main. [yes]"

The CI recommendation MUST be based on:
- Language: use the standard test runner and linter for that ecosystem
- Framework: if Next.js → add build step; if Python → add type check; etc.
- Keep it minimal but production-ready

### Step 5: Confirm and execute
Show a one-line summary of all choices, ask "Go? [yes]"

## Execution

Once confirmed:
1. `gh repo create <name> --private/--public --clone && cd <name>`
2. Create structure: standard dirs for the ecosystem (src/, tests/, etc.)
3. Add `.gitignore` (use GitHub's template for the language)
4. Add `README.md` with project name + one-line description
5. Set up package manager config with sensible defaults
6. Set up linter/formatter (the ecosystem standard, not custom)
7. Set up CI workflow based on the recommendation from Step 4
8. First commit:
```
git add -A
git commit -m "chore: initial project setup"
git push -u origin main
```

## CI/CD Inference Rules

| Ecosystem | Linter | Test | Build | Extra |
|-----------|--------|------|-------|-------|
| TypeScript/Node | eslint + prettier | vitest | tsc | — |
| Python | ruff | pytest | — | mypy type check |
| Rust | clippy | cargo test | cargo build | — |
| Go | golangci-lint | go test | go build | — |
| Next.js | eslint | vitest | next build | — |
| React (Vite) | eslint + prettier | vitest | vite build | — |

## Rules
- ONE question per message. Never batch questions.
- Always show default in [brackets]. Accept empty/affirmative as "use default."
- Never ask about things you can infer from context.
- Don't over-engineer — start minimal, extend later.
- Always include `.gitignore` and `README.md`.
- Test that the project builds/runs before committing.
