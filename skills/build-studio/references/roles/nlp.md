# NLP
tier: 2 | sources: Unicode UAX #29 text segmentation, Hugging Face Transformers docs, scikit-learn text docs | updated: 2026-11-26
## Triggers
- Text classification, NER, search, keyword extraction, spam or sentiment checks, language detection.
- Bangla, mixed Bangla and English, or other non-Latin text.
- Not for hosted LLM chat, summaries or RAG answers (ai-llm role). Use this role when rules or a small model are enough.
## Responsibilities
- Architecture: rules, classic ML, small model or hosted LLM; the cheaper method first.
- Build: text normalization, tokenization, model or index, result schema.
- Verify: scores on labeled real text, including Bangla.
## Role-specific rules
1. **Start with a baseline:** rules, or TF-IDF plus logistic regression. Move to a transformer only if the baseline misses the target on my labeled set.
2. **Label a few hundred real examples** as a test set before comparing methods. Keep it out of training.
3. **Normalize Unicode (NFC)** and handle Bangla digits, zero-width joiner and non-joiner, and mixed scripts. Do not strip them blindly.
4. **Never split Bangla by bytes or `split(' ')` alone.** Use a Unicode-aware tokenizer or the model's own.
5. **English stop-word lists and stemmers do not fit Bangla.** Test any Bangla resource on my data; maintenance status varies (uncertain).
6. **Use a multilingual model for mixed text** (XLM-R or a multilingual MiniLM style model). Confirm Bangla is listed on the model card.
7. **Search:** full-text search with the right analyzer first; add embeddings only when keyword search fails my real queries.
8. **Report per-class precision and recall,** not only accuracy, especially on imbalanced classes.
9. **Check model and dataset licenses;** remove personal data from training text. Real user text is gate G3 (SKILL.md 2).
## Default tool options
- Classic: scikit-learn, spaCy (rules, small pipelines), fastText for language ID.
- Small models: Hugging Face Transformers or sentence-transformers on CPU or ONNX.
- Search: Postgres full-text, SQLite FTS5, self-hosted Meilisearch or Typesense.
- Free GPU for fine-tuning: Colab or Kaggle. Creating the account is G3.
## Checklist
- [ ] Baseline and its score recorded
- [ ] Labeled test set including Bangla examples
- [ ] Per-class precision and recall reported
- [ ] Unicode normalization tested on mixed-script input
- [ ] Latency and memory measured on the target host
## Common mistakes
- Jumping to a large model → measure the baseline first.
- Testing only English → add Bangla and mixed samples.
- Removing "noise" characters that carry Bangla meaning.
## Definition of done
A labeled test set exists, the chosen method beats the baseline on it, Bangla cases pass, and latency and memory fit the free host.
## Per-stack notes
- Python: pin `transformers` and `torch`; cache downloaded models in a volume.
- Postgres: set the text search config per language; no Bangla config ships by default (uncertain).
