call plug#begin('~/.config/nvim/plugged')
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-lua/diagnostic-nvim'
	Plug 'airblade/vim-gitgutter'
	Plug 'junegunn/gv.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-eunuch'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'Townk/vim-autoclose'
	Plug 'neoclide/jsonc.vim'
	Plug 'lambdalisue/fern.vim'
	Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'nvim-treesitter/nvim-treesitter-refactor'
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'justinmk/vim-dirvish'
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
set colorcolumn=120
" set textwidth=80
set tabstop=4
set shiftwidth=4
" set expandtab
set noswapfile
set nobackup
set nowritebackup
set hidden

set background=dark
colorscheme PaperColor

map <Space> <Nop>
let mapleader = " "

cabbrev Q q
cabbrev W w
cabbrev Wq wq

" autocmd! VimLeave * set guicursor=a:ver25-blinkon0

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_cursor = 0
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_winsize = 20
let g:netrw_preview = 1

function! RemoveTrailingWS()
	:%s/\s\+$//e
endfunction

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
set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m
nnoremap <leader>rw :silent grep "<C-R><C-W>"<Space>
nnoremap <leader>rg :silent grep 
nmap <silent> ]q :cnext<CR>
nmap <silent> [q :cprev<CR>
nmap <silent> ]Q :clast<CR>
nmap <silent> [Q :cfirs<CR>

" rename word + repeat for next with dot
nnoremap <Plug>(expand-word) :let @/=expand('<cword>')<CR>
nmap <silent> <leader>rn <Plug>(expand-word)cgn

nnoremap <c-q> <c-a>

nnoremap gb :ls<CR>:b<Space>
nnoremap <silent> <c-k> :bnext<CR>
nnoremap <silent> <c-j> :bprevious<CR>
nnoremap <leader>d <c-^>
nnoremap <leader>n *
nnoremap <leader>N #
nnoremap <silent> <leader>; :call setline('.', getline('.') . ';')<CR>
nnoremap <leader>b gea
nnoremap <leader>B gEa

let g:fzf_preview_window = []
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.7 } }
let g:rg_files_opts = 'rg --follow --files --hidden -g !.git '
let g:fzf_action = {
  \ 'ctrl-f': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! Fzfp call fzf#run(fzf#wrap({'source': g:rg_files_opts, 'options': ['--multi']}))
command! Fzfc call fzf#run(fzf#wrap({'source': g:rg_files_opts . expand('%:h:r'), 'options': ['--multi']}))

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- ' . shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up', 'ctrl-/'), <bang>1)

autocmd! VimResized,VimEnter * call ResizeFZF()

function! ResizeFZF()
	if &columns < 110
		let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
	else
		let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.7 } }
	endif
endfunction

nnoremap <silent> <leader>p :Fzfp<CR>
nnoremap <silent> <leader>i :Fzfc<CR>
nnoremap <silent> <leader>o :Buffers<CR>
nnoremap <silent> <leader>u :History<CR>

nnoremap <leader>sa :w<CR>
nnoremap <leader>sl :w<CR>
nnoremap <leader>sq :wq<CR>
nnoremap <leader>sd :cd %:p:h<CR>
nnoremap <leader>st :%s/\s\+$//e<CR>
nnoremap <leader>tt :term<CR>
nnoremap <leader>ts :sp \| term<CR>
nnoremap <leader>tv :vsp \| term<CR>

nnoremap <leader>q <c-w>q
nnoremap <leader>w <c-w>w

"lines
nnoremap <silent> <c-n> :m .+1<CR>==
nnoremap <silent> <c-p> :m .-2<CR>==
vnoremap <silent> <c-n> :m '>+1<CR>gv=gv
vnoremap <silent> <c-p> :m '<-2<CR>gv=gv

"terminal
" tnoremap <Esc> <c-\><c-n>
tnoremap <c-d> <c-\><c-n>:bd!<CR>
autocmd! FileType fzf tnoremap <buffer> <esc> <c-q>

nmap <leader>rj <Plug>(dirvish_split_up)
nmap <leader>rl <Plug>(dirvish_vsplit_up)

