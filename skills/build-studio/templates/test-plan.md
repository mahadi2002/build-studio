# Test plan: <name>

Date: <YYYY-MM-DD> · PRD: <link>

## Levels and tools
| Level | Tool | Runs where | Command |
|---|---|---|---|
| Unit | | local + CI | |
| Integration (API + DB) | | local + CI | |
| End-to-end | | CI against preview | |
| Security scan | | CI | |
| Load (if a target exists) | | manual before launch | |

## Coverage by story
| Story | Unit | Integration | E2E | Notes |
|---|---|---|---|---|
| US-1 | | | | |

## Likely to break (from the PRD)
| Input | Test name | Level |
|---|---|---|
| | | |

## Auth boundaries
- [ ] not logged in → 401
- [ ] wrong role → 403
- [ ] another user's ID → 403 or 404
- [ ] expired token → 401 and refresh works

## Test data
<How it is created and reset. No real user data.>

## Pass criteria
- All tests green on the exact commit being shipped
- <performance or accessibility targets, if any>
