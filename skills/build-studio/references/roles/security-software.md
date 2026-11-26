# Security Software
tier: 2 | sources: NIST SP 800-63B, OWASP Cryptographic Storage and Authentication Cheat Sheets, RFC 6749 and RFC 7519 | updated: 2026-11-26
## Triggers
- Building IAM, login, SSO, token or API-key systems, password or secret storage, encryption features, key management, audit logging.
- Not for reviewing an app's own security (appsec role) or cloud IAM settings (cloud-security role).
## Responsibilities
- Architecture: the threat model, who holds which key, token lifetimes, recovery flows.
- Build: use a vetted library or standard protocol for each primitive.
- Verify: abuse tests, key rotation drill, known-answer tests for crypto calls.
## Role-specific rules
1. **Never invent crypto.** No custom cipher, hash, token format, padding or key derivation. Use a vetted library and a standard protocol (OAuth 2.0, OpenID Connect, TLS, WebAuthn).
2. **Pick the high-level API.** Prefer libsodium or a library's authenticated-encryption call (AES-GCM or XChaCha20-Poly1305) over assembling modes yourself.
3. **Passwords:** hash with Argon2id, scrypt or bcrypt, with the library's own salt. Never encrypt passwords, never use plain SHA or MD5.
4. **Randomness** for tokens and keys comes from the OS CSPRNG, never `Math.random` or a seeded generator.
5. **Compare secrets in constant time.** Never log secrets, tokens or full keys.
6. **Keys are never in code or git.** Keep them in a secret store or env vars; separate keys per environment and per purpose.
7. **Plan rotation from day one:** key IDs in the data, old keys kept to decrypt, a tested rotation runbook.
8. **Tokens:** short-lived access tokens, rotating refresh tokens, server-side revocation. For JWT, fix the allowed algorithm, check `exp`, `aud` and `iss`.
9. **OAuth:** authorization code with PKCE; exact redirect-URI match; check `state`.
10. **Authorization is separate from authentication:** check every request on the server, deny by default, log denials.
11. **Do not roll your own auth** if a vetted service or library fits the free tier; creating an account there is G3 (SKILL.md 2).
## Default tool options
- Auth: Supabase Auth, Keycloak (self-hosted), Authentik, Lucia-style session libraries, framework built-ins (Laravel, Django).
- Crypto: libsodium, Web Crypto API, Python `cryptography`, Go `crypto` standard library.
- Secrets: Doppler or Infisical free tier, SOPS with age, platform secret stores.
## Checklist
- [ ] Each primitive maps to a named library and standard
- [ ] No keys or tokens in repo (secret scan run)
- [ ] Rotation drill done once
- [ ] Authorization tests: anonymous, wrong user, wrong role
- [ ] Token expiry and revocation tested
## Common mistakes
- Home-made token or "encryption" → swap for a standard.
- ECB mode, reused nonces, static IV → use authenticated encryption through a high-level API.
- Long-lived tokens with no revocation → short expiry plus rotation.
## Definition of done
Abuse tests pass, the rotation drill is recorded, the secret scan is clean, and the security pass (SKILL.md 6.4) covers the new auth paths.
## Per-stack notes
- Node: `argon2` or `bcrypt`, `jose` for JWT; avoid `jsonwebtoken` misuse by fixing algorithms.
- PHP/Laravel: `Hash::make`, Sanctum or Passport; `password_hash` in plain PHP.
