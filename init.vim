call plug#begin('~\AppData\Local\nvim\plugged')
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-lua/diagnostic-nvim'
	Plug 'airblade/vim-gitgutter'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/gv.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-eunuch'
	Plug 'jpalardy/vim-slime'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'jiangmiao/auto-pairs'
	Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for': 'markdown' }
	Plug 'neoclide/jsonc.vim'
	Plug 'lambdalisue/fern.vim'
	Plug 'MaxMEllon/vim-jsx-pretty'
	Plug 'yuezk/vim-js'
call plug#end()

set mouse=a
set relativenumber number
set updatetime=100
set signcolumn=yes
set clipboard=unnamedplus
set termguicolors
set nohlsearch
set inccommand=nosplit
set pumheight=15
set splitright
set splitbelow
set colorcolumn=80
" set textwidth=80
set tabstop=4
set shiftwidth=4
" set expandtab
set noswapfile
set nobackup
set nowritebackup
set hidden

set background=light
colorscheme PaperColor

map <Space> <Nop>
let mapleader = " "

cabbrev Q q
cabbrev W w
cabbrev Wq wq

" autocmd! VimLeave * set guicursor=a:ver25-blinkon0

" netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_cursor = 0
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_winsize = 20
let g:netrw_preview = 1

function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction

augroup autoquickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost    l* lwindow
augroup END

"change :grep to rg
set grepprg=rg\ --vimgrep\ --block-buffered
set grepformat^=%f:%l:%c:%m
"grep for word under cursor
nnoremap <leader>rw :silent grep! "\b<C-R><C-W>\b"<CR>:copen<CR><CR>
nnoremap <leader>rg :silent grep 
nmap <silent> ]q :cnext<CR>
nmap <silent> [q :cprev<CR>
nmap <silent> ]Q :clast<CR>
nmap <silent> [Q :cfirs<CR>

" rename ward + repeat for next with dot
nnoremap <leader>rn *Ncgn
nnoremap <leader>rN #Ncgn

let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': { 'width': 0.4, 'height': 0.6 } }
let g:fzf_preview_window = ''
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-a': function('s:build_quickfix_list')
      \ }

command! Fzfp call fzf#run(fzf#wrap({'source': 'rg --follow --files --hidden --glob "!.git/"', 'options': ['--multi']}))
command! Conf call fzf#run(fzf#wrap({'source': 'rg --follow --ignore-file ~/.cfgignore --files ~/', 'options': ['--multi', '--prompt=Conf> ']}))
command! OSess call fzf#run({'source': 'ls', 'dir': '~/.sess/', 'sink': 'source', 'options': ['--prompt=OpenSession>']})
command! OProj call fzf#run({'source': 'ls', 'dir': '~/Projects', 'sink': 'cd', 'options': ['--prompt=OpenProj>']})
command! RSess call fzf#run({'source': 'ls', 'dir': '~/.local/share/sess', 'sink': '! rm', 'options': ['--multi', '--prompt=RemoveSession>']})

" hotkeys
nnoremap <c-q> <c-a>

nnoremap <silent> <c-k> :bnext<CR>
nnoremap <silent> <c-j> :bprevious<CR>
nnoremap <leader>d <c-^>
nnoremap <leader>n *
nnoremap <leader>m #
nnoremap <leader>; :call setline('.', getline('.') . ';')<CR>
nnoremap <leader>b gea
nnoremap <leader>B gEa

" fzf (mostly)
nnoremap <silent> <leader>p :Fzfp<CR>
nnoremap <silent> <leader>u :GFiles<CR>
nnoremap <silent> <leader>o :Buffers<CR>
nnoremap <silent> <leader>i :History<CR>
nnoremap <silent> <leader>c :Conf<CR>
nnoremap <silent> <leader>sm :Marks<CR>

