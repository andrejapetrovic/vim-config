call plug#begin('~/.config/nvim/plugged')
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'airblade/vim-gitgutter'
	Plug 'junegunn/gv.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-eunuch'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'Townk/vim-autoclose'
	Plug 'neoclide/jsonc.vim'
	Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'nvim-treesitter/nvim-treesitter-refactor'
	Plug 'ludovicchabant/vim-gutentags'
	Plug 'justinmk/vim-dirvish'
	Plug 'dense-analysis/ale'
	" Plug 'vimpostor/vim-tpipeline'
	" Plug 'hrsh7th/nvim-compe'
call plug#end()

filetype plugin on
set mouse=a
set relativenumber number
set updatetime=100
set signcolumn=yes:2
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

set background=light
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

command! -range=% TrailingWhiteSpace <line1>,<line2>s/\s\+$//e

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

set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m
nnoremap <leader>rw :silent grep "<C-R><C-W>"<space>
nnoremap <leader>rg :silent grep<space>

nmap <silent> <Plug>(qfl-next) :call Cnext() \| call repeat#set("\<Plug>(qfl-next)")<CR>
nmap <silent> <Plug>(qfl-prev) :call Cprev() \| call repeat#set("\<Plug>(qfl-prev)")<CR>
nmap <silent> ]q <Plug>(qfl-next)
nmap <silent> [q <Plug>(qfl-prev)
nmap <silent> ]Q :clast<CR>
nmap <silent> [Q :cfirs<CR>

function! Cnext()
	try
		cnext
	catch
		cfirst
	endtry
endfunction

function! Cprev()
	try
		cprev
	catch
		clast
	endtry
endfunction

" rename word + repeat for next with dot
nnoremap <Plug>(expand-word) :let @/=expand('<cword>')<CR>
nmap <silent> <leader>rn <Plug>(expand-word)cgn

nnoremap <c-q> <c-a>

nnoremap <leader>f :find *
nnoremap <leader>sf :sf *
nnoremap <leader>sv :vert sf *

nnoremap Y y$
nnoremap gb :ls<CR>:b<Space>
" nnoremap <silent> <c-k> :bnext<CR>
" nnoremap <silent> <c-j> :bprevious<CR>
nnoremap <silent> <c-k> gk
nnoremap <silent> <c-j> gj
nnoremap <leader>d <c-^>
nnoremap <cr> <c-^>
nnoremap <leader>n *
nnoremap <leader>N #
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
	if &columns < 150
		let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
	else
		let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.7 } }
	endif
endfunction

nnoremap <silent> <leader>p :Fzfp<CR>
nnoremap <silent> <leader>i :Fzfc<CR>
nnoremap <silent> <leader>o :Buffers<CR>
nnoremap <silent> <leader>u :History<CR>

nnoremap <leader>sd :cd %:p:h<CR>
nnoremap <leader>tt :term<CR>
nnoremap <leader>ts :split term://bash<CR>
nnoremap <leader>tv :vsplit term://bash<CR>

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

let g:gitgutter_map_keys = 0
nmap <silent> <Plug>(GitGutterCycleHunksNext) :silent! call GitCycleHunks(0) \| call repeat#set("\<Plug>(GitGutterCycleHunksNext)")<CR>
nmap <silent> <Plug>(GitGutterCycleHunksPrev) :silent! call GitCycleHunks(-1) \| call repeat#set("\<Plug>(GitGutterCycleHunksPrev)")<CR>
nmap <silent> <leader>gn <Plug>(GitGutterCycleHunksNext)
nmap <silent> <leader>gp <Plug>(GitGutterCycleHunksPrev)
nmap <leader>gi <Plug>(GitGutterPreviewHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)

omap ig <Plug>(GitGutterTextObjectInnerPending)
omap ag <Plug>(GitGutterTextObjectOuterPending)
xmap ig <Plug>(GitGutterTextObjectInnerVisual)
xmap ag <Plug>(GitGutterTextObjectOuterVisual)

