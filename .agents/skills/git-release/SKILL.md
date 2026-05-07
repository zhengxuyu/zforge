---
name: git-release
description: Create a git release — tag, push, and create GitHub release
user_invocable: true
---

# Git Release Workflow

Tag the current version and create a GitHub release.

## Steps

1. **Sync main**
```
git checkout main && git pull
```

2. **Read current version** from `package.json`, `pyproject.toml`, `Cargo.toml`, or equivalent — whichever exists in the project

3. **Generate release notes**
   - Run `git log --oneline <last-tag>..HEAD` to get commits since last release
   - Group by type: Features, Bug Fixes, Refactors, Other
   - Format as markdown bullet list
   - Show the user the release notes before proceeding

4. **Tag and push**
```
git tag vX.Y.Z
git push origin main --tags
```

5. **Create GitHub release**
```
gh release create vX.Y.Z --title "vX.Y.Z" --notes "<release notes from step 3>"
```

## Rules
- **Always sync main first** — never release from a feature branch
- **Tag format**: `vX.Y.Z` (with `v` prefix)
- **Never skip the tag** — GitHub release requires a tag
- Show the user the release notes before creating the release
- Wait for user confirmation before tagging