nnoremap <leader>so :OSess<CR>
nnoremap <leader>sp :OProj<CR>
nnoremap <leader>sr :RSess<CR>
" nnoremap <leader>ss :mks! ~/.local/share/sess/
nnoremap <leader>sa :w<CR>
nnoremap <leader>sl :w<CR>
nnoremap <leader>sq :wq<CR>
nnoremap <leader>sd :cd %:p:h<CR>
" nnoremap <leader>se :Lex<CR>
nnoremap <leader>st :%s/\s\+$//e<CR>
nnoremap <leader>tt :term<CR>
nnoremap <leader>ts :sp \| term<CR>
nnoremap <leader>tv :vsp \| term<CR>

" windows
nnoremap <m-h> <c-w>h
nnoremap <m-j> <c-w>j
nnoremap <m-k> <c-w>k
nnoremap <m-l> <c-w>l
nnoremap <leader>q <c-w>q
nnoremap <leader>w <c-w>w

"lines
nnoremap <silent> <c-n> :m .+1<CR>==
nnoremap <silent> <c-p> :m .-2<CR>==
vnoremap <silent> <c-n> :m '>+1<CR>gv=gv
vnoremap <silent> <c-p> :m '<-2<CR>gv=gv

"terminal
tnoremap <Esc> <c-\><c-n>
tnoremap <c-d> <c-\><c-n>:bd!<CR>
autocmd! FileType fzf tnoremap <buffer> <esc> <c-q>

" tree
nnoremap <leader>re :Fern . -drawer -reveal=% -toggle<CR>
nnoremap <leader>rr :Fern . -reveal=% -opener=edit<CR>
nnoremap <leader>rj :Fern . -reveal=% -opener=split<CR>
nnoremap <leader>rk :Fern . -reveal=% -opener=leftabove\ split<CR>
nnoremap <leader>rl :Fern . -reveal=% -opener=vsplit<CR>
nnoremap <leader>rh :Fern . -reveal=% -opener=leftabove\ vsplit<CR>
nnoremap <leader>rJ :Fern . -reveal=% -opener=botright\ split<CR>
nnoremap <leader>rK :Fern . -reveal=% -opener=topleft\ split<CR>
nnoremap <leader>rL :Fern . -reveal=% -opener=botright\ vsplit<CR>
nnoremap <leader>rH :Fern . -reveal=% -opener=topleft\ vsplit<CR>

let g:gitgutter_map_keys = 0
nmap <silent> <leader>gn <Plug>(GitGutterNextHunk) :call repeat#set("\<Plug>(GitGutterNextHunk)")<CR>
nmap <silent> <leader>gp <Plug>(GitGutterPrevHunk) :call repeat#set("\<Plug>(GitGutterPrevHunk)")<CR>
nmap <leader>gi <Plug>(GitGutterPreviewHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)

omap ig <Plug>(GitGutterTextObjectInnerPending)
omap ag <Plug>(GitGutterTextObjectOuterPending)
xmap ig <Plug>(GitGutterTextObjectInnerVisual)
xmap ag <Plug>(GitGutterTextObjectOuterVisual)

" term buffer
augroup custom_term
	autocmd!
	autocmd TermOpen *
				\ setlocal bufhidden=hide
				\ | norm! a
augroup END

