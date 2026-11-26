# Threat model: <name>

Date: <YYYY-MM-DD> · Scope: <components and data in scope>

## Assets
- <what an attacker wants: accounts, personal data, money, admin access, API keys, compute or AI credits>

## Entry points and trust boundaries
- <browser → API, API → DB, webhooks in, admin panel, file upload, third-party APIs, AI model input>

## STRIDE (one row per real threat; skip rows that don't apply)
| Threat | Example here | Mitigation | Test or check | OWASP 2025 |
|---|---|---|---|---|
| Spoofing | | | | A07 |
| Tampering | | | | A08 |
| Repudiation | | | | A09 |
| Information disclosure | | | | A01 / A04 |
| Denial of service | | | | API4 |
| Elevation of privilege | | | | A01 |

## AI features (if any)
- Untrusted text that reaches the model: <user input, fetched pages, files>
- What the model can do: <tools, side effects>; approval needed for: <...>
- Cost cap: <per user, global>

## Accepted risks
- <risk, why accepted, when to revisit>
