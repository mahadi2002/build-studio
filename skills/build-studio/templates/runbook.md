# Runbook: <name>

Production: <URL> · Preview: <URL pattern> · Host: <host> · DNS: Cloudflare, <subdomain>
Repo: <link> · Owner: me

## Health
- Health endpoint: <URL> (expected: <response>)
- Uptime check: <service, alert channel>
- Errors: <tracker link>
- Logs: <where, how to filter>

## Deploy
1. <command or push>, preview at <URL>
2. Smoke test: <the 3-5 critical flows>
3. Promote: <command> (needs my yes, G4)
4. After: re-test the main flow, watch errors for 15 minutes

## Rollback
- Trigger: login or main action fails, error rate clearly up, blank or very slow pages
- Command: <exact command, or dashboard steps>
- Database: <how to restore, where backups are, last tested restore date>

## Common incidents
| Symptom | Likely cause | First check | Fix |
|---|---|---|---|
| | | | |

## Secrets and env vars
<Where each is set (host dashboard), who can see it, how to rotate. Values never here.>

## Free-tier limits to watch
<quota, sleep, storage; what happens when hit>

## Backups
<What, how often, where, retention, restore steps.>
