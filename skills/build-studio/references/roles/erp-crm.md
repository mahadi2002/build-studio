# ERP and CRM
tier: 2 | sources: OWASP ASVS (access control), double-entry bookkeeping basics, Odoo and ERPNext documentation | updated: 2026-11-26

## Triggers
- Inventory, orders, purchasing, invoicing, accounting-like records, customers, leads, pipelines, staff roles.
- Not for a public shop front (frontend and payments-fintech roles).
## Responsibilities
- Architecture: check existing tools before building. Plan: entities, roles, approval flows. Build: data model, workflows, imports and exports. Verify: permission and audit tests. Handoff: admin guide and backup steps.
## Role-specific rules
1. Before building, list free or open tools that already fit (see options). Build only the gap, and say so at G2.
2. Write roles and permissions as a table (role by action by record type). Enforce it on the server, inside the query.
3. Anything that changes money, stock or status goes through an approval step that saves who, when and why.
4. Audit trail: an append-only log of every create, change and delete, with actor and before and after values. The log cannot be edited.
5. Soft delete by default. Hard delete only through a logged process, and a customer data deletion request must still work (SKILL.md 6.5).
6. Stock and balances come from movements (in, out, adjust), not an overwritten number. Use transactions so stock is never oversold.
7. Imports: validate, show a dry-run preview, report row errors, allow undo. Exports: respect role access and leave out hidden fields.
8. Real customer or staff data is G3, even in a demo.
## Default tool options
- Existing open source: Odoo Community, ERPNext, InvenTree, SuiteCRM. Check licenses and hosting cost (uncertain: free-tier fit).
- A spreadsheet plus a form first for tiny teams; move when it hurts.
- Custom build: relational database, an admin UI library, background jobs for imports.
## Checklist
- [ ] Existing-tool comparison written
- [ ] Permission matrix tested with each role
- [ ] Audit log covers every write
- [ ] Import dry run and undo tested; CSV export works
## Common mistakes
- Building a full ERP for a five-person shop → configure an existing tool.
- Checking roles only in the UI → enforce them in the API.
- Overwriting a quantity field → record movements.
- Import that half-succeeds → run in one transaction or track per-row status.
## Definition of done
Role, audit log, import and export tests pass; the owner can finish one real workflow (for example order to invoice) on staging.
## Per-stack notes
- Postgres or MySQL: foreign keys, check constraints, and row locks (`SELECT ... FOR UPDATE`) for stock.
- Laravel or Django: use the built-in admin and permission system before custom screens.
