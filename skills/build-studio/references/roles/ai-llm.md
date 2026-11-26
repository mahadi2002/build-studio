# AI / LLM
tier: 1 | sources: OWASP Top 10 for LLM Applications 2025, anthropics skills (claude-api, mcp-builder), trailofbits agentic-actions ideas | updated: 2026-11-26

## Triggers
- A feature that calls a language model: chat, summarization, extraction, classification, generation.
- RAG (answers from my documents), agents with tools, MCP servers, AI in CI.
- Prompt or model changes on an existing AI feature (evals must run).

## Responsibilities
- G2: model and provider choice, free-tier limits and data-use terms, cost per request and per month.
- Threat model: the AI section of `templates/threat-model.md`.
- Build: prompts as versioned files, structured outputs, retrieval, tools, caps.
- Verify: an eval set that runs on every prompt or model change.

## Role-specific rules
**Provider and cost**
1. Free tiers first: Groq or Hugging Face free tiers (spec); a paid API key (Claude, OpenAI) is G3. Check each provider's rate limits and whether free-tier data may be used for training; don't send personal data to a provider whose terms allow that.
2. **Caps everywhere:** max output tokens per request, requests and tokens per user per day, a global monthly budget with an alert. Unbounded loops or retries are a cost bug (LLM10).
3. Smallest model that passes the evals; cache identical requests; stream long answers; timeout every call and show a fallback message.

**Inputs and outputs**
4. **Prompt injection is expected (LLM01).** Anything the model reads (user text, web pages, files, emails, retrieved chunks) may contain instructions. Keep system instructions separate, mark untrusted content as data, and never rely on the prompt alone for security.
5. **Output is untrusted input (LLM05).** Validate structured output against a schema; escape it before rendering; never pass it to SQL, a shell, `eval` or a file path without validation.
6. **No secrets in prompts (LLM07):** assume the system prompt can leak. Keys and internal rules that matter for security live in code.
7. **Personal data (LLM02):** send the minimum; strip identifiers you don't need; log prompts only with personal data removed.

**RAG**
8. Chunk by document structure (headings, sections), store source, title and owner with each chunk.
9. **Tenant filter inside the vector query** (LLM08); never filter results after retrieval.
10. Answer from retrieved text with citations; when retrieval finds nothing relevant, say so instead of guessing.
11. Evaluate retrieval separately (does the right chunk appear in the top k?) before blaming the prompt.
12. Hybrid search (keyword + vector) when exact terms matter (codes, names, course IDs).

**Agents and tools**
13. **Least privilege (LLM06):** the fewest tools, each with narrow arguments validated in code. No generic shell, SQL or HTTP tool on untrusted input.
14. Side effects (send, pay, delete, post) need a human confirmation step.
15. Step and cost limit per run; log every tool call with arguments and result.

**Evals**
16. **Golden set before launch:** 20-50 cases from the PRD stories and likely-to-break inputs, each with an expected result or a rubric.
17. Checks per case: exact match or schema-valid for structured output; contains or excludes for key facts; an LLM judge with a written rubric for open text, spot-checked by hand.
18. Run the set on every prompt, model or retrieval change; record pass rate, cost and latency; a drop blocks the change.
19. Add every production failure to the set as a regression case.

## Default tool options
- Free providers: Groq (fast open models), Hugging Face Inference (free credits), local Ollama for development.
- Paid (G3): Claude API (`claude-api` route for current model IDs and SDK use).
- Vector store: pgvector on Supabase, Cloudflare Vectorize, Chroma locally.
- Frameworks: plain SDK calls first; LangChain or LlamaIndex only if they remove real work.
- Evals: a pytest or Vitest file over a JSONL golden set; promptfoo when comparing models.
- MCP server: `anthropic-skills:mcp-builder`.

## Checklist
- [ ] Provider terms and limits recorded at G2; paid keys approved at G3
- [ ] Token, request and budget caps implemented and tested
- [ ] Output schema validation with a tested failure path
- [ ] Injection test cases in the golden set (instructions inside user text and documents)
- [ ] Tenant filter test: user A never retrieves user B's chunks
- [ ] Side-effect tools require confirmation
- [ ] Eval run saved with pass rate, cost and latency

## Common mistakes
- "The system prompt tells it not to" as the only defense → enforce rules in code.
- Rendering model output as HTML → XSS from a prompt.
- No eval set → every prompt tweak is a guess, and regressions ship silently.
- Filtering retrieved chunks after the query → data leaks across users when the filter has a bug.
- Retry loops without a cap → a bill or a banned key.
- Free tier used for personal data without reading the data-use terms.

## Definition of done
The golden set passes at the agreed rate on the shipped prompt and model, caps and schema checks have passing tests, injection and tenant tests pass, the cost per request and per month is measured and inside the G2 estimate.

## Per-stack notes
**Python (FastAPI):** Pydantic models as the output schema; async client; background job for long calls.
**TypeScript:** zod schemas for output; Vercel AI SDK or the provider SDK; stream with server-sent events.
**Cloudflare Workers:** Workers AI and Vectorize free allowances (uncertain: check current quotas); keep calls within the CPU and wall-time limits, or move them to a queue consumer.
**Supabase:** pgvector with row-level security on the chunk table; an RPC function for the similarity query that includes the owner filter.
**GitHub Actions with an AI agent:** never feed issue or PR text to an agent with write tools; avoid `pull_request_target` with a checkout of the PR head; no wildcard user allowlists.
