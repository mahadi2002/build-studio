# Payments and Fintech
tier: 2 | sources: PCI DSS (SAQ A guidance), Stripe API docs (idempotency, webhooks), double-entry bookkeeping basics | updated: 2026-11-26

## Triggers
- Taking payments, subscriptions, wallets, payouts, refunds, invoices, or any balance a user can see.
- Carrier billing (mobile operator subscriptions) follows the integration-api role and any house stack's skill.
## Responsibilities
- Architecture: pick the provider and hosted checkout; design the ledger. Build: payment flow, webhooks, refunds, reports. Verify: sandbox runs, reconciliation. Deploy: live keys at G3 and G4. Handoff: refund and dispute runbook.
## Role-specific rules
1. Use a payment provider with hosted checkout or hosted fields. Raw card numbers and CVV never touch my server, logs or database. This keeps PCI scope minimal (SAQ A type).
2. Store money as integer minor units (paisa, cents) plus a currency code. Never floats.
3. The ledger is append-only. Fix a mistake with a reversing entry, never an update or delete. Each entry has an ID, amount, account, reason and timestamp.
4. Every create or charge call carries an idempotency key, and the webhook handler dedupes by event ID (integration-api rules 7 and 9).
5. The verified webhook is the source of truth for paid or failed. The browser redirect only shows a pending page.
6. Reconcile daily: provider report against my ledger; alert on any gap.
7. Refunds and payouts need an approval step and an audit log, and never exceed the original amount.
8. Real money, a live key or a merchant account is G3. Warn the owner about KYC and merchant approval delays.
## Default tool options
- Global providers: Stripe does not onboard Bangladesh-registered businesses (it needs an entity in a supported country; check Stripe's country list); its docs still serve as the reference design.
- Local: SSLCommerz, bKash and Nagad merchant APIs; sandbox access and fees vary, confirm with each provider (uncertain).
- Manual fallback for tiny MVPs: user sends a bKash transaction ID, an admin verifies it.
## Checklist
- [ ] No card data in code, logs or database
- [ ] A test proves the ledger balances (debits equal credits)
- [ ] Duplicate webhook and retry tests pass
- [ ] Refund and failed-payment flows tested in the sandbox
## Common mistakes
- Marking an order paid on the success redirect → wait for the verified webhook.
- Updating a balance column directly → derive balance from ledger entries.
- Rounding in floats → use integers and round once, at a defined step.
- Letting a refund run twice → give each refund an idempotency key.
## Definition of done
Sandbox end-to-end runs for pay, fail and refund pass; ledger and reconciliation tests pass; provider keys exist only in host secrets.
## Per-stack notes
- Postgres or MySQL: unique constraints on the idempotency key and the provider event ID; write ledger rows in one transaction.
- Workers or serverless: verify the webhook signature on the raw body before parsing JSON.
