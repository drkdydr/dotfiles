set background=dark
highlight clear
if exists("syntax on")
 syntax reset
endif
let g:colors_name="spacemanspiff"


if !exists("g:spacemanspiff_skip_terminal_ansi_colors")
 let g:terminal_ansi_colors = [
 \ '#535456',
 \ '#ff887f',
 \ '#9ed88a',
 \ '#fce9a9',
 \ '#a0cbff',
 \ '#ae96ff',
 \ '#a0cbff',
 \ '#c5c8c6',
 \ '#535456',
 \ '#da4e4a',
 \ '#9dcf8d',
 \ '#ffa566',
 \ '#a0cbff',
 \ '#d08ec2',
 \ '#85def4',
 \ '#c5c8c6'
 \ ]

endif

highlight Normal guifg=#c5c8c6 guibg=#212121 ctermfg=7 ctermbg=NONE
highlight ColorColumn guifg=NONE guibg=#282a2e gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
highlight Comment guifg=#969896 guibg=NONE ctermfg=245 ctermbg=NONE
highlight Conditional guifg=#85def4 guibg=NONE ctermfg=12 ctermbg=NONE
highlight Constant guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight CursorColumn guifg=NONE guibg=#282a2e gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
highlight CursorLine guifg=NONE guibg=#282a2e gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
highlight Define guifg=#ae96ff guibg=NONE gui=NONE ctermfg=5 ctermbg=NONE cterm=NONE
highlight DiffAdd guifg=#212121 guibg=#9ed88a ctermfg=16 ctermbg=2
highlight DiffChange guifg=#212121 guibg=#9ed88a ctermfg=16 ctermbg=2
highlight DiffDelete guifg=#212121 guibg=#ff887f ctermfg=16 ctermbg=1
highlight DiffText guifg=#212121 guibg=#fce9a9 ctermfg=16 ctermbg=3
highlight Directory guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE
highlight FoldColumn guifg=NONE guibg=#212121 ctermfg=NONE ctermbg=16
highlight Folded guifg=#969896 guibg=#212121 ctermfg=245 ctermbg=16
highlight Function guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
highlight Identifier guifg=#ff887f guibg=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
highlight Keyword guifg=#a0cbff guibg=NONE ctermfg=6 ctermbg=NONE
highlight LineNr guifg=#373b41 guibg=NONE ctermfg=238 ctermbg=NONE
highlight MatchParen guifg=NONE guibg=#373b41 ctermfg=NONE ctermbg=238
highlight ModeMsg guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight MoreMsg guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight NonText guifg=#373b41 guibg=NONE ctermfg=238 ctermbg=NONE
highlight Operator guifg=#a0cbff guibg=NONE gui=NONE ctermfg=6 ctermbg=NONE cterm=NONE
highlight PMenu guifg=#c5c8c6 guibg=#373b41 gui=NONE ctermfg=7 ctermbg=238 cterm=NONE
highlight PMenuSel guifg=#c5c8c6 guibg=#373b41 gui=reverse ctermfg=7 ctermbg=black cterm=reverse
highlight PreProc guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight Question guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight Repeat guifg=#c5c8c6 guibg=NONE ctermfg=7 ctermbg=NONE
highlight Search guifg=#212121 guibg=#fce9a9 ctermfg=16 ctermbg=3
highlight SignColumn guibg=NONE ctermbg=NONE
highlight Special guifg=#c5c8c6 guibg=NONE ctermfg=7 ctermbg=NONE
highlight SpecialKey guifg=#373b41 guibg=NONE ctermfg=238 ctermbg=NONE
highlight SpellCap ctermfg=NONE ctermbg=NONE cterm=underline
highlight SpellLocal guifg=#212121 guibg=#a0cbff gui=NONE ctermfg=16 ctermbg=6 cterm=NONE
highlight Statement guifg=#a0cbff guibg=NONE ctermfg=6 ctermbg=NONE
highlight StatusLine guifg=#c5c8c6 guibg=#535456 gui=NONE ctermfg=7 ctermbg=240 cterm=NONE
highlight StatusLineNC guifg=#212121 guibg=#535456 gui=NONE ctermfg=16 ctermbg=240 cterm=NONE
highlight StatusLineTerm guifg=#212121 guibg=#9ed88a gui=NONE ctermfg=16 ctermbg=2 cterm=NONE
highlight StatusLineTermNC guifg=#212121 guibg=#535456 gui=NONE ctermfg=16 ctermbg=240 cterm=NONE
highlight String guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight Structure guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE

