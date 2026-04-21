---
name: git-release
description: Create a git release from current version — tag, push, and create GitHub release (no version bump)
user_invocable: true
---

# Git Release Workflow

Tag the current version and create a GitHub release so `npx` latest points to it.

## Steps

1. **Sync main**
```
git checkout main && git pull
```

2. **Read current version** from `pyproject.toml` and `package.json` — they must match

3. **Generate release notes**
   - Run `git log --oneline <last-tag>..HEAD` to get commits since last release
   - Group by type: Features, Bug Fixes, Refactors, Other
   - Format as markdown bullet list
   - Show CEO the release notes before proceeding

4. **Tag and push**
```
git tag vX.Y.Z
git push --tags
```

5. **Create GitHub release**
```
gh release create vX.Y.Z --title "vX.Y.Z" --notes "$(cat <<'EOF'
<release notes from step 3>
EOF
)"
```

6. **Create GitHub Discussions announcement**
```
gh api graphql -f query='mutation {
  createDiscussion(input: {
    repositoryId: "<repo_node_id>"
    categoryId: "DIC_kwDORZiF4M4C3ZbO"
    title: "vX.Y.Z Released"
    body: "Upgrade: `npx @1mancompany/onemancompany --update`\n\n[Changelog](https://github.com/1mancompany/OneManCompany/releases/tag/vX.Y.Z)"
  }) {
    discussion { url }
  }
}'
```
Get `repo_node_id` via `gh api repos/1mancompany/OneManCompany --jq .node_id`.

## Rules
- **No version bump** — version is already set by pre-commit hook, just tag and release
- **Always sync main first** — never release from a feature branch
- **Tag format**: `vX.Y.Z` (with `v` prefix)
- **Never skip the tag** — GitHub release requires a tag
- Show CEO the release notes before creating the release
- **Announcement**: keep it minimal — just upgrade command + changelog link, no feature list