function! GitCycleHunks(n)
	let l:current = line('.')
	if a:n == 0
		GitGutterNextHunk
	else
		GitGutterPrevHunk
	endif
	if l:current == line('.')
		call cursor(GitGutterGetHunks()[a:n][2], 1)
	endif
endfunction

" term buffer
augroup custom_term
	autocmd!
	autocmd TermOpen *
				\ setlocal bufhidden=hide
				\ | norm! a
augroup END

"git
nmap <leader>gg :G<CR>
nmap <leader>gv :Gvdiff<CR>
nmap <leader>g2 :diffget //2<CR>
nmap <leader>g3 :diffget //3<CR>
nmap <leader>gb :Gblame<CR>

set statusline =\ %f\ \ [%p%%]\ \ %L%=%{fugitive#statusline()}\ [%(%l,%c%V%)]

autocmd! BufNewFile,BufRead *.json,*/waybar/config set filetype=jsonc

lua require'trees'
" set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

lua require'colorizer'.setup()

"partial sourcing, visual, line, paragraph
nnoremap <leader>ee :exe getline(".")<CR>
nnoremap <leader>ep <ESC>:exe join(ParseBackslash(GetParagraph()), "\n")<CR>
nnoremap <leader>eE :source %<CR>
nnoremap <leader>ef mmk/^endfunction<CR>V?^function<CR>"sy`m:@s<CR>
nnoremap <leader>ei :exe getline(".") \| PlugInstall<CR>
vnoremap <silent> <leader>e <ESC>:<C-U>exe join(ParseBackslash(GetVisual()), "\n")<CR>

augroup tab_stop
	autocmd!
	autocmd Filetype html,vim,css,xml,yaml,markdown,javascript,typescript
				\ setlocal tabstop=2
				\ | setlocal shiftwidth=2
augroup END

autocmd! Filetype vim,help nnoremap <silent><buffer> K :norm! K<CR>

command! Ini :e $MYVIMRC
cabbrev ini Ini

set wildignore+=*node_modules/**,*bin/**,*build/**,*obj**,*plugged/**,*doc/**

" lua require'lsp_compl'

nnoremap <silent> <leader>aD 	<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>ad 	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K 					<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ai  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>j 	<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>at  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>ar  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>as  <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>aw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>af 	<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>aa 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>. 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rm 	<cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>k 	<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" set completeopt=menuone,noselect

" let g:compe = {}
" let g:compe.enabled = v:true
" let g:compe.autocomplete = v:false
" let g:compe.debug = v:false
" let g:compe.min_length = 1
" let g:compe.preselect = 'enable'
" let g:compe.throttle_time = 80
" let g:compe.source_timeout = 200
" let g:compe.incomplete_delay = 400
" let g:compe.max_abbr_width = 100
" let g:compe.max_kind_width = 100
" let g:compe.max_menu_width = 100
" let g:compe.documentation = v:true

" let g:compe.source = {}
" let g:compe.source.path = v:false
" let g:compe.source.buffer = v:false
" let g:compe.source.calc = v:false
" let g:compe.source.vsnip = v:true
" let g:compe.source.nvim_lsp = v:true
" let g:compe.source.nvim_lua = v:true
" let g:compe.source.spell = v:false
" let g:compe.source.tags = v:false
" let g:compe.source.snippets_nvim = v:false
" let g:compe.source.treesitter = v:false
" let g:compe.source.omni = v:false

" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')

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

nmap <silent> <Plug>(diag-next) :exe "lua vim.lsp.diagnostic.goto_next()" \| call repeat#set("\<Plug>(diag-next)")<CR>
nmap <silent> <Plug>(diag-prev) :exe "lua vim.lsp.diagnostic.goto_prev()" \| call repeat#set("\<Plug>(diag-prev)")<CR>

nmap <silent> <leader>an <Plug>(diag-next)
nmap <silent> <leader>ap <Plug>(diag-prev)

set laststatus=2
nnoremap <expr> <silent> <leader>gt &laststatus == 0 ? ':set laststatus=2<CR>' : ':set laststatus=0<CR>'

nnoremap yp Vpyy

let g:tmux_target_pane = "{right-of}"

function! TmuxSendLine(line)
	call system("tmux send-keys -t " . g:tmux_target_pane . " " . shellescape(a:line, [1]) . "\r")
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

command! -nargs=1 -complete=customlist,TmuxTargets TmuxTargetPane :let g:tmux_target_pane=<f-args>

function! TmuxTargets(ArgLead, CmdLine, CursorPos)
	return filter(['{right-of}', '{left-of}', '{down-of}', '{up-of}', '{last}', '{next}', '{previous}', '{top}',
				\ '{bottom}', '{left}', '{right}', '{top-left}', '{top-right}', '{bottom-left}', '{bottom-right}'],
				\ 'v:val =~ "' . a:ArgLead . '"')
endfunction

function! GetParagraphLines() abort
	let l:first = line("'{")
	let l:last = line("'}")
	if l:first > 1
		let l:first = l:first + 1
	endif
	if getline(l:last) == ""
		let l:last = line("'}") - 1
	endif
	return [l:first, l:last]
endfunction

function! GetParagraph() abort
	let l:boundaries = GetParagraphLines()
	return getline(l:boundaries[0], l:boundaries[1])
endfunction

function! GetVisual()
	return getline(line("'<'"), line("'>'"))
endfunction

function! ParseBackslash(region) abort
	let l:c = 0
	let l:new_list = []
	while l:c < len(a:region)
		if match(a:region[l:c], '^\s\+\\') != -1
			let l:new_list[-1] = l:new_list[-1] . substitute(a:region[l:c], '^\s\+\\', '', '')
		else
			call add(l:new_list, a:region[l:c])
		endif
		let l:c += 1
	endwhile
	return l:new_list
endfunction

cnoremap <c-q> <esc>q:k
cnoremap <c-a> <Home>
cnoremap <c-e> <End>
cnoremap <c-D> <Del>
cnoremap <m-d> <s-Right><c-w><Del>
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>
cnoremap <c-b> <Left>
cnoremap <c-f> <Right>
cnoremap <m-b> <S-Left>
cnoremap <m-f> <S-Right>

nnoremap yap mmyap`m
nnoremap yip mmyip`m
vnoremap y mmy`m

nnoremap =ap mm=ap`m
nnoremap =ip mm=ip`m
vnoremap = mm=`m

nnoremap <m-p> "0p
nnoremap <M-P> "0P
vnoremap <M-p> "0p

augroup makeprgs
		autocmd!
		autocmd Filetype c set makeprg=gcc\ -o\ %<\ %\ &&\ ./%:r
		autocmd Filetype go set makeprg=go\ run\ %
augroup END

function! SetCommentPattern() abort
	if empty(&commentstring)
		return
	endif
	let g:comment_pattern = split(&commentstring, '%s')
	let g:comment_pattern[0] = substitute(g:comment_pattern[0], '\s\+$\|$', ' ', '')
	if len(g:comment_pattern) == 1
		let g:comment_pattern = g:comment_pattern + ['']
	else
		let g:comment_pattern[1] = substitute(g:comment_pattern[1], '%s/\s\+^\|^', ' ', '')
	endif
endfunction

function! SetCommentString(cstring) abort
	exe "autocmd! FileType " . &filetype . " setlocal commentstring=" . a:cstring
	call SetCommentPattern()
	exe "w | e"
endfunction

autocmd! BufEnter * call SetCommentPattern()

function! CommentLine(pattern) abort
	let l:line = trim(getline('.'))
	if l:line == ""
	elseif IsCommented(l:line, a:pattern)
		call setline('.', AddIndent(GetIndent('.')) . l:line[len(a:pattern[0]):len(a:pattern[1])-1])
	else
		call setline('.', AddIndent(GetIndent('.')) . a:pattern[0] . l:line . a:pattern[1])
	endif
endfunction

function! IsCommented(line, pattern) abort
	let l:left = a:line[0:len(a:pattern[0])-1]
	let l:right = a:line[len(a:line)-len(a:pattern[1]):]
	return l:left == a:pattern[0] && l:right == a:pattern[1]
endfunction

function! GetIndent(line) abort
	if &expandtab
		return indent(a:line)
	else
		return indent(a:line)/&tabstop
	endif
endfunction

function! AddIndent(indent) abort
	let l:i = 0
	let l:s = ""
	while l:i < a:indent
		if &expandtab
			let l:s = l:s . " "
		else
			let l:s = l:s . "\t"
		end
		let l:i += 1
	endwhile
	return l:s
endfunction

function! CommentRegion(pattern, boundaries) abort
	if getline('.') == ""
		return
	endif
	let l:current = a:boundaries[0]
	let l:indent = GetIndent(l:current)
	if IsCommented(trim(getline('.')), a:pattern)
		while l:current <= a:boundaries[1]
			let l:current_line = trim(getline(l:current))
			if IsCommented(l:current_line, a:pattern)
				call setline(l:current, AddIndent(GetIndent(l:current)) . l:current_line[len(a:pattern[0]):len(a:pattern[1])-1])
			endif
			let l:current += 1
		endwhile
	else
		while l:current <= a:boundaries[1]
			let l:current_indent = GetIndent(l:current)
			let l:current_line = trim(getline(l:current))
			if IsCommented(l:current_line, a:pattern) || l:current_line == ""
			elseif l:indent > l:current_indent
				call setline(l:current, AddIndent(l:current_indent) . a:pattern[0] . l:current_line . a:pattern[1])
			else
				call setline(l:current, AddIndent(l:indent) . a:pattern[0] . AddIndent(l:current_indent - l:indent) . l:current_line . a:pattern[1])
			endif
			let l:current += 1
		endwhile
	endif
endfunction

nmap <silent> <Plug>(comment-line) :call CommentLine(g:comment_pattern) \| call repeat#set("\<Plug>(comment-line)")<CR>
nmap <silent> <Plug>(comment-paragraph) :call CommentRegion(g:comment_pattern, GetParagraphLines()) \| call repeat#set("\<Plug>(comment-paragraph)")<CR>

nmap <silent> <leader>h <Plug>(comment-line)
nmap <silent> <leader>H <Plug>(comment-paragraph)

vnoremap <silent> <leader>h <Esc>:<C-u>call CommentRegion(g:comment_pattern, [line("'<"), line("'>")])<CR>

command! -nargs=1 -complete=tag Sur call setline('.', AddIndent(GetIndent('.')) . <f-args> . '(' . trim(getline('.')) . ')')
nnoremap <leader>su :Sur<space>

nnoremap dam f(mm%x`mbdf(
nnoremap daM f(mm%x`mF.bdf(

nnoremap <leader>sk :silent !mkdir %
nnoremap <leader>sn :silent !touch %
nnoremap <leader>sm :call Rename()<CR>
nnoremap <leader>sr :call Confirm("Do you want to remove '" . getline('.') . "'? (y/n)", "silent !rm -rf '" . getline('.') . "'")<CR>
vnoremap <leader>sm <esc>:<c-u>call BulkShdoRename()<CR>

function! Confirm(msg, command)
	echo a:msg . ' '
	let l:answer = nr2char(getchar())
	if l:answer ==? 'y' || l:answer ==? nr2char(13)
		exe a:command
		echon ''
	elseif l:answer ==? 'n' || l:answer ==? nr2char(27)
		return 0
	else
		echo 'Please enter "y" or "n"'
		return Confirm(a:msg, a:command)
	endif
endfunction

function! Rename()
	let l:name = getline('.')
	call inputsave()
	let l:newname = input('Rename: ', l:name)
	call inputrestore()
	redraw!
	exe "silent !mv '" . l:name . "' '" . l:newname . "'"
	echon ''
endfunction

function! BulkShdoRename() abort
	exe "'<,'>Shdo mv\/ {}\/ {}"
	silent! %!column -t -s '\/'
endfunction

nnoremap <leader>rs :%s/
vnoremap <leader>r :s/\%V

nnoremap <leader>ell :exe "lua " . getline('.')<CR>
nnoremap <leader>elp :exe "lua " . join(GetParagraph(), '')<CR>
vnoremap <leader>l <esc>:<c-u>exe "lua " . join(GetVisual(), '')<CR>

" source $HOME/.config/nvim/float.vim

command! OpenLink !chromium <cWORD>

augroup dirvish_config
	autocmd!
	autocmd FileType dirvish cnoremap <buffer> <c-o> <c-m>:norm i<CR>
augroup END

command! -nargs=* -complete=customlist,ListOldFiles OldFiles call OpenFile(<f-args>)

function! ListOldFiles(ArgLead, CmdLine, CursorPos)
	return filter(copy(v:oldfiles), 'v:val =~ "'. a:ArgLead .'"')
endfunction

function! OpenFile(path,...)
	let l:action = len(a:000) == 0 ? 'e' : join(a:000, ' ')
	exe l:action . ' ' . a:path
endfunction

nnoremap <leader>so :OldFiles<space>

augroup set_path
	autocmd!
	autocmd VimEnter * 
				\ if filereadable('./Gemfile') | set path=.*,app/**,spec/**,db/**,.,*
				\ | elseif filereadable('./package.json') | set path=.*,src/**,.,* 
				\ | endif
augroup END

command! SudoWrite exe 'w !SUDO_ASKPASS=`which ssh-askpass` sudo tee > /dev/null %:p:S' | setlocal nomod

command! GP !git push origin HEAD

noremap <f1> <c-]>
nnoremap <f2> <c-t>

inoremap <c-f> <Right>
inoremap <c-b> <Left>

function! JsImport(file)
	let l:fpath = split(system('find src/** -name "*' . a:file . '*"'), '\n')[0]
	let l:fpath = "import " . a:file . " from '" . substitute(l:fpath, '^src/', './', '') . "';"
	call append(1, l:fpath)
endfunction

nnoremap <leader>a. :call JsImport(expand('<cword>'))<CR>

" nnoremap tf :call Float(0.7, 0.8) \| exe "term"<CR>

nnoremap <leader><tab> :suspend<CR>

command! Bdel exe "bd " . join(filter(map(split(execute('buffers'), '\n'), {_,x -> split(x, ' ')[0]}), {_,x -> x != bufnr()}))

let g:ale_disable_lsp = 1
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop'],
\}

let g:ale_fixers = {
\   'ruby': ['rubocop'],
\}

nmap <silent> <Up> <Plug>(ale_previous_wrap)
nmap <silent> <Down> <Plug>(ale_next_wrap)

command! GoDocLink exe '!chromium ' . substitute(substitute(getline('.'), '.*(', '', ''), ').*', '', '')

inoremap <M-;> ::
nnoremap <leader>z /#\d<CR>y$ggi[]<esc>PA<space>

augroup expand_tab
		autocmd!
		autocmd FileType cucumber set expandtab | set tabstop=2 | set shiftwidth=2
augroup END

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

nnoremap <silent> g<tab> :bnext<cr>
nnoremap <silent> g\ :bprev<cr>

function! BufferSplit()
	let g:current_buffer = escape(substitute(bufname(), $HOME, '~', ''), '~/')
	exec winheight(0)/5."split /tmp/buffers"
	setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile ignorecase smartcase cursorline nonumber norelativenumber
	let @o = execute('ls')
	silent put o
	silent call deletebufline('%', 1, 2)
	silent exe '%s/"//g'
	setlocal nomodifiable nomodified
	exe 'resize ' line('$')
	set laststatus=0
	call search(g:current_buffer)
	norm! 0
	nnoremap <buffer><silent> <ESC> :set laststatus=2 \| :q<CR>
	nnoremap <buffer><silent> l :call OpenUp()<cr>
	nnoremap <buffer><silent> dd :call DeleteBuf()<cr>
endfunction

nnoremap <silent> gb :call BufferSplit()<cr>

function! OpenUp()
	let l:command = "b " . split(getline("."))[0]
	wincmd k
	exe l:command
endfunction

function! DeleteBuf()
	setlocal modifiable
	exe "bd " . split(getline('.'))[0]
	call deletebufline('%', line('.'))
	setlocal nomodifiable
endfunction

