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
		let l:word = substitute(expand('<cWORD>'), '"\|,\|)\|(', '', 'g')
		let l:word = substitute(expand(l:word), '.*\zs/', '/_', 'g')
		exe "e app/views/" .  l:word . ".html.erb"
	else
		let l:word = expand("<cword>")
		exe "e " . expand('%:p:h') . "/_" . l:word . ".html.erb"
	endif
endfunction

