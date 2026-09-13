" Gruvbox Dark Hard colors for Thrust syntax groups.
" Load with :colorscheme thrust-gruvbox-dark-hard

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "thrust-gruvbox-dark-hard"

function! s:hi(group, fg, ...) abort
  let l:bg = get(a:, 1, 'NONE')
  let l:gui = get(a:, 2, 'NONE')
  execute 'highlight ' . a:group .
        \ ' guifg=' . a:fg .
        \ ' guibg=' . l:bg .
        \ ' gui=' . l:gui .
        \ ' ctermfg=NONE ctermbg=NONE cterm=NONE'
endfunction

call s:hi('Normal', '#ebdbb2', '#1d2021')
call s:hi('Comment', '#928374', 'NONE', 'italic')
call s:hi('Todo', '#fabd2f', 'NONE', 'bold')
call s:hi('String', '#b8bb26')
call s:hi('Character', '#b8bb26')
call s:hi('SpecialChar', '#fe8019')
call s:hi('Number', '#d3869b')
call s:hi('Float', '#d3869b')
call s:hi('Boolean', '#d3869b')
call s:hi('Constant', '#d3869b')
call s:hi('Keyword', '#fb4934')
call s:hi('Type', '#fabd2f')
call s:hi('StorageClass', '#fabd2f')
call s:hi('PreProc', '#8ec07c')
call s:hi('Function', '#83a598')
call s:hi('Operator', '#fe8019')
call s:hi('Delimiter', '#ebdbb2')
call s:hi('LineNr', '#665c54')
call s:hi('CursorLineNr', '#bdae93')
call s:hi('CursorLine', 'NONE', '#282828')
call s:hi('Visual', 'NONE', '#504945')

call s:hi('thrustBlockComment', '#928374', 'NONE', 'italic')
call s:hi('thrustLineComment', '#928374', 'NONE', 'italic')
call s:hi('thrustTodo', '#fabd2f', 'NONE', 'bold')
call s:hi('thrustEscape', '#fe8019')
call s:hi('thrustCNString', '#b8bb26')
call s:hi('thrustString', '#b8bb26')
call s:hi('thrustChar', '#b8bb26')
call s:hi('thrustFloat', '#d3869b')
call s:hi('thrustHex', '#d3869b')
call s:hi('thrustBinary', '#d3869b')
call s:hi('thrustOctal', '#d3869b')
call s:hi('thrustInt', '#d3869b')
call s:hi('thrustKeyword', '#fb4934')
call s:hi('thrustBoolean', '#d3869b')
call s:hi('thrustNull', '#d3869b')
call s:hi('thrustMemory', '#fb4934')
call s:hi('thrustBuiltin', '#8ec07c')
call s:hi('thrustType', '#fabd2f')
call s:hi('thrustTypeQual', '#fabd2f')
call s:hi('thrustAtomic', '#fabd2f')
call s:hi('thrustAttribute', '#8ec07c')
call s:hi('thrustOperator', '#fe8019')
call s:hi('thrustFuncDef', '#83a598')
call s:hi('thrustFuncCall', '#83a598')
call s:hi('thrustStructName', '#fabd2f')
call s:hi('thrustPunct', '#ebdbb2')
