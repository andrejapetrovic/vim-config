if exists('g:loaded_ruby_func')
  finish
endif
let g:loaded_ruby_func = 1

function! ror#relations_jump_singular(symbol)
	return join(map(split(a:symbol, "_"), 'toupper(v:val[0]) . v:val[1:]'), "")
endfunction

function! ror#relations_jump_plural(symbol)
	let l:sym = ror#relations_jump_singular(a:symbol)
	if match(l:sym, 'ies$') != -1
		return l:sym[0:len(l:sym) - 4] . 'y'
	elseif match(l:sym, 's$') != -1
		return l:sym[0:len(l:sym) - 2]
	else
		echoerr "Can't convert plural to singular"
	endif
endfunction

function! ror#go_to_partial()
	if match(expand('<cword>'), 'render\|partial') != -1
		call search('"\|\''', '', line('.'))
	endif
	if stridx(expand("<cWORD>"), "/") != -1
		let l:word = substitute(expand('<cWORD>'), '"\|,\|)\|(\|\''', '', 'g')
		let l:word = substitute(l:word, '.*\zs/', '/_', '')
		exe "e app/views/" .  l:word . ".html.erb"
	else
		let l:word = expand("<cword>")
		exe "e " . expand('%:p:h') . "/_" . l:word . ".html.erb"
	endif
endfunction

function! ror#schema_search(table_name)
	e db/schema.rb
	call search('create_table "' . a:table_name . '"')
endfunction

function! ror#model_complete(ArgLead, CmdLine, CursorPos)
	let l:files = system('find app/models/** -type f | sed "s/.*\///"')
	let l:files = substitute(l:files, 'y.rb', 'ies', 'g')
	return substitute(l:files, '.rb', 's', 'g')
endfunction

function! ror#scope_jump() abort
	let l:s = split(expand('<cWORD>'), '\.')
	let l:method = substitute(l:s[1], '(.\+', '', '')
	exe 'tag ' . l:s[0]
	call search(l:method)
endfunction

function! ror#ri_docs(term) abort
	split /tmp/ri_docs
	exe 'r !bundle exec ri ' . a:term . ' --no-interactive --no-pager --format=rdoc'
	setlocal syntax=markdown
	norm! ggdd
	setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile ignorecase smartcase nomodifiable nomodified
	syntax clear markdownError
endfunction

