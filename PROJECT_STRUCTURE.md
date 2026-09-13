<img src="https://github.com/thrustlang/.github/blob/main/assets/logos/new%20logo/thrustlang-logo-banner-text-italic.png" alt="logo" style="width: 80%; height: 80%;">

# Thrust Compiler — Project Structure

<img src="https://github.com/thrustlang/.github/blob/main/assets/standard-text-separator.png" alt="standard-separator" style="width: 1hv;">

`thrustc` is a modular compiler for the **Thrust** Programming Language — a general-purpose, statically-typed systems programming language focused on writing verbose, accurate, and fast code.

The frontend uses a **handwritten recursive descent parser**. The backend performs code generation through the **LLVM C API** (via `llvm-sys` and `inkwell`) with custom abstractions and low-level tricks for access to LLVM C++ API indirectly.

---

## Workspace Crates (`thrustc_*`)

### Entry Point & CLI

- **`thrustc`**  
  Main binary entry point. Contains only `main.rs` — delegates everything to `thrustc_core`.

- **`thrustc_cli`**  
  Command-line interface helpers and argument parsing utilities (`help.rs`, `lib.rs`).

- **`thrustc_options`**  
  Compiler configuration and command-line options: backends, optimization levels, debug information, linkage, target settings (`lib.rs`, `linkage.rs`).

### Core Infrastructure

- **`thrustc_core`**  
  Central driver of the compiler. Manages the compilation pipeline with lifecycle stages: `starter`, `cleaner`, `finisher`, and `validate`. Contains emission (`emitters/` for AST, LLVM IR, tokens, assembler, bitcode, object files), printing (`printers/`), linkage, and interrupt handling.

- **`thrustc_diagnostician`**  
  Rich diagnostic and error reporting system with source positions and pretty-printed messages (`diagnostic.rs`, `position.rs`, `printers.rs`, `errors.rs`, `config.rs`).

- **`thrustc_errors`**  
  Internal error types and utilities.

- **`thrustc_logging`**  
  Structured logging for compiler internals.

- **`thrustc_utils`**  
  General shared utilities used across crates.

### Frontend — Lexing & Parsing

- **`thrustc_lexer`**  
  Handwritten lexer supporting identifiers, numbers, strings, characters, and language-specific rules (`lex.rs`, `identifier.rs`, `number.rs`, `string.rs`, `character.rs`).

- **`thrustc_reader`**  
  Source file reading and input management.

- **`thrustc_token`** & **`thrustc_token_type`**  
  Token definitions, supporting traits, and type hierarchies.

- **`thrustc_code_location`**  
  Source span and location tracking used throughout the compiler.

- **`thrustc_preprocessor`**  
  Preprocessor for modules, imports, and early processing of source code. Handles high-level module parsing (`highmodule_parsing/`), submodule parsing (`submodule_parsing/`), module tables, signatures, the standard library resolver (`std_library.rs`), and compile-time conditionals.

- **`thrustc_parser`**  
  **Handwritten recursive descent parser** with layered precedence climbing. Parses expressions (`expressions/` with 14 precedence levels), statements (`statements/`), top-level declarations (`toplevel/`), attributes (`@...`), modificators, and imports.

- **`thrustc_parser_context`**  
  Context state maintained by the parser during recursive descent.

- **`thrustc_parser_table`** & **`thrustc_parser_external_table`**  
  Symbol and declaration tables for fast lookups during parsing and external access.

### Frontend — AST

- **`thrustc_ast`**  
  Abstract Syntax Tree definitions, node types, visitor traits (`traits.rs`), metadata (`ast_metadata.rs`), builtins (`ast_builtins.rs`), logic data (`ast_logic_data.rs`), and implementations (`impls/`).

- **`thrustc_ast_external`**  
  Thin re-export layer that exposes selected AST types to other crates without circular dependencies.

- **`thrustc_ast_verifier`**  
  Structural and consistency verification of the AST.

- **`thrustc_ast_modificators`**  
  Handling of language modifiers (visibility, mutability, etc.) with traits and implementations.

### Builtins

- **`thrustc_builtins`**  
  Compile-time builtin system used by the parser and preprocessor. Provides a registry (`registry.rs`) with builtins for `sizeof`, `alignof`, `layout`, `target`, `predicates`, and `location`, plus compile-time conditionals (`builtins/compile_time.rs`), value/argument plumbing (`value.rs`), type info (`builtin_type.rs`), and traits (`traits.rs`).

### Semantic Analysis & Middle-end

