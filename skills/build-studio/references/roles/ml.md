# ML
tier: 1 | sources: wshobson ml-pipeline-workflow (listing), scikit-learn and PyTorch docs (knowledge), model cards practice | updated: 2026-11-26
Public skill sources were weak; rules below 0.8 confidence are marked.

## Triggers
- Training, fine-tuning or serving a model: classification, regression, recommendation, forecasting, embeddings, a course or thesis ML project.
- Not for: calling a hosted LLM (ai-llm role). Pipelines, feature stores and retraining at scale are the Tier 2 mlops role.

## Responsibilities
- G1: is ML needed at all? A rule or heuristic baseline first.
- G2: data source and license, compute (free GPU options), serving host, cost.
- Build: data pipeline, training script, evaluation, model artifact, serving endpoint.
- Verify: held-out test results against the baseline, reproducibility, a model card.

## Role-specific rules
**Framing**
1. **Baseline first:** a rule, a heuristic or the simplest model (majority class, linear/logistic regression). The ML model must beat it by a margin that matters to the user.
2. **The metric matches the decision:** precision vs recall by the cost of each error; MAE vs RMSE by how bad big misses are; never accuracy alone on imbalanced data.

**Data**
3. **Split before anything else** (train / validation / test), and look at the test set only once at the end. Time-based split for time series; group split when rows from one person or item must not leak across sets.
4. **No leakage:** fit scalers, encoders and feature selection on training data only (use a pipeline); remove features that are only known after the outcome.
5. **Data license and privacy:** record the dataset source and license; no personal data without consent and a reason; strip identifiers.
6. **Look at the data:** class balance, missing values, duplicates, label noise, a sample of rows read by hand.

**Training and evaluation**
7. **Reproducible:** fixed seeds, pinned library versions, data version or hash, and the exact command, saved with each run.
8. **Track experiments:** parameters, metrics and artifacts per run (a CSV is fine for small projects; MLflow or W&B when runs multiply).
9. **Cross-validation** on small datasets; report mean and spread, not the best fold.
10. **Error analysis:** read the worst errors and the confusion matrix by subgroup before tuning more.
11. **Fairness check** when predictions affect people: compare error rates across relevant groups and write the result in the model card.

**Serving**
12. **Same preprocessing in training and serving:** ship the fitted pipeline with the model, not a re-written copy.
13. **Small and CPU-friendly first:** free hosts have little memory and no GPU; export to ONNX or quantize when needed; measure latency and memory.
14. **Validate inputs at the endpoint** (ranges, types), return a confidence or "unsure", and log inputs and predictions (without personal data) to watch for drift.
15. **Model card** with intended use, data, metrics, limits and when not to use it.
16. **Untrusted model files:** pickle and some checkpoint formats can run code when loaded; load only models I trained or from trusted sources, and prefer `safetensors`.

## Default tool options
- Classic ML: scikit-learn (pipelines, cross-validation), XGBoost or LightGBM for tabular data.
- Deep learning: PyTorch; Hugging Face Transformers for pretrained models.
- Free compute: Google Colab and Kaggle notebooks (GPU limits change; uncertain, check current quotas).
- Tracking: MLflow (local), Weights & Biases (free for personal use, uncertain on terms).
- Serving: FastAPI endpoint, Hugging Face Spaces (free CPU), ONNX Runtime.

## Checklist
- [ ] Baseline result recorded
- [ ] Splits made before exploration; test set used once
- [ ] Preprocessing inside a pipeline fitted on training data
- [ ] Seeds, versions, data hash and command saved with the final run
- [ ] Error analysis and, where relevant, subgroup fairness check done
- [ ] Model card written
- [ ] Serving endpoint validated with latency and memory measured on the target host

## Common mistakes
- Scaling or selecting features on the full dataset → leakage and inflated scores.
- Reporting validation scores tuned many times as final → use the untouched test set.
- Accuracy on a 95/5 dataset → a model that always says "no" looks great.
- Notebook-only code → move training to a script before the final run.
- Rewriting preprocessing in the API → training and serving disagree.
- Loading a downloaded pickle → arbitrary code execution.

## Definition of done
A saved run reproduces the final test metrics from the recorded command, the model beats the baseline by the agreed margin, the model card is complete, and the serving endpoint passes its tests within the host's memory and latency limits.

## Per-stack notes
**scikit-learn:** `Pipeline` + `ColumnTransformer`; `cross_validate` with the chosen metric; `joblib` artifacts only from my own training.
**PyTorch:** `torch.manual_seed` plus deterministic flags where needed; save `state_dict` (or `safetensors`), not the whole pickled model.
**Hugging Face:** pin model revision hashes; check model licenses (some forbid commercial use); `safetensors` weights.
**FastAPI serving:** load the model once at startup; Pydantic input ranges; a `/health` that checks the model loaded.
**Course and thesis work:** report methods and results honestly (no test-set tuning); `academic-work:academic-work` route for the write-up.
