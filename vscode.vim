call plug#begin('~/.config/nvim/plugged')
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-eunuch'
	Plug 'lambdalisue/fern.vim'
call plug#end()

set updatetime=100
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

map <Space> <Nop>
let mapleader = " "

cabbrev Q q
cabbrev W w
cabbrev Wq wq

" autocmd! VimLeave * set guicursor=a:ver25-blinkon0

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

" hotkeys
nnoremap <c-q> <c-a>

nnoremap gb :ls<CR>:b
nnoremap <silent> <c-k> :bnext<CR>
nnoremap <silent> <c-j> :bprevious<CR>
nnoremap <leader>d <c-^>
nnoremap <leader>n *
nnoremap <leader>m #
nnoremap <leader>; :call setline('.', getline('.') . ';')<CR>
nnoremap <leader>b gea
nnoremap <leader>B gEa

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
nnoremap <leader>re :Fern . -drawer -reveal=% -toggle -width=41<CR>
nnoremap <leader>rr :Fern . -reveal=% -opener=edit<CR>
nnoremap <leader>rj :Fern . -reveal=% -opener=split<CR>
nnoremap <leader>rk :Fern . -reveal=% -opener=leftabove\ split<CR>
nnoremap <leader>rl :Fern . -reveal=% -opener=vsplit<CR>
nnoremap <leader>rh :Fern . -reveal=% -opener=leftabove\ vsplit<CR>
nnoremap <leader>rJ :Fern . -reveal=% -opener=botright\ split<CR>
nnoremap <leader>rK :Fern . -reveal=% -opener=topleft\ split<CR>
nnoremap <leader>rL :Fern . -reveal=% -opener=botright\ vsplit<CR>
nnoremap <leader>rH :Fern . -reveal=% -opener=topleft\ vsplit<CR>

" term buffer
augroup custom_term
	autocmd!
	autocmd TermOpen *
				\ setlocal bufhidden=hide
				\ | norm! a
augroup END

"comments
autocmd! FileType typescript,c setlocal commentstring=//\ %s

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

set wildignore+=*node_modules/**,*bin/**,*build/**,*obj**