let g:slime_target = "neovim"
let g:slime_no_mappings = 1
xmap <M-r> <Plug>SlimeRegionSend
nmap <M-r> <Plug>SlimeParagraphSend
imap <M-r> <ESC><Plug>SlimeParagraphSend
nmap <silent> <M-e> :SlimeSend<CR>
imap <silent> <M-e> <ESC>:SlimeSend<CR>
nmap <silent> <M-E> mmggVG:SlimeSend<CR>`m
nmap <leader>sc <Plug>SlimeConfig
" let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

"comments
autocmd! FileType typescript,c setlocal commentstring=//\ %s

"git
nmap <leader>gg :G<CR>
nmap <leader>gv :Gvdiff<CR>
nmap <leader>g2 :diffget //2<CR>
nmap <leader>g3 :diffget //3<CR>

set statusline =\ %f\ \ [%p%%]\ \ %L%=%{fugitive#statusline()}\ [%(%l,%c%V%)]

autocmd! BufNewFile,BufRead *.json,*/waybar/config set filetype=jsonc

" lua require'trees'
" set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

"Color preview
"Buggy in neovim nightly with treesitter
lua require'colorizer'.setup()

"partial sourcing, visual, line, paragraph
nnoremap <leader>ee :execute getline(".")<CR>
nnoremap <leader>ep ms"syip`s:@s<CR>
nnoremap <leader>ef mmk/^endfunction<CR>V?^function<CR>"sy`m:@s<CR>
nnoremap <leader>ei :execute getline(".") \| PlugInstall<CR>
vnoremap <leader>e <ESC>:execute join(getline(line("'<"), line("'>")), "\n")<CR>

augroup tab_stop
	autocmd!
	autocmd Filetype html,vim,css,xml,yaml,markdown,javascript
				\ setlocal tabstop=2 
				\ | setlocal shiftwidth=2
augroup end

command! Ini :e $MYVIMRC
cabbrev ini Ini

"Treesitter slow loading time, load on command
" function! LoadTS()
" 	Plug 'nvim-treesitter/nvim-treesitter'
" 	call plug#load('nvim-treesitter')
" 	" lua require'trees'
" 	lua vim.treesitter.TSHighlighter.hl_map["variable.builtin"] = "TSVariableBuiltin"
" 	TSBufEnable highlight
" 	TSBufEnable incremental_selection
" 	TSBufEnable refactor.smart_rename
" 	TSBufEnable refactor.highlight_definitions
" 	TSBufEnable refactor.navigation
" endfunction
" autocmd! Filetype javascript,typescript,python,c,cpp,java call LoadTS()

" command! TS :call LoadTS()<CR>
" nnoremap <silent> <leader>rt :call LoadTS()<CR>
"

let g:AutoPairsShortcutFastWrap = '<M-w>'
let g:fern#default_hidden = 1

function! Start()
    " Don't run if: we have commandline arguments, we don't have an empty
    " buffer, if we've not invoked as vim or gvim, or if we'e start in insert mode
    if argc()
        return
    endif

    " Start a new buffer ...
    enew
		-1r ~\AppData\Local\nvim\paths.txt

    setlocal
        \ bufhidden=wipe
        \ buftype=nofile
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ noswapfile

    " No modifications to this buffer
    setlocal nomodifiable nomodified

    " When we go to insert mode start a new buffer, and start insert
    nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
    nnoremap <buffer><silent> o :execute "e " . getline(".")<CR>
		nnoremap <buffer><silent> <CR> :execute "cd" . getline(".") "\| Fern ."<CR>
		nnoremap <buffer><silent> <leader>p :execute "cd" . getline(".") "\| Fzfp"<CR>
		nnoremap <buffer><silent> <c-s> :execute "source" . getline(".")<CR>
endfunction

command! StartScreen call Start()
autocmd! VimEnter * call Start()
autocmd! VimResized * call ResizeFZF()
nnoremap <silent> <leader>ss :call Start()<CR>

function! ResizeFZF()
	if &columns < 110
		let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
	else
		let g:fzf_layout = { 'window': { 'width': 0.4, 'height': 0.6 } }
	endif
endfunction


nmap <silent> <Plug>qfl-next 
			\ :cnext \| call repeat#set("\<Plug>qfl-next")<CR>
nmap <silent> <Plug>qfl-prev
			\ :cprevious \| call repeat#set("\<Plug>qfl-prev")<CR>
