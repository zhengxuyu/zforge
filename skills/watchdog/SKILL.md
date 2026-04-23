---
name: watchdog
description: "Periodically monitor any long-running process (CI/CD pipeline, deployment, job, server) using a cheap Haiku subagent for status checks, and escalate to the main model when issues are detected. Use when asked to monitor, babysit, watch, keep an eye on, or check periodically."
user_invocable: true
---

# Watchdog — Periodic Process Monitor

Monitor any long-running process with cheap, periodic status checks. Escalate to the main model only when something goes wrong.

## Workflow

1. **Understand the target** — what to check, how often, what counts as an error
2. **Spawn Haiku subagent** to run the status check (cheap, fast)
3. **Evaluate the result**:
   - All clear → report briefly, schedule next wakeup
   - Anomaly detected → main model handles diagnosis and fix
4. **Schedule next wakeup** with `ScheduleWakeup` using the same loop prompt

## Haiku Subagent

Delegate only data-gathering to Haiku. Keep the prompt minimal:

```
Check <target>:
1. <command 1>
2. <command 2>

Return:
- STATUS: <one word>
- DETAIL: <key numbers or last log line>
- ERROR: <error message or "none">
- ANOMALY: yes/no
```

Anomaly = yes when: failure state, error in output, metric out of expected range, no progress detected, resource exhaustion.

## Scheduling Intervals

Choose the interval based on the task:

| Scenario | Interval |
|----------|----------|
| CI/CD pipeline checks | `60s` |
| Deployment health checks | `60s` |
| Active debugging / fast iteration | `60s` |
| Waiting for a slow process to start | `120–180s` |
| Long-running job (training, migration) | `270s` (stay in cache) |
| Idle monitoring (server health) | `600–1200s` |

Use `ScheduleWakeup` after every check. Pass the original user prompt verbatim as the `prompt` field so the loop continues.

## Escalation

When Haiku reports `ANOMALY: yes`, the main model should:
1. Read the full context (logs, output, error message)
2. Diagnose root cause
3. Apply fix (edit config, resubmit job, restart service, push new commit, etc.)
4. Update the loop prompt with new target info if needed
5. Continue monitoring

## CI/CD Pipeline Monitoring (common pattern)

For PR CI/CD checks specifically:

```bash
# Haiku checks this every 60s
gh pr checks <number> --json name,state,conclusion
```

**Interpret results:**
- All checks `state: completed` + `conclusion: success` → notify user, stop loop
- Any check `conclusion: failure` → ANOMALY, escalate to main model
- Checks still `state: pending` or `in_progress` → schedule next check in 60s

**On CI failure escalation:**
1. Read the failing check logs: `gh run view <run-id> --log-failed`
2. Diagnose the failure (test error, lint issue, build failure, etc.)
3. Fix the issue in the worktree
4. Commit and push the fix
5. Resume monitoring loop for the new run

## Stop Conditions

Stop monitoring when:
- Target reaches a terminal **success** state
- User cancels the loop
- Issue is unresolvable (after escalation and fix attempts)
- Max iterations reached (configurable, default: no limit)
