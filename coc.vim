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
nmap <c-.>  <Plug>(coc-codeaction)
imap <c-.>  <Esc><Plug>(coc-codeaction)
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

nmap <leader>rm <Plug>(coc-rename)

"explorer
" nmap <leader>re :CocCommand explorer<CR>
" end coc
