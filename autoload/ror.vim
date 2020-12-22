if exists('g:loaded_ruby_func')
  finish
endif
let g:loaded_ruby_func = 1

function! ror#relations_jump_singular(symbol)
	return join(map(split(a:symbol, "_"), 'toupper(v:val[0]) . v:val[1:col("$")]'), "")
endfunction

function! ror#relations_jump_plural(symbol)
	return ror#relations_jump_singular(a:symbol[0:len(a:symbol)-2])
endfunction

function! ror#go_to_partial()
	if stridx(expand("<cWORD>"), "/") != -1
		call ror#go_to_partial2()
	else
		let l:word = expand("<cword>")
		exe "e " . expand('%:p:h') . "/_" . l:word . ".html.erb"
	endif
endfunction

function! ror#go_to_partial2()
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

