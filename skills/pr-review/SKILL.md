---
name: pr-review
description: Review a pull request — check diff, run tests, report findings
user_invocable: true
---

# PR Review Workflow

Review a pull request systematically before merge.

## Usage
```
/pr-review <PR number or URL>
```

## Steps

1. **Fetch PR details**
```
gh pr view <number> --json title,body,files,commits
gh pr diff <number>
```

2. **Understand the change**
- Read the PR description — what problem does it solve?
- Look at the commit history — is the story coherent?
- Identify the scope: which files changed, what's the blast radius?

3. **Review the diff**
For each changed file:
- Does the change match the stated intent?
- Are there edge cases not handled?
- Any security issues? (injection, auth bypass, data leak)
- Any performance concerns? (N+1 queries, unbounded loops, missing indexes)
- Dead code, unused imports, debug prints left behind?
- Tests added or updated for the change?

4. **Run tests locally**
```
git fetch origin pull/<number>/head:pr-<number>
git checkout pr-<number>
```
- Run the full test suite
- Try to break the new code with edge case inputs

5. **Report findings**
Present as a structured report:

```
## PR Review: #<number> — <title>

### Summary
[1-2 sentences on what the PR does]

### Findings

#### Critical (must fix)
- ...

#### Important (should fix)
- ...

#### Suggestions (nice to have)
- ...

### Tests
- Suite: [pass/fail count]
- Coverage: [new code covered? y/n]

### Verdict: [Approve / Request Changes / Needs Discussion]
```

6. **Clean up**
```
git checkout main && git branch -d pr-<number>
```

## Rules
- **Be specific** — cite file:line for every finding
- **Verify findings** — if you suspect a bug, prove it with a test or trace
- Don't nitpick style unless it hurts readability
- Security and correctness issues are always Critical
