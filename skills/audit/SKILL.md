---
name: audit
description: Audit a codebase for security vulnerabilities, code quality issues, and architecture concerns
user_invocable: true
---

# Codebase Audit Workflow

Systematically review a codebase for security, quality, and architecture issues.

## Usage
```
/audit [target directory or file pattern]
```
If no target is specified, audit the entire repository.

## 1. Scope

- Confirm with the user what to audit (whole repo, specific directory, or area)
- Identify the tech stack, frameworks, and languages in use
- Check for existing linting, SAST, or audit tooling already configured

## 2. Security Scan

Review for common vulnerability classes:

- **Injection** — SQL injection, command injection, XSS, template injection
- **Authentication & Authorization** — missing auth checks, privilege escalation, insecure session handling
- **Secrets & Credentials** — hardcoded API keys, passwords, tokens in source or config
- **Data Exposure** — sensitive data in logs, verbose error messages, unencrypted storage
- **Dependency Vulnerabilities** — run `npm audit` / `pip audit` / language-equivalent; flag known CVEs
- **Insecure Defaults** — CORS wildcards, debug mode in production, permissive file permissions
- **Cryptography** — weak algorithms, predictable randomness, improper key management

## 3. Code Quality

- **Dead code** — unused functions, unreachable branches, commented-out blocks
- **Error handling** — silent catches, swallowed exceptions, missing error propagation
- **Complexity hotspots** — functions over 50 lines, deeply nested logic, high cyclomatic complexity
- **Untested paths** — critical logic without test coverage
- **Code duplication** — repeated logic that should be extracted
- **Naming & clarity** — misleading names, magic numbers, unclear intent

## 4. Architecture Review

- **Dependency structure** — circular dependencies, inappropriate coupling between modules
- **Separation of concerns** — business logic mixed with I/O, presentation mixed with data access
- **Single points of failure** — no retries on external calls, missing circuit breakers where needed
- **Scalability concerns** — unbounded queries, missing pagination, in-memory state that won't scale
- **Configuration** — hardcoded values that should be configurable, environment-specific logic in code

## 5. Report

Present findings as a structured report:

```
## Audit Report: <project or target>

### Summary
[2-3 sentences: overall health, most critical area]

### Findings

#### Critical (must fix — security risk or data loss)
- [file:line] Description of issue
  - Impact: ...
  - Fix: ...

#### Important (should fix — quality or reliability risk)
- [file:line] Description of issue
  - Impact: ...
  - Fix: ...

#### Suggestions (nice to have — maintainability improvements)
- [file:line] Description of issue
  - Suggestion: ...

### Metrics
- Files scanned: [count]
- Issues found: [critical / important / suggestion]
- Dependency vulnerabilities: [count from package audit]

### Top 3 Priorities
1. ...
2. ...
3. ...
```

## 6. Remediation (optional)

If the user wants to act on findings:
- For security fixes — kick off `/hotfix` for critical items
- For quality issues — kick off `/fix-bug` or `/refactor` as appropriate
- Prioritize: critical security > important security > critical quality > the rest

## Rules
- **Cite file:line for every finding** — no vague claims
- **Verify before reporting** — read the code, don't guess from names alone
- **No false positives** — if unsure, investigate deeper before flagging
- **Severity must be justified** — explain the impact, not just the pattern
- **Stay in scope** — audit what was asked, don't expand without asking
- **Don't fix during audit** — report first, fix separately
