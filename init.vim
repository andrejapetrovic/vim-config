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
	Plug 'ap/vim-buftabline'
call plug#end()

filetype plugin on
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
set expandtab
set noswapfile
set nobackup
set nowritebackup
set hidden

set background=dark
colorscheme hybrid

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

nnoremap Y y$
nnoremap gb :ls<CR>:b<Space>
nnoremap <silent> <c-k> :bnext<CR>
nnoremap <silent> <c-j> :bprevious<CR>
nnoremap <leader>d <c-^>
nnoremap <CR> <c-^>
nnoremap <leader>n *
nnoremap <leader>N #
" nnoremap <silent> <leader>; :call setline('.', getline('.') . ';')<CR>
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

command! -nargs=1 -complete=custom,TmuxTargets TmuxTargetPane :let g:tmux_target_pane=<f-args>

function! TmuxTargets(A,L,P)
	return "{right-of}\n{left-of}\n{down-of}\n{up-of}\n{last}\n{next}\n{previous}\n{top}\n{bottom}\n{left}\n{right}\
				\n{top-left}\n{top-right}\n{bottom-left}\n{bottom-right}"
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

nnoremap =ap mm=ap`m
nnoremap =ip mm=ip`m
vnoremap = mm=`m

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

augroup makeprgs
    autocmd!
    autocmd Filetype c set makeprg=gcc\ -o\ %<\ %\ &&\ ./%:r
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
    call setline('.', AddIndent(GetIndent('.')) . l:line[len(a:pattern[0]):-len(a:pattern[1])-1])
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
			if !IsCommented(l:current_line, a:pattern)
			else
				call setline(l:current, AddIndent(GetIndent(l:current)) . l:current_line[len(a:pattern[0]):-len(a:pattern[1])-1])
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
nnoremap <leader>su :Sur 

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
	exe "'<,'>Shdo mv {} {}"
	%s/\(.\{-}\zs\'\)\{2}\zs/\/
	silent! %!column -t -s '\/'
endfunction

vnoremap <leader>r :s/\%V

function! Column(del, del_end)
	exe "'<,'>s/\\%V" . a:del . "\\zs//g"
	silent exe "'<,'>s/\\%V" . a:del_end . "/" . a:del_end
	silent exe "'<,'>!column -t -s '' -o ' '"
	silent exe "'<,'>s/\\%V" . a:del . "\\zs\\s\\{2}/ /g"
	silent exe "'<,'>s/\\%V\\s" . a:del_end . "/" . a:del_end
endfunction

command! -range -nargs=* LineUp call Column(<f-args>)

nnoremap <leader>ell :exe "lua " . getline('.')<CR>
nnoremap <leader>elp :exe "lua " . join(GetParagraph(), '')<CR>
vnoremap <leader>l <esc>:<c-u>exe "lua " . join(GetVisual(), '')<CR>

let g:buftabline_separators = 1
let g:buftabline_show = 1

source $HOME/.config/nvim/float.vim
