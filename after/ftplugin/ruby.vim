if exists("g:loaded_ruby_config")
  finish
endif
let g:loaded_ruby_config = 1

let g:ruby_indent_access_modifier_style=""

command! Rspec1 call TmuxSendLine("bundle exec spring rspec " . expand("%") . ":" . line("."))
command! RspecB call TmuxSendLine("bundle exec spring rspec " . expand("%")) 
command! RR exe "silent !chromium 'http://api.rubyonrails.org/?q='" . expand("<cword>")
command! RB exe "silent !chromium 'http://rubydoc.info/search/stdlib/core?q='" . expand("<cword>")
command! -nargs=1 -complete=custom,ror#model_complete Scm call ror#schema_search(<f-args>)

nnoremap <leader>4 :Rspec1<CR>
nnoremap <leader>5 :RspecB<CR>
nnoremap <leader>] :exe "tag " . ror#relations_jump_singular(expand("<cword>"))<CR>
nnoremap <leader>[ :exe "tag " . ror#relations_jump_plural(expand("<cword>"))<CR>
nnoremap <leader>' :call ror#go_to_partial()<CR>
nnoremap <leader>} :call ror#scope_jump()<CR>
nnoremap <silent> K :silent call ror#ri_docs(expand('<cword>'))<CR>
