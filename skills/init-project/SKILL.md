---
name: init-project
description: Initialize a new project — repo, structure, CI, and first commit
user_invocable: true
---

# Init Project Workflow

Set up a new project with proper structure from day one.

## Steps

1. **Gather requirements**
- What language / framework?
- Project name?
- Public or private repo?
- Any CI/CD requirements?

2. **Create repo**
```
gh repo create <name> --public/--private --clone
cd <name>
```

3. **Set up project structure**
- Create standard directories (src, tests, docs as needed)
- Add `.gitignore` appropriate for the language
- Add `README.md` with project name and one-line description
- Add license file if specified

4. **Set up tooling**
- Package manager config (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.)
- Linter / formatter config if applicable
- Test framework setup

5. **Set up CI** (if requested)
- GitHub Actions workflow for test + lint on PR
- Keep it minimal — can be extended later

6. **First commit**
```
git add -A
git commit -m "chore: initial project setup"
git push -u origin main
```

## Rules
- Ask before adding anything beyond the basics
- Don't over-engineer the initial setup — start minimal
- Always include `.gitignore` and `README.md`
- Test that the project builds/runs before committing
