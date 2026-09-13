" Syntax highlighting for Thrust
" Language: Thrust
" Maintainer: Stevens Benavides

if exists("b:current_syntax")
  finish
endif

syntax region thrustBlockComment start="/\*" end="\*/" contains=thrustTodo
syntax match  thrustLineComment  "//.*$" contains=thrustTodo
syntax keyword thrustTodo TODO FIXME HACK NOTE XXX contained

syntax match  thrustEscape "\\[ntr0\\\"']" contained
syntax region thrustCNString start='n#"' skip='\\"' end='"' contains=thrustEscape
syntax region thrustString   start='"'   skip='\\"' end='"' contains=thrustEscape
syntax match  thrustChar     "'\([^'\\]\|\\[ntr0\\\"']\)'"

syntax match thrustFloat  "\<[0-9][0-9_]*\.[0-9][0-9_]*\>"
syntax match thrustHex    "\<0x[0-9a-fA-F][0-9a-fA-F_]*\>"
syntax match thrustBinary "\<0b[01][01_]*\>"
syntax match thrustOctal  "\<0o[0-7][0-7_]*\>"
syntax match thrustInt    "\<[0-9][0-9_]*\>"

syntax keyword thrustKeyword
    \ var fn if elif else for while loop
    \ return break continue breakall continueall
    \ defer pass as const struct type enum
    \ alloc address addr load write
    \ ref mut static unreachable intrinsic
    \ embedded import importC only new directive
    \ asm asmfn global_asm fixed

syntax keyword thrustBoolean true false
syntax keyword thrustNull    nullptr
syntax keyword thrustMemory  deref

syntax keyword thrustBuiltin
    \ halloc memset memmove memcpy
    \ abiSizeOf bitSizeOf abiAlignOf
    \ arbitraryArg arbitraryArgs
    \ alignOf sizeOf staticAssert compileError compileWarning
    \ file fileLine currentFuncName
    \ isSigned isUnsigned isInteger isFloat isBool isChar
    \ isPointer isArray isFixedArray isStruct isVoid isConst
    \ isNumeric isFunction typeWidth fieldCount fixedArraySize
    \ isSameType isPtrLike isFixedArrayOfSize
    \ compilerVersion debugBuild stringLength
    \ targetOS targetArch targetVendor targetAbi targetTriple
    \ isLinux isWindows isDarwin isApple isAix
    \ is64Bit is32Bit isBigEndian isLittleEndian
    \ isX86 isX8664 isArm isAarch64 isRiscv64
    \ isPpc isPpc64 isMips64 isSystemz isLoongarch64
    \ isWasm isElf isMachO isCoff hasPosixThreads hasSysvAbi
    \ pointerWidth isizeWidth usizeWidth pointerAlign maxAlignment
    \ targetCPU targetCpuFeatures hasFeature
    \ hostOsName hostArch hostEndian currentTimestamp

syntax keyword thrustType
    \ s8 s16 s32 s64 ssize
    \ u8 u16 u32 u64 u128 usize
    \ f32 f64 f128 f80 fppc_128
    \ bool char ptr array void Fn CString CNString

syntax keyword thrustTypeQual const

syntax keyword thrustAtomic
    \ volatile lazyThread
    \ atomicNone atomicFree atomicRelax atomicGrab
    \ atomicDrop atomicSync atomicStrict
    \ threadInit threadDyn threadExec threadLDyn

syntax match thrustAttribute
    \ "@\(align\|optFuzzing\|noUnwind\|noReturn\|packed\|heap\|public\|entrypoint\|linkage\|extern\|arbitraryArgs\|hot\|minSize\|alwaysInline\|noInline\|inline\|safeStack\|weakStack\|strongStack\|preciseFloatingPoint\|convention\|pure\|thunk\|cuda\|constructor\|destructor\|if\|elif\|else\|promote\|asmAlignStack\|asmSyntax\|asmThrowErrors\|asmSideEffects\)\>"

syntax match thrustOperator "\.\.\.\|\.\."
syntax match thrustOperator "->\|=>"
syntax match thrustOperator "+=\|-=\|*=\|/=\|%=\|<<=\|>>=\|&=\||=\|^="
syntax match thrustOperator "&&\|||"
syntax match thrustOperator "==\|!=\|<=\|>=\|<\|>"
syntax match thrustOperator "++\|--"
syntax match thrustOperator "[-+*/=<>!&|^%~]"

syntax match thrustFuncDef    "\<\(fn\|asmfn\)\s\+\zs\w\+"
syntax match thrustFuncCall   "\<\w\+\ze\s*("
syntax match thrustStructName "\<\(struct\|enum\|type\)\s\+\zs\w\+"
syntax match thrustPunct      "[(){}\[\].,;:]"

highlight default link thrustBlockComment Comment
highlight default link thrustLineComment  Comment
highlight default link thrustTodo         Todo
highlight default link thrustEscape       SpecialChar
highlight default link thrustCNString     String
highlight default link thrustString       String
highlight default link thrustChar         Character
highlight default link thrustFloat        Float
highlight default link thrustHex          Number
highlight default link thrustBinary       Number
highlight default link thrustOctal        Number
highlight default link thrustInt          Number
highlight default link thrustKeyword      Keyword
highlight default link thrustBoolean      Boolean
highlight default link thrustNull         Constant
highlight default link thrustMemory       Keyword
highlight default link thrustBuiltin      Function
highlight default link thrustType         Type
highlight default link thrustTypeQual     Type
highlight default link thrustAtomic       StorageClass
highlight default link thrustAttribute    PreProc
highlight default link thrustOperator     Operator
highlight default link thrustFuncDef      Function
highlight default link thrustFuncCall     Function
highlight default link thrustStructName   Type
highlight default link thrustPunct        Delimiter

let b:current_syntax = "thrust"
