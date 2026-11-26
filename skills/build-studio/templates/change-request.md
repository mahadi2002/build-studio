# Change request CR-<NNN>: <title>

Date: <YYYY-MM-DD> · Status: proposed / approved on <date> / rejected
Affects: ADR-<NNN>, <components>

## What changed
<The new need and why the current stack can't meet it as is. Evidence: a requirement, a limit hit, an error.>

## Options
| Option | What it means | Effort | Risk | Monthly cost change |
|---|---|---|---|---|
| Keep + workaround | | | | |
| Partial swap | | | | |
| Full migration | | | | |

Recommended: <option> because <reason>.

## Data migration plan
1. Backup: <what, where, how restore is tested>
2. Move: <steps, scripts, order>
3. Check: <row counts, spot checks, the main flow on the new setup>

## Rollback
<Exact steps and commands to return to the current setup, and how long data stays compatible.>

## Updates in the same change
- [ ] ADR updated or superseded
- [ ] README (stack, setup, env vars)
- [ ] .env.example
- [ ] runbook
- [ ] affected role notes