nmap ]q <Plug>qfl-next
nmap [q <Plug>qfl-prev

" Opens list of buffers in floating window and make mappings for opening buffer
" in splits
function! FloatingWindow()
  let buf = nvim_create_buf(v:true, v:true)

	if &columns < 110
		let width = float2nr(&columns * 0.9)
	else
		let width = float2nr(&columns * 0.45)
	endif
  let height = 30
  let y = &lines - height - 10
  let x = float2nr((&columns - width) * 0.5)
  let opts = { 'relative': 'editor', 'row': y, 'col': x, 'width': width,
				\ 'height': height, 'style': 'minimal'}

	" let buf = winbufnr(0)
  call nvim_open_win(buf, v:true, opts)
	call Exec('ls')

	setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
				\ ignorecase smartcase cursorline
	call deletebufline('%', 1, 2)
	call deletebufline('%', line('.'), line('.'))
	setlocal nomodifiable nomodified

	nnoremap <buffer><silent> <ESC> :q<CR> 
	nnoremap <buffer> s /
	nnoremap <buffer><silent> <CR> :call BuffSplit(getline("."), 'e')<CR>
	nnoremap <buffer><silent> l :call BuffSplit(getline("."), 'e')<CR>
	nnoremap <buffer><silent> <leader>l :call BuffSplit(getline("."), 'vs')<CR>
	nnoremap <buffer><silent> <leader>h :call BuffSplit(getline("."), 'vertical leftabove split')<CR>
	nnoremap <buffer><silent> <leader>j :call BuffSplit(getline("."), 'sp')<CR>
	nnoremap <buffer><silent> <leader>k :call BuffSplit(getline("."), 'leftabove split')<CR>
	nnoremap <buffer><silent> <leader>tt :call BuffSplit(getline("."), 'tabnew')<CR>
	nnoremap <buffer><silent> <c-r> :call BuffWinDelete()<CR>
endfunction

function! BuffSplit(line, split_name)
	q
	execute a:split_name . ' ' . split(a:line, '"')[1]
endfunction

function! BuffWinDelete()
	setlocal modifiable 
	" execute 'bd ' . split(getline("."), '"')[1]
	" find a better way to get number at the beggining of the line
	norm! 0e
	execute 'bd ' . expand('<cword>')
	call deletebufline('%', line('.'), line('.'))
	setlocal nomodifiable
endfunction

function! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
    return ''
endfunction!

nnoremap <leader>l :call FloatingWindow()<CR>

lua << EOF
local lsp = require('nvim_lsp')

local attach = function()
	require'completion'.on_attach()
	require'diagnostic'.on_attach()
end

lsp.tsserver.setup {
	on_attach=attach,
}
lsp.omnisharp.setup {
	on_attach=attach,
}
EOF

nnoremap <silent> <leader>aD 	<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>ad 	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>k 	<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ai  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>j 	<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>at  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>ar  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>as  <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>aw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>af 	<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>aa 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rm 	<cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>ak 	<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

set completeopt=menuone,noinsert
set shortmess+=c

let g:completion_enable_auto_popup = 1
let g:completion_enable_snippet = 'vim-vsnip'

let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
			\ "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" : "\<CR>"

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_auto_popup_while_jump = 0

let g:vsnip_snippet_dir='~\\AppData\\Local\\nvim\\snippets\'

imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
imap <c-k> <S-Tab>
smap <c-k> <S-Tab>

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

imap <silent> <c-space> <Plug>(completion_trigger)

nnoremap <silent> <leader>an :NextDiagnosticCycle<CR>
nnoremap <silent> <leader>ap :PrevDiagnosticCycle<CR>

function! ToggleDiagType()
	w
	if g:diagnostic_enable_virtual_text == 0
		let g:diagnostic_enable_virtual_text = 1
		let g:diagnostic_auto_popup_while_jump = 0
	else
		let g:diagnostic_enable_virtual_text = 0
		let g:diagnostic_auto_popup_while_jump = 1
	endif
	e
endfunction

command! ToggleVirtualText call ToggleDiagType()
nnoremap <silent> <leader>se :call ToggleDiagType()<CR>