- **`thrustc_scoper`**  
  Scope analysis and resolution with context, table, and checks.

- **`thrustc_typesystem`**  
  Complete type system: arrays, fixed arrays, pointers, structures, function references, casting, inference, layout, modifiers, precedence, location, indexation, and dereference.

- **`thrustc_typechecker`**  
  Main type checker with type inference for expressions (`expressions/`), operations (`operations/`), top-level declarations (`toplevel/`), metadata, and support utilities.

- **`thrustc_generics`**  
  Generic type resolution and substitution: parameter solving (`solve.rs`), type and AST substitution (`substitution.rs`), generic scope (`scope.rs`), pending instantiations (`pending.rs`).

- **`thrustc_general_analyzer`**  
  General static analysis with context and expression visitors.

- **`thrustc_linter`**  
  Static linter for style and best-practice warnings (expressions, table).

- **`thrustc_entities`**  
  Shared entities consumed by the analyzer, parser, typechecker, and linter (`analyzer_entities.rs`, `parser_entities.rs`, `typechecker_entities.rs`, `linter_entities.rs`).

- **`thrustc_semantic_analysis`**  
  General semantic analysis layer.

- **`thrustc_attributes`** & **`thrustc_attribute_checker`**  
  Handling and validation of language and LLVM attributes (assembler, call conventions, linkage).

- **`thrustc_constants`**  
  Language-level constant definitions.

- **`thrustc_directive`**  
  Compiler directive handling.

- **`thrustc_mir`**  
  Mid-level Intermediate Representation (atomic operations, thread mode).

### LLVM Backend

- **`thrustc_llvm_codegen`**  
  **Primary code generation backend**. Uses the LLVM C API directly with custom wrappers. Supports expressions (`expressions/` with binary operations, calls, structs, arrays, inline asm, literals), statements (`statements/` with conditionals and loops), top-level codegen (`toplevel/` with functions, intrinsics, asm functions), memory management (heap, stack, static), JIT, optimization, debug info, atomic operations, type generation, type casting, and attribute building.

- **`thrustc_llvm_codegen_variatic`**  
  Variadic function code generation used by `thrustc_llvm_codegen`. Handles variadic lowering, `va_list` kinds (`va_list_kind.rs`), context propagation (`context.rs`), and abort handling (`abort.rs`).

- **`thrustc_llvm_target_triple`**  
  Intelligent wrapper around LLVM target triples with architecture queries (`supports_f80`, `supports_ppc128`, `is_64_bit`, etc.).

- **`thrustc_llvm_attributes`**  
  Mapping and emission of LLVM-specific attributes.

- **`thrustc_llvm_call_conventions`** & **`thrustc_llvm_call_conventions_checker`**  
  Support and validation of calling conventions.

- **`thrustc_llvm_compiler_intrinsic_checker`**  
  Validation of LLVM intrinsic usage.

- **`thrustc_llvm_abi`**  
  Core ABI handling abstractions.

- **`thrustc_llvm_system_v_abi`**  
  System V ABI implementation (x86-64 Linux/macOS).

- **`thrustc_llvm_nvidia_cuda_abi`**  
  NVIDIA CUDA ABI implementation.

- **`thrustc_llvm_webassembly_abi`**
  WebAssembly Basic C ABI implementation for arguments and return values.

- **`thrustc_llvm_abi_representation`**  
  ABI data representation utilities.

- **`thrustc_llvm_linker_driver`**  
  Linker driver integration with platform-specific linkers (`linux_finders.rs`).

### Backend Abstraction

- **`thrustc_backends`**  
  Backend abstraction layer (currently focused on LLVM). Includes CPU, debug, info, JIT, linker, passes, and target modules.

### Support

- **`thrustc_abi`**  
  ABI type representation and utilities.

- **`thrustc_heap_allocator`**  
  Custom heap allocation logic used by the compiler itself.

### Standard Library

- **`thrustc_std`**  
  Standard library crate. Embeds the `std/` directory (Thrust source files and version metadata) via `include_dir!`, and manages installation into the user's home directory (`~/.thrustlang/std` on Unix, `%APPDATA%\.thrustlang\std` on Windows). Performs version-aware resolution (`resolve_target_version`, `ensure_std_present`, `validate_version`) and dumps the requested version's sources if missing.

- **`std/`**  
  Versioned standard library sources. `VERSION.txt` lists the available versions, and each `v*/` directory contains modules such as `io.thrust`, `math.thrust`, `mem.thrust`, `collections/vector.thrust`, and C FFI helpers. Consumed by `thrustc_std` and the preprocessor's standard library resolver.