" 1. Aktif olmayan sekmeler ve 'File Explorer' arka planı
highlight TabLine guifg=#969896 guibg=#282a2e gui=NONE ctermfg=245 ctermbg=236 cterm=NONE

" 2. Aktif (şu an çalıştığın) sekmenin arka planı ve yazısı
highlight TabLineSel guifg=#a0cbff guibg=#212121 gui=bold ctermfg=4 ctermbg=16 cterm=bold

" 3. Sekmelerin sağında kalan boş, kullanılmayan arka plan
highlight TabLineFill guifg=NONE guibg=#212121 gui=NONE ctermfg=NONE ctermbg=16 cterm=NONE

highlight Title guifg=#969896 guibg=NONE ctermfg=245 ctermbg=NONE
highlight Todo guifg=#969896 guibg=#212121 ctermfg=245 ctermbg=16
highlight Type guifg=#fce9a9 guibg=NONE gui=NONE ctermfg=3 ctermbg=NONE cterm=NONE
highlight VertSplit guifg=#535456 guibg=#535456 gui=NONE ctermfg=240 ctermbg=240 cterm=NONE
highlight Visual guifg=NONE guibg=#373b41 ctermfg=NONE ctermbg=238
highlight WarningMsg guifg=#ff887f guibg=NONE ctermfg=1 ctermbg=NONE
highlight Include guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE

highlight cRepeat guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight cStorageClass guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight cType guifg=#fce9a9 guibg=NONE ctermfg=3 ctermbg=NONE
highlight diffAdded guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight diffRemoved guifg=#ff887f guibg=NONE ctermfg=1 ctermbg=NONE
highlight goBuiltins guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goConst guifg=#fce9a9 guibg=NONE ctermfg=3 ctermbg=NONE
highlight goConstants guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight goDeclType guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE
highlight goDeclaration guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goDirective guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goImport guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goLabel guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goPackage guifg=#ff887f guibg=NONE ctermfg=1 ctermbg=NONE
highlight goRepeat guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight goStatement guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight htmlItalic cterm=none
highlight javaScriptBraces guifg=#c5c8c6 guibg=NONE ctermfg=7 ctermbg=NONE
highlight javaScriptFunction guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight javaScriptMember guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight javaScriptNumber guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight javaScriptRepeat guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight phpKeyword guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight phpMemberSelector guifg=#c5c8c6 guibg=NONE ctermfg=7 ctermbg=NONE
highlight phpRepeat guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight phpStatement guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight phpVarSelector guifg=#ff887f guibg=NONE ctermfg=1 ctermbg=NONE
highlight pythonFunction guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE
highlight pythonInclude guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight pythonStatement guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight rubyAttribute guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE
highlight rubyConstant guifg=#fce9a9 guibg=NONE ctermfg=3 ctermbg=NONE
highlight rubyCurlyBlock guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight rubyInclude guifg=#a0cbff guibg=NONE ctermfg=4 ctermbg=NONE
highlight rubyInterpolationDelimiter guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight rubyLocalVariableOrMethod guifg=#ffa566 guibg=NONE ctermfg=11 ctermbg=NONE
highlight rubyRepeat guifg=#ae96ff guibg=NONE ctermfg=5 ctermbg=NONE
highlight rubyStringDelimiter guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight rubySymbol guifg=#9ed88a guibg=NONE ctermfg=2 ctermbg=NONE
highlight vimCommand guifg=#ff887f guibg=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE

highlight link Boolean Constant
highlight link Character Constant
highlight link Debug Special
highlight link Define PreProc
highlight link Delimiter Special
highlight link Exception Statement
highlight link Float Constant
highlight link Label Statement
highlight link Macro PreProc
highlight link Number Constant
highlight link PreCondit PreProc
highlight link SpecialChar Special
highlight link SpecialComment Special
highlight link StorageClass Type
highlight link Tag Special
highlight link Typedef Type

highlight link htmlTag Special
highlight link ALEErrorSign WarningMsg
highlight link ALEWarningSign Comment
