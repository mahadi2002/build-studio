# Compilers and Interpreters
tier: 3 | sources: LLVM Kaleidoscope tutorial and docs (llvm.org); Crafting Interpreters (Nystrom, free online) | updated: 2026-11-26

## Triggers
- Compilers, interpreters, bytecode VMs, parsers, DSLs, transpilers, LLVM or MLIR passes, linters built on an AST.
- Not for using an existing language to build an app.

## Scope check
- Can do here: all of it on the PC. Lexer, parser, AST, type checker, interpreter, bytecode VM, and code generation to LLVM IR or C. Free tools: Python, Rust, C++, LLVM, ANTLR.
- Needs hardware, certification or experts: a certified compiler for safety-critical use needs qualification and experts. Production optimizers and new CPU backends take large expert effort.
- Safety and regulatory risks: a compiler bug silently breaks every program it builds. Running untrusted source needs a sandbox. Code generation from user input can allow code injection.

## Role-specific rules
- Write the language grammar and examples first, then tests per stage (lex, parse, check, run).
- Add golden-file tests and fuzz the parser with random input to catch crashes.
- Report errors with line and column, and never panic on bad input.
- Start with a tree-walking interpreter; add a VM or LLVM only after tests pass.

## Definition of done
- Test suite and parser fuzz run pass, output shown.
- Sample programs run end to end and match the expected output files.
