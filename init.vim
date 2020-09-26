call plug#begin('~\AppData\Local\nvim\plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neoclide/jsonc.vim', {'for': 'json'}
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/gv.vim'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-eunuch'
	Plug 'jpalardy/vim-slime'
	Plug 'honza/vim-snippets'
	Plug 'norcalli/nvim-colorizer.lua'
	Plug 'jiangmiao/auto-pairs'
	" Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install', 'for': 'markdown'}
	Plug 'lambdalisue/fern.vim'
	Plug 'MaxMEllon/vim-jsx-pretty'
	Plug 'yuezk/vim-js'
call plug#end()

set mouse=a
set relativenumber number
set updatetime=0
set signcolumn=yes
set clipboard=unnamedplus
set termguicolors
set nohlsearch
set inccommand=nosplit
set pumheight=15
set splitright
set splitbelow
set colorcolumn=80
set tabstop=4
set shiftwidth=4
" set expandtab
set noswapfile
set nobackup
set nowritebackup
set hidden
set textwidth=80

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

" command! Sourceconf source ~/.config/nvim/init.vim

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
nnoremap <leader>ss :mks! ~/.local/share/sess/
nnoremap <leader>sa :w<CR>
nnoremap <leader>sl :w<CR>
nnoremap <leader>sq :wq<CR>
nnoremap <leader>sd :cd %:p:h<CR>
nnoremap <leader>se :Lex<CR>
nnoremap <leader>st :%s/\s\+$//e<CR>
nnoremap <leader>tt :term<CR>
nnoremap <leader>ts :sp \| term<CR>
nnoremap <leader>tv :vsp \| term<CR>

" windows
nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l
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
nnoremap <leader>rs :Fern . -reveal=% -opener=split<CR>
nnoremap <leader>rv :Fern . -reveal=% -opener=vsplit<CR>

" coc
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-l> coc#refresh()
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev) :call repeat#set("\<Plug>(coc-diagnostic-prev)")<CR>
nmap <silent> ]g <Plug>(coc-diagnostic-next) :call repeat#set("\<Plug>(coc-diagnostic-prev)")<CR>

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gt <Plug>(coc-type-definition)
nmap <silent> <leader>gl <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

nmap <leader>rl <Plug>(coc-rename)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup coc_format
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap keys for applying codeAction to the current line.
nmap <leader>aa  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

" git
nmap <silent> <leader>gp <Plug>(coc-git-prevchunk) :call repeat#set("\<Plug>(coc-git-prevchunk)")<CR>
nmap <silent> <leader>gn <Plug>(coc-git-nextchunk) :call repeat#set("\<Plug>(coc-git-nextchunk)")<CR>
" show chunk diff at current position
nmap <leader>gi <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap <leader>gc <Plug>(coc-git-commit)
" undo change
nmap <leader>gu :CocCommand git.chunkUndo<CR>
nmap <leader>gs :CocCommand git.chunkStage<CR>
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

"explorer
" nmap <leader>re :CocCommand explorer<CR>
" end coc

" term buffer
augroup custom_term
	autocmd!
	autocmd TermOpen *
				\ setlocal bufhidden=hide
				\ | norm! a
augroup END

let g:slime_target = "tmux"
let g:slime_no_mappings = 1
xmap <M-r> <Plug>SlimeRegionSend
nmap <M-r> <Plug>SlimeParagraphSend
imap <M-r> <ESC><Plug>SlimeParagraphSend
nmap <silent> <M-e> :SlimeSend<CR>
imap <silent> <M-e> <ESC>:SlimeSend<CR>
nmap <silent> <M-E> mmggVG:SlimeSend<CR>`m
nmap <leader>sc <Plug>SlimeConfig
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

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
vnoremap <leader>e "sy:@s<CR>
nnoremap <leader>ee :exe getline(".")<CR>
nnoremap <leader>ep ms"syip:@s<CR>
nnoremap <leader>ef k/^endfunction<CR>V?^function<CR>"sy:@s<CR>
nnoremap <leader>ei :exe getline(".") \| PlugInstall<CR>

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
		nnoremap <buffer><silent> <CR> :execute "cd" . getline(".") "\| Fern ."<CR>
		nnoremap <buffer><silent> <leader>p :execute "cd" . getline(".") "\| Fzfp"<CR>
		nnoremap <buffer><silent> <c-s> :execute "source" . getline(".")<CR>
endfunction

command! StartScreen call Start()
autocmd! VimEnter * call Start()
autocmd! VimResized * call ResizeFZF()

function! ResizeFZF()
	if winwidth(0) < 100
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

function! ResizeFont(num)
	let l:size = strpart(split(g:GuiFont, ':')[1], 1) + a:num
	execute "Guifont! Cascadia Code:h" . l:size 
endfunction

nnoremap <silent> <c-=> :call ResizeFont(1)<CR>
nnoremap <silent> <c--> :call ResizeFont(-1)<CR>
nnoremap <silent> <c-0> :GuiFont! Cascadia Code:h13<CR>

