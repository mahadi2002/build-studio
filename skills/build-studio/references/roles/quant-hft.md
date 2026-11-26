# Quant and High-Frequency Trading
tier: 3 | sources: SEC Rule 15c3-5 market access overview (sec.gov); IOSCO principles on algorithmic trading | updated: 2026-11-26

## Triggers
- Quantitative trading, trading bots, HFT, strategy backtests, order books, market-data pipelines, signal research.
- Not for payment checkout or accounting software.

## Scope check
- Can do here: backtesting on historical data, paper trading, order-book simulators, latency-aware code in C++ or Rust on the PC, risk and performance metrics, a research dashboard.
- Needs hardware, certification or experts: true HFT needs colocation, direct market feeds and special hardware (costly, gate G3). Live trading needs a licensed broker, regulatory registration and a finance and legal expert.
- Safety and regulatory risks: real trading can lose all money. Spoofing and wash trading are illegal. Rules in Bangladesh and each market apply (uncertain). Backtests mislead through overfitting and look-ahead bias.

## Role-specific rules
- This skill never places real trades or moves money, and gives no investment advice. Code runs on backtest or paper mode only.
- Build in no live-trading switch; if I want one, I wire it myself outside this skill.
- Split data into train and test, include fees and slippage, and watch for look-ahead bias.
- Label every result "simulated, not advice, past results do not predict future results".

## Definition of done
- Backtest report with out-of-sample results, costs included, and the disclaimer text.
- Code review confirms no live order path exists.
