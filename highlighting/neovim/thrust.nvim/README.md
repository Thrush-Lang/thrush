# thrust.nvim

Syntax highlighting for the [Thrust Programming Language](https://github.com/thrustlang/) language in Neovim/Vim.

## What gets highlighted

| Element | Examples |
|---|---|
| Keywords | `fn`, `var`, `if`, `elif`, `else`, `for`, `while`, `return`, `struct`, ... |
| Types | `s8`-`s64`, `u8`-`u128`, `f32`-`f128`, `ptr`, `array`, `bool`, `void`, `CString`, `CNString`, ... |
| Attributes | `@public`, `@entrypoint`, `@extern`, `@convention`, `@cuda`, `@inline`, `@if`, ... |
| Atomics | `volatile`, `atomicSync`, `threadInit`, `threadDyn`, ... |
| Builtins | `sizeOf`, `alignOf`, `memcpy`, `targetCPU`, `hostArch`, `currentTimestamp`, ... |
| Memory ops | `deref`, `ref`, `mut`, `alloc`, `addr` |
| Literals | strings, non-null strings (`n#"..."`), chars, integers, hex (`0x...`), binary (`0b...`), octal (`0o...`), floats |
| Comments | `// line` and `/* block */` |

## Themes

The syntax links to standard highlight groups by default, so it follows your current colorscheme.

This plugin also includes a Thrust-tuned Gruvbox Dark Hard theme:

```vim
colorscheme thrust-gruvbox-dark-hard
```

## Installation

### lazy.nvim

```lua
{
  "yourusername/thrust.nvim",
  ft = "thrust",
}
```

### Manual (no plugin manager)

Copy the plugin folders into your Neovim config:

```bash
cp -r ftdetect  ~/.config/nvim/
cp -r syntax    ~/.config/nvim/
cp -r ftplugin  ~/.config/nvim/
cp -r colors    ~/.config/nvim/
```

That's it — open any `.thrust` file and highlighting is active.

## File structure

```
thrust.nvim/
  ftdetect/thrust.vim   associates *.thrust with this syntax
  syntax/thrust.vim     all highlight rules
  ftplugin/thrust.vim   indent settings, comment format
  colors/               optional Thrust colorschemes
```
