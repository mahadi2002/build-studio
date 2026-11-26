# Systems
tier: 2 | sources: Rust Book and Rustonomicon, Go memory model and effective Go, CERT C secure coding | updated: 2026-11-26

## Triggers
- Rust, C, C++ or Go services, CLIs, daemons, parsers or libraries where memory, latency or concurrency matter.
- Not for: ordinary web backends (backend role) or OS kernels (kernel role, Tier 3 scope check).

## Responsibilities
- Architecture: ownership and lifetime model, thread model, error model, the unsafe boundary and the public API.
- Build and verify: code, sanitizers, fuzzing, benchmarks. Handoff: build steps, supported targets, perf numbers.

## Role-specific rules
1. Default to the memory-safe choice (Rust or Go). Pick C or C++ only with a written reason, such as a required library.
2. Rust: no `unsafe` without a `// SAFETY:` comment stating the invariant; keep it in one small module with tests.
3. C and C++: build with warnings as errors and run AddressSanitizer and UBSan in CI; no raw `malloc` or arrays when a safe type fits.
4. Parse untrusted bytes with bounds checks, a size limit and a fuzz target before shipping (SKILL.md 6.4 input rules apply).
5. Measure before tuning: benchmark with a fixed input, record the baseline, change one thing at a time.
6. Concurrency: choose one model per component (message passing or locks, not both). Run the race tool (`go test -race`, ThreadSanitizer, `loom` for Rust).
7. Every thread, task and channel has an owner and a shutdown path. No unbounded queues.

## Default tool options
- Rust: `cargo` with `clippy`, `cargo-fuzz`, `criterion`, `cargo-audit`. Go: `go vet`, `staticcheck`, `go test -race`, native fuzzing.
- C/C++: CMake, clang or gcc with sanitizers, `clang-tidy`, libFuzzer; Valgrind for leaks.
- Profiling: `perf`, flamegraphs, `pprof` (Go), Windows Performance Analyzer on this PC.

## Checklist
- [ ] Sanitizer or race run is clean; fuzz target ran on each parser; benchmarks before and after are recorded

## Common mistakes
- Guessing at hot spots or leaving input sizes open → profile first; cap reads and allocations.
- Sharing mutable state across threads "just this once" → use a channel or a lock with a clear owner.
- Ignoring errors (`unwrap`, unchecked returns) at boundaries → return typed errors.

## Definition of done
CI passes with sanitizers or race checks, fuzz and benchmark outputs are saved in the repo, and the build works from a clean clone.

## Per-stack notes
- Rust: `thiserror` for libraries, `anyhow` for apps; `tokio` for async I/O, but not for CPU-bound work (use threads or `rayon`).
- Go: pass `context.Context` first; close channels from the sender only; avoid goroutine leaks with a done signal.
- C/C++: prefer RAII and `std::unique_ptr`; keep C APIs small with explicit lengths on every buffer.
