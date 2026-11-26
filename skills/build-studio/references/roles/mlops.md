# MLOps
tier: 2 | sources: Google MLOps maturity levels, MLflow docs, Google "Rules of Machine Learning" | updated: 2026-11-26

## Triggers
- A model must be retrained, versioned, promoted, served to real users or watched for drift over time.
- Several models or recurring training runs. Single-model work (data, training, evaluation) belongs to the ml role; read its headings first.

## Responsibilities
- Architecture: pipeline stages, registry, serving shape (batch or online), monitoring plan, retraining trigger.
- Build and deploy: reproducible training job, promotion step, rollback to the last good model. Handoff: model card and runbook.

## Role-specific rules
1. Reproducible runs: pin data version, code commit, seed and dependency lockfile, and record all four with the run.
2. Register each model with metrics, data version and a stage (candidate, staging, production). Promote only through a gate that compares to the current model.
3. Keep the training and serving feature code the same, from one module, to avoid train/serve skew.
4. Monitor inputs (drift), outputs (score distribution) and, when labels arrive, real quality. Alert on thresholds you wrote down.
5. Retrain on a schedule or a drift trigger, never on every new row. A retrain that fails the gate leaves production unchanged.
6. Keep the previous model deployable so rollback is one step; test the rollback once.
7. Real user data in training or logs is G3 (SKILL.md 2). Strip personal fields before logging predictions.
8. Drift tests: PSI or KS for numeric, chi-square for categorical; thresholds are tuned per case (uncertain).

## Default tool options
- Tracking and registry: MLflow (local, free); Weights & Biases free tier; Hugging Face Hub for models and datasets.
- Pipelines: GitHub Actions or cron for small jobs; Prefect or Dagster (open source) when steps need retries and lineage.
- Monitoring: Evidently (open source); Grafana with Prometheus for serving metrics.

## Checklist
- [ ] A run can be replayed from its record and gives metrics within the expected noise
- [ ] A promotion gate, a rollback step and a drift report each exist and were run once

## Common mistakes
- Promoting on a better headline metric only → also check per-slice metrics and latency.
- Evaluating on data seen in training → fix the split by time or by group before any tuning.

## Definition of done
One full cycle ran end to end (train, gate, promote, serve, monitor, rollback) with logs saved, plus a model card and runbook.

## Per-stack notes
- MLflow: log params, metrics and the model with a signature; use aliases for stages; self-hosted needs a database and artifact store.
- Serving: FastAPI for small models; ONNX Runtime for CPU speed; GPU use on rented hardware is G3.