---

## LLVM Vendor Crates (`crates/llvm/`)

Vendored forks of LLVM Rust bindings, patched for thrustc compatibility:

- **`crates/llvm/17/llvm-sys`** — Raw FFI bindings to the LLVM C API (LLVM 17).
- **`crates/llvm/17/clang-sys`** — Raw FFI bindings to the Clang C API.
- **`crates/llvm/inkwell`** — Safe Rust wrappers over `llvm-sys` with additional context and builder abstractions.
- **`crates/llvm/clang`** — Safe Rust wrappers over `clang-sys`.

`clang-sys` and `llvm-sys` are patched via `[patch.crates-io]` in the workspace `Cargo.toml`; `inkwell` and `clang` are referenced as workspace path dependencies.

---

## Fuzzing (`fuzz/`)

A comprehensive fuzzing infrastructure using `cargo-fuzz`:

- **`fuzz_targets/`** — Fuzz targets for the lexer, LLVM codegen (local and top-level), and the full pipeline.
- **`src/`** — Shared fuzzing helpers: corpus generation (`gen_local_common.rs`), AST/IR dumps (`dumps.rs`), backlog tracking (`backlog.rs`), and target-specific harnesses (lexer, LLVM codegen local/loops/top-level).
- **`fuzz_pipeline/`** — 1984+ valid AST corpus files used for pipeline regression fuzzing.
- **`fuzz_continuous/`** — Continuous fuzzing setup (see `COMPILER_CONTINUOUS_FUZZING.md`).
- **`corpus_stable/`**, **`corpus_universal/`**, **`corpus_unstable/`** — Categorized fuzzing corpora.
- **`fuzz_reproduce_logs/`** — Logs from reproduced fuzzing failures.
- **`ast_dumps/`** — AST dumps generated during fuzzing.
- **`llvm_ir_dumps/`** — LLVM IR dumps captured from crashing inputs.
- **`artifacts/`** — Crashes found by each fuzz target.
- **`backlog/`** — Pending fuzzing issues per target.
- **`scripts/`** — Fuzzing directory setup scripts (`.sh`, `.bat`, `.ps1`, `.fish`).
- Dictionary files (`thrust-stable.dict`, `thrust-unstable.dict`) for coverage-guided fuzzing.

---

## Editor Support & Highlighting (`highlighting/`)

- **Sublime Text** — `thrust.tmLanguage`, `llvm.sublime-syntax` for Thrust and LLVM IR syntax.
- **VS Code** — `thrust-vscode/` extension and packaged `.vsix` for Thrust language support.
- **Neovim / Vim** — `thrust.vim` syntax file and `thrust.nvim/` plugin package.
- **Theme** — `One Dark.tmTheme` compatible theme.

---

## CI/CD (`.github/workflows/`)

GitHub Actions workflows for four target platforms:

| Platform | Dev | Release |
|---|---|---|
| `x86_64-linux-ubuntu` | Yes | Yes |
| `x86_64-macos` | Yes | Yes |
| `aarch64-macos` | Yes | Yes |
| `x86_64-windows-msvc` | Yes | Yes |

Builds and publishes release binaries for each platform.

---

## Scripts (`scripts/`)

Cross-platform automation scripts (available as `.sh`, `.bat`, `.ps1`, `.fish`):

- **`cargo-dependencies.*`** — Install project cargo tools (`sccache`, `panic-analyzer`, `git-cliff`).
- **`deploy-code-docs.*`** — Deploy compiler documentation.
- **`deploy-version.*`** — Version deployment automation.
- **`embed-std.*`** — Embed standard library sources.
- **`license_updater.py`** — Automated license header updates across source files.
- **`release-changelog.*`** — Generate and deploy changelogs for releases.
- **`tag-manager.*`** — Git tag management helpers.

---

## Changelogs (`changelogs/`)

Per-platform changelogs for release versions:

- `thrustc-x86_64-linux-ubuntu-v*`
- `thrustc-x86_64-macos-v*`
- `thrustc-aarch64-macos-v*`
- `thrustc-x86_64-windows-msvc-v*`

---

## Assets & Examples (`assets/`)

- **`assets/examples/diagnostics/`** — Example diagnostic output files.

---

## Resources (`resources/`)

- **`resources/linkers.md`** — Linker documentation.
- **`resources/llvm.md`** — LLVM integration documentation.

---

## Showcase (`showcase/`)

Example Thrust projects demonstrating language capabilities:

- **`showcase/Algorithms/`** — Algorithm implementations.
- **`showcase/Cuda/`** — CUDA integration examples.
- **`showcase/HttpServer/`** — HTTP server implementation.
- **`showcase/OpenGL/`** — OpenGL graphics examples.

---

## Compiler Pipeline

```
Source File (.thrust)
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 1. Reader          (thrustc_reader)             │
│    - Reads source files into memory             │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 2. Lexer           (thrustc_lexer)              │
│    - Tokenizes source into tokens               │
│    - Handles identifiers, numbers, strings,     │
│      characters, and language-specific tokens   │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 3. Preprocessor   (thrustc_preprocessor)        │
│    - Module resolution and import handling      │
│    - Standard library resolution (thrustc_std)  │
│    - Compile-time conditionals                  │
│      (thrustc_builtins)                         │
│    - High-level and submodule parsing           │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 4. Parser          (thrustc_parser)             │
│    - Handwritten recursive descent parser       │
│    - Precedence climbing for expressions        │
│    - Builds AST nodes (thrustc_ast)             │
│    - Uses parser context, tables, & AST         │
│    - Token definitions (thrustc_token,          │
│      thrustc_token_type)                        │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 5. AST Verification (thrustc_ast_verifier)      │
│    - Structural and consistency checks          │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 6. Semantic Analysis                            │
│                                                 │
│    a. Scoper        (thrustc_scoper)            │
│       - Scope resolution and binding            │
│                                                 │
│    b. Type Checker  (thrustc_typechecker)       │
│       + Type System (thrustc_typesystem)        │
│       - Type inference, checking, & layout      │
│                                                 │
│    c. Analyzer      (thrustc_general_analyzer)  │
│       - General static analysis                 │
│                                                 │
│    d. Linter        (thrustc_linter)            │
│       - Warnings                                │
│                                                 │
│    e. Attributes    (thrustc_attributes,        │
│       thrustc_attribute_checker)                │
│       - Language & LLVM attribute validation    │
│                                                 │
│    f. Semantic      (thrustc_semantic_analysis) │
│       - General semantic analysis               │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 7. MIR (optional)  (thrustc_mir)                │
│    - Mid-level Intermediate Representation      │
│    - Atomic operations & thread mode            │
│    - May be bypassed (direct to LLVM)           │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 8. LLVM Codegen    (thrustc_llvm_codegen)       │
│    + LLVM vendor crates (llvm-sys, inkwell)     │
│    + Variadic codegen                           │
│      (thrustc_llvm_codegen_variatic)            │
│    - Expression, statement, toplevel codegen    │
│    - Heap/stack/static memory management        │
│    - JIT compilation & optimization             │
│    - Debug info & metadata                      │
│                                                 │
│    ABI handling:                                │
│    - thrustc_llvm_abi                           │
│    - thrustc_llvm_system_v_abi                  │
│    - thrustc_llvm_nvidia_cuda_abi               │
│    - thrustc_llvm_webassembly_abi                │
│    - thrustc_llvm_abi_representation            │
│                                                 │
│    Target & conventions:                        │
│    - thrustc_llvm_target_triple                 │
│    - thrustc_llvm_attributes                    │
│    - thrustc_llvm_call_conventions              │
│    - thrustc_llvm_call_conventions_checker      │
│    - thrustc_llvm_compiler_intrinsic_checker    │
│                                                 │
│    Linker driver:                               │
│    - thrustc_llvm_linker_driver                 │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ 9. Emission & Output                            │
│    (thrustc_core → emitters/ & printers/)       │
│                                                 │
│    Output formats:                              │
│    • Object file (.o)     — emitters/objfile.rs │
│    • LLVM IR (.ll)        — emitters/llvmir.rs  │
│    • LLVM Bitcode (.bc)   — emitters/llvmbit..  │
│    • Assembly (.s)        — emitters/assembler  │
│    • AST dump             — emitters/ast.rs     │
│    • Token dump           — emitters/tokens.rs  │
│    • JIT execution        — codegen JIT module  │
└─────────────────────────────────────────────────┘
    │
    ▼
  Binary / Library / Executable
```

---

## Supported Compiler Host Platforms

| Target | Support | Status |
|---|---|---|
| `x86_64-unknown-linux-gnu` (Ubuntu) | Yes | Full support, CI tested |
| `x86_64-apple-darwin` (macOS) | Yes | Full support, CI tested |
| `aarch64-apple-darwin` (Apple Silicon) | Yes | Full support, CI tested |
| `x86_64-pc-windows-msvc` (Windows) | Yes | Full support, CI tested |

---
