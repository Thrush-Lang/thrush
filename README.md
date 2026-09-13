<img src= "https://github.com/thrustlang/.github/blob/main/assets/logos/new%20logo/thrustlang-logo-banner-text-italic.png" alt= "logo" style= "width: 80%; height: 80%;"></img>

# Thrust Compiler 

<img src= "https://github.com/thrustlang/.github/blob/main/assets/standard-text-separator.png" alt= "standard-separator" style= "width: 1hv;"> </img>

**Thrust Compiler** is a compiler that transfers the source code of Thrust files directly to the specified destination. The process includes static type analysis, code generation, destination-specific optimizations, machine-specific code compilation, and finally, emitting or linking.

> [!IMPORTANT]  
> The compiler is in an early development phase. It still hasn't made the major releases. There are still edge cases to be handled, and the compiler is under constant testing and fuzzing.

## Getting Started

## Compiled

If you don't want to build the project from scratch, you can check if there are available versions in Github releases.

[Thrust Compiler - Github Releases](https://github.com/thrustlang/thrustc/releases)

Supported operating systems and architectures:

- Linux x64 (GNU)
- Windows x64 (MSVC) 
- MacOS aarch64 (Apple Silicon)
- MacOS x64 (Intel)

## From Scratch

### Build dependencies 

Among the dependencies required by the compiler is LLVM compiler infrastructure.

Automatically:

```console
$ git clone --depth=1 https://github.com/thrustlang/compiler-dependency-builder 
$ cd compiler-dependency-builder 
$ cargo build --release
$ ./target/release/compiler-dependency-builder
```

Another way:

```console
$ git clone --depth=1 https://github.com/thrustlang/compiler-dependency-builder 
$ cd compiler-dependency-builder 
$ cargo run 
```

If you want to know a high-level command line view, you should check out: [Compiler Dependency Builder - Commands & Flags](https://github.com/thrustlang/compiler-dependency-builder/blob/master/README.md)

You must first clone the repository and access it locally. 

```console
$ git clone --depth=1 https://github.com/thrustlang/thrustc 
$ cd thrustc
```

### Build Cargo/rustc dependencies 

Among other mandatory dependencies, we also need additional libraries specifically for Cargo and rustc.

You must install each Cargo dependency automatically:

#### Bash

```console
sh scripts/cargo-dependencies.sh
```

#### Fish

```console
fish scripts/cargo-dependencies.fish
```

#### CMD

```console
scripts\cargo-dependencies.bat
```

#### PowerShell

```console
.\scripts\cargo-dependencies.ps1
```

### Build the Compiler

Now you need to have Rust installed with a recent version.

- \>= [Rust](https://www.rust-lang.org/) (v1.85.0)
- Rust 2024 Edition

Now you need to compile the compiler with Rust. 

```console
$ cargo build --release
$ ./target/release/thrustc --help
```

## Cross Compilation

Thrust Compiler offers powerful cross-compilation support, just like '[Clang](https://github.com/llvm/llvm-project/tree/main/clang)'.

### RISC-V 64-bit

```console
./thrustc main.thrust my_library.thrust \
  -target-triple riscv64-unknown-linux-gnu \
  -cpu sifive-u74 \
  -opt O3 
```

### WebAssembly

```console
./thrustc main.thrust my_library.thrust \
  -target-triple wasm32-unknown-unknown \
  -opt O3 
```

You can target macOS, Windows, Linux, and other platforms directly from your current system without needing to switch machines.

## Commands & Flags

If you want to know a high-level command line view, you should check out: [Thrust Compiler - Commands & Flags](https://github.com/thrustlang/thrustc/blob/master/CLI.md)

## Compiler Structure

If you want to know a little about the compiler's structure, you should check out: [Thrust Programming Language - Compiler Structure](https://github.com/thrustlang/thrustc/blob/master/PROJECT_STRUCTURE.md)

## Contributing

If you want to know how to contribute to the compiler, you should check out: [Thrust Programming Language - Contributing](https://github.com/thrustlang/thrustc/blob/master/CONTRIBUTING.md)

## Rust Code Documentation

If you want to know regarding Rust code's structure that resides in the compiler, you should check out: [Thrust Programming Language - Rust Code Documentation](https://thrustlang.github.io/thrustc/)

## Cargo Alias

If you require to know the command line shorcuts available in the project across rust-cargo, you should check out: [Thrust Programming Language - Cargo Alias](https://github.com/thrustlang/thrustc/blob/master/CARGO_ALIAS.md)

## Commit Conventions

If you want to know the commit conventions to follow in order to delivery a good Github commit, you should check out: [Thrust Programming Language - Commit Conventions](https://github.com/thrustlang/thrustc/blob/master/COMMIT_CONVENTIONS.md)

## Compiler Diagnostics

If you want to see examples of the type of compiler diagnostics you can find in thrustc, you should check out: [Thrust Programming Language - Compiler Diagnostics](https://github.com/thrustlang/thrustc/blob/master/COMPILER_DIAGNOSTICS.md)

## Compiler Fuzzing

If you want to know how to fuzz the compiler with stable and unstable features to find issues, you should check out: [Thrust Programming Language - Compiler Fuzzing](https://github.com/thrustlang/thrustc/blob/master/COMPILER_FUZZING.md)

## Compiler Releasing

If you want to know how a new compiler version is released, you should check out: [Thrust Programming Language - Compiler Releasing](https://github.com/thrustlang/thrustc/blob/master/COMPILER_RELEASING.md)

## Release Binary Variants

If you want to know the differences between the compiler binaries shipped in Github releases, you should check out: [Thrust Programming Language - Release Binary Variants](https://github.com/thrustlang/thrustc/blob/master/RELEASE_BINARY_VARIANTS.md)

## Code of Conduct

If you want to know the code of conduct expected from the project contributors, you should check out: [Thrust Programming Language - Code of Conduct](https://github.com/thrustlang/thrustc/blob/master/CODE_OF_CONDUCT.md)

## License

Thrust Compiler is distributed under the terms of the GNU General Public License (version 3). See LICENSE.txt file for details.

## Q&A

#### > Why isn't the compiler designed to use it as a bootstrap compiler?

Regarding the concept of bootstrapping in compilers (For more information: https://www.bootstrappable.org/).

The decision was made to fully implement all the programming language functions in the compiler written in Rust, because it proposes a development approach similar to what Gleam Team did for Gleam Programming Language, and also to lighten the workload, given that we are already using LLVM.