" tree
nnoremap <leader>re :Fern . -drawer -reveal=% -toggle -width=41<CR>
let g:fern#default_hidden = 1

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

"comments
autocmd! FileType typescript,c setlocal commentstring=//\ %s
" autocmd! FileType javascript setlocal commentstring={/*\ %s\ */}
autocmd! FileType javascript setlocal commentstring=//\ %s

"git
nmap <leader>gg :G<CR>
nmap <leader>gv :Gvdiff<CR>
nmap <leader>g2 :diffget //2<CR>
nmap <leader>g3 :diffget //3<CR>

set statusline =\ %f\ \ [%p%%]\ \ %L%=%{fugitive#statusline()}\ [%(%l,%c%V%)]

autocmd! BufNewFile,BufRead *.json,*/waybar/config set filetype=jsonc

lua require'trees'
" set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

lua require'colorizer'.setup()

"partial sourcing, visual, line, paragraph
nnoremap <leader>ee :exe getline(".")<CR>
nnoremap <leader>ep <ESC>:exe join(GetParagraph(), "\n")<CR>
nnoremap <leader>eE :source %<CR>
nnoremap <leader>ef mmk/^endfunction<CR>V?^function<CR>"sy`m:@s<CR>
nnoremap <leader>ei :exe getline(".") \| PlugInstall<CR>
vnoremap <silent> <leader>e <ESC>:<C-U>exe join(GetVisual(), "\n")<CR>

augroup tab_stop
	autocmd!
	autocmd Filetype html,vim,css,xml,yaml,markdown,javascript,typescript
				\ setlocal tabstop=2
				\ | setlocal shiftwidth=2
augroup END

autocmd! Filetype vim nnoremap <silent><buffer> K :norm! K<CR>

command! Ini :e $MYVIMRC
cabbrev ini Ini

nmap <silent> <Plug>qfl-next :cnext \| call repeat#set("\<Plug>qfl-next")<CR>
nmap <silent> <Plug>qfl-prev :cprevious \| call repeat#set("\<Plug>qfl-prev")<CR>
nmap ]q <Plug>qfl-next
nmap [q <Plug>qfl-prev

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
  let opts = { 'relative': 'editor', 'row': y, 'col': x, 'width': width, 'height': height, 'style': 'minimal'}

	" let buf = winbufnr(0)
  call nvim_open_win(buf, v:true, opts)
	call Exec('ls')
	setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile ignorecase smartcase cursorline
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

set wildignore+=*node_modules/**,*bin/**,*build/**,*obj**

lua require'lsp_compl'

nnoremap <silent> <leader>aD 	<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>ad 	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ai  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>j 	<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>at  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>ar  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>as  <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>aw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>f 	<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>aa 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>. 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rm 	<cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>k 	<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

set completeopt=menuone,noinsert
set shortmess+=c

let g:completion_enable_auto_popup = 0
let g:completion_enable_auto_signature = 0
let g:completion_enable_snippet = 'vim-vsnip'
let g:completion_timer_cycle = 500

let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
			\ "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" : "\<CR>"

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_auto_popup_while_jump = 0

let g:vsnip_snippet_dir='~/.config/nvim/snippets/'

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
let g:vsnip_filetypes.eruby = ['html']

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

set laststatus=2
nnoremap <expr> <silent> <leader>gt &laststatus == 0 ? ':set laststatus=2<CR>' : ':set laststatus=0<CR>'

nnoremap yp Vpyy

if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif

command! Rspec1 call TmuxSendLine("bundle exec rspec " . expand("%") . ":" . line("."))
 
command! RspecB call TmuxSendLine("bundle exec rspec " . expand("%")) 
nnoremap <leader>4 :Rspec1<CR>
nnoremap <leader>5 :RspecB<CR>
let g:ruby_indent_access_modifier_style=""
command! RR exe "silent !chromium 'http://api.rubyonrails.org/?q='" . expand("<cword>")
command! RB exe "silent !chromium 'http://rubydoc.info/search/stdlib/core?q='" . expand("<cword>")

let g:bg_level = 1
function! Darken()
	if g:bg_level == g:max_bg_level
		let g:bg_level = -1
	endif
	let g:bg_level = g:bg_level + 1
	call Darker_bg(g:bg_level)
endfunction

function! Lighten()
	if g:bg_level < 1
		let g:bg_level = g:max_bg_level + 1
	endif
	let g:bg_level = g:bg_level - 1
	call Darker_bg(g:bg_level)
endfunction

nnoremap <c-up> :call darken()<cr>
nnoremap <c-down> :call lighten()<cr>
inoremap <c-up> <esc>:call darken()<cr>
inoremap <c-down> <esc>:call Lighten()<CR>

let g:tmux_target_pane = "{right-of}"
function! TmuxSendLine(line)
	call system("tmux send-keys -t " . g:tmux_target_pane . " " . shellescape(a:line, 1) . "\r")
endfunction

function! TmuxSend(region)
	call TmuxSendLine(join(a:region, "\r"))
endfunction

nnoremap <silent> <M-e> :call TmuxSendLine(getline("."))<CR>
inoremap <silent> <M-e> <esc>:call TmuxSendLine(getline("."))<CR>
nnoremap <silent> <M-r> :call TmuxSend(GetParagraph())<CR>
inoremap <silent> <M-r> <esc>:call TmuxSend(GetParagraph())<CR>
vnoremap <silent> <M-e> <Esc>:<C-U>call TmuxSend(GetVisual())<CR>
nnoremap <silent> <M-E> :call TmuxSend(getline(line("^"), line("$")))<CR>

command! -nargs=1 -complete=custom,TmuxTargets TmuxTargetPane :let g:tmux_target_pane=<f-args>

function! TmuxTargets(A,L,P)
	return "{right-of}\n{left-of}\n{down-of}\n{up-of}\n{last}\n{next}\n{previous}\n{top}\n{bottom}\n{left}\n{right}\
				\n{top-left}\n{top-right}\n{bottom-left}\n{bottom-right}"
endfunction

function! GetParagraph()
	if getline(".") == ""
		return [""]
	endif
	let l:first = line("'{")
	let l:last = line("'}")
	if l:first > 1
		let l:first = l:first + 1
	endif
	if getline(l:last) == ""
		let l:last = line("'}") - 1
	endif
	return getline(l:first, l:last)
endfunction

function! GetVisual()
	return getline(line("'<'"), line("'>'"))
endfunction

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <M-d> <Del>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

nnoremap yap mmyap`m
vnoremap y mmy`m

function! Yank(region)
	let @+ = join(a:region, "\n") . "\n"
	if len(a:region) == 1
		echo "1 line yanked"
	else
		echo len(a:region) . " lines yanked"
	endif
endfunction

nnoremap <silent>yip :call Yank(GetParagraph())<CR>
" vnoremap <silent>y <Esc>:<C-U>call Yank(GetVisual())<CR>

function! RailsRelationsJump(symbol)
	return join(map(split(a:symbol, "_"), 'toupper(v:val[0]) . v:val[1:col("$")]'), "")
endfunction

function! RailsRelationsJump2(symbol)
	return RailsRelationsJump(a:symbol[0:len(a:symbol)-2])
endfunction

nnoremap <leader>] :exe "tag " . RailsRelationsJump(expand("<cword>"))<CR>
nnoremap <leader>[ :exe "tag " . RailsRelationsJump2(expand("<cword>"))<CR>


function! GoToPartial()
	if stridx(expand("<cWORD>"), "/") != -1
		call GoToPartial2()
	else
		let l:word = expand("<cword>")
		exe "e " . expand('%:p:h') . "/_" . l:word . ".html.erb"
	endif
endfunction

function! GoToPartial2()
	let l:word = expand("<cWORD>")
	if stridx(l:word, "\",") != -1
		let l:word = l:word[1:len(l:word)-3]
	else
		let l:word = l:word[1:len(l:word)-2]
	endif
	let l:splitted = split(l:word, '/')
	let l:last = l:splitted[len(l:splitted) - 1]
	let l:splitted[len(l:splitted) - 1] = "_" . l:last
	let l:joined = join(l:splitted, '/')
	exe "e app/views/" .  l:joined . ".html.erb"
endfunction

nnoremap <leader>' :call GoToPartial()<CR>
