Guifont! Cascadia Code:h10
GuiPopupmenu 0

function! ResizeFont(num)
	let l:size = strpart(split(g:GuiFont, ':')[1], 1) + a:num
	execute "Guifont! Cascadia Code:h" . l:size 
endfunction

nnoremap <silent> <c-=> :call ResizeFont(1)<CR>
nnoremap <silent> <c--> :call ResizeFont(-1)<CR>
nnoremap <silent> <c-0> :GuiFont! Cascadia Code:h13<CR>

