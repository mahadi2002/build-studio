# Blockchain
tier: 2 | sources: Trail of Bits building-secure-contracts, OpenZeppelin Contracts docs, SWC Registry | updated: 2026-11-26

## Triggers
- Smart contracts, tokens, NFTs, dApps, wallet sign-in, or any on-chain transaction.
- Not for a normal app that only takes card payments (use payments-fintech).
## Responsibilities
- Architecture: decide what must be on-chain; keep the rest off-chain. Plan: threat model and upgrade plan. Build and verify: contracts, tests, static analysis. Deploy: testnet first, then mainnet.
## Role-specific rules
1. Audit-first mindset: a deployed contract is hard to fix. Write the invariants (what must always be true) before the code.
2. Testnet first. Mainnet deploy needs G3 (real funds, keys) and G4. Never deploy from a wallet that holds personal funds.
3. Never put a private key or seed phrase in code, the repo, chat or logs. Use a hardware wallet or a multisig for the owner role.
4. Use audited libraries (OpenZeppelin) for tokens, access control and proxies. Do not rewrite them.
5. Guard the known classes: reentrancy (checks-effects-interactions, reentrancy guard), access control gaps, unchecked external calls, oracle or price manipulation, front-running, rounding errors, bad upgrade storage layout.
6. Test with unit, fuzz and invariant tests, then run a static analyzer. Tool output is a lead, not proof.
7. Keep contracts small and emit an event for every state change. Add a pause switch only if the threat model asks for it.
8. A professional audit is needed before real user funds. Say so at G2 and put its cost in the budget (uncertain: no free equivalent).
## Default tool options
- Foundry (tests, fuzzing, invariants) for Solidity; Hardhat if the project is JavaScript-heavy.
- Slither for static analysis; Echidna for fuzzing. Both are free.
- Local node (anvil or Hardhat network), then a public testnet with a free faucet. Faucet and RPC accounts are G3.
## Checklist
- [ ] Invariants written; fuzz tests pass
- [ ] Slither run; each finding fixed or explained
- [ ] Secret scan shows no keys in repo history
- [ ] Testnet deploy and a full user flow done; source verified on the explorer
## Common mistakes
- Hand-written token or access code → import the audited library.
- Updating state after an external call → follow checks-effects-interactions.
- Using `tx.origin` or block timestamp for rules → use `msg.sender`; treat timestamps as loose.
- Skipping the front-end threat model → wallet phishing and wrong-network prompts still lose funds.
## Definition of done
Tests, fuzz runs and Slither pass; the verified testnet deployment works end to end; the audit status, owner key setup and upgrade plan are in the runbook.
## Per-stack notes
- Solidity on EVM chains: pin the compiler version; use upgradeable contracts only if upgrades are truly needed.
- Frontend: ethers or viem; check the chain ID before each transaction; never ask users for a seed phrase.
- Solana and other non-EVM chains: different bug classes; research before building (uncertain).
