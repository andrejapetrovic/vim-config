function! Float()
	let current_buffer = expand('%')
	let buf = nvim_create_buf(v:true, v:true)
	if &columns < 110
		let width = float2nr(&columns * 0.7)
	else
		let width = float2nr(&columns * 0.35)
	endif
	let height = 30
	let y = &lines - height - 10
	let x = float2nr((&columns - width) * 0.5)
	let opts = { 'relative': 'editor', 'row': y, 'col': x, 'width': width, 'height': height, 'style': 'minimal'}
	silent call nvim_open_win(buf, v:true, opts)
	return current_buffer
endfunction

function! BufferWindow(content)
	let g:current_buffer = escape(substitute(Float(), $HOME, '~', ''), '~/')
	let @o = a:content
	silent put o
	setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile ignorecase smartcase cursorline
	silent call deletebufline('%', 1, 2)
	silent exe '%s/"\s.*//'
	silent exe '%s/"//'
	silent exe '%s/\d\+\zs\s\+\S\+//'
	call search(g:current_buffer)
	setlocal nomodifiable nomodified
	norm! 0
	nnoremap <buffer><silent> <ESC> :q<CR>
	nnoremap <buffer><silent> <CR> :call BuffSplit(getline("."), 'e')<CR>
	nnoremap <buffer><silent> l :call BuffSplit(getline("."), 'e')<CR>
	nnoremap <buffer><silent> <leader>l :call BuffSplit(getline("."), 'vs')<CR>
	nnoremap <buffer><silent> <leader>h :call BuffSplit(getline("."), 'vertical leftabove split')<CR>
	nnoremap <buffer><silent> <leader>j :call BuffSplit(getline("."), 'sp')<CR>
	nnoremap <buffer><silent> <leader>k :call BuffSplit(getline("."), 'leftabove split')<CR>
	nnoremap <buffer><silent> <leader>tt :call BuffSplit(getline("."), 'tabnew')<CR>
	nnoremap <buffer><silent> <c-r> :call BuffWinDelete(' ')<CR>
	nnoremap <buffer><silent> R :call BuffWinDelete('! ')<CR>
	cnoremap <buffer> <c-o> <c-m>:norm l<CR>
	nmap <buffer> i l
	nnoremap <buffer> s /
endfunction

function! BuffSplit(line, split_name)
	let l:splitted_line = split(a:line, '')
	let l:start_idx = l:splitted_line[1] == '+' ? 2 : 1
	q
	execute a:split_name . ' ' . join(l:splitted_line[l:start_idx:], ' ')
endfunction

function! BuffWinDelete(bang)
	setlocal modifiable
	norm! 0
	" let l:line = trim(getline('.'))
	let l:line = expand('<cword>')
	try
		exe 'bd' . a:bang . l:line
		call deletebufline('%', line('.'), line('.'))
	catch
		echoerr "Buffer currently opened"
	finally
		setlocal nomodifiable
	endtry
endfunction

nnoremap <silent> <leader>l :call BufferWindow(execute('ls'))<CR>

