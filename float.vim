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

