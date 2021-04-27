Native LSP, code actions don't work with c#
lua << EOF
local lsp = require('nvim_lsp')

local attach = function()
	require'completion'.on_attach()
	require'diagnostic'.on_attach()
end

lsp.tsserver.setup {
	on_attach=attach,
}
lsp.omnisharp.setup {
	on_attach=attach,
}

EOF

nnoremap <silent> <leader>aD 	<cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>ad 	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>k 	<cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ai  <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>j 	<cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>at  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>ar  <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>as  <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>aw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>f 	<cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>aa 	<cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rm 	<cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>ak 	<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

set completeopt=menuone,noinsert
set shortmess+=c

let g:completion_enable_auto_popup = 1
let g:completion_enable_snippet = 'vim-vsnip'

let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
			\ "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" : "\<CR>"

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_auto_popup_while_jump = 0

let g:vsnip_snippet_dir='~/.config/nvim/snippets/'

imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
imap <c-k> <S-Tab>
smap <c-k> <S-Tab>

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

imap <silent> <c-space> <Plug>(completion_trigger)

nnoremap <silent> <leader>an :NextDiagnosticCycle<CR>
nnoremap <silent> <leader>ap :PrevDiagnosticCycle<CR>

function! ToggleDiagType()
	w
	if g:diagnostic_enable_virtual_text == 0
		let g:diagnostic_enable_virtual_text = 1
		let g:diagnostic_auto_popup_while_jump = 0
	else
		let g:diagnostic_enable_virtual_text = 0
		let g:diagnostic_auto_popup_while_jump = 1
	endif
	e
endfunction

command! ToggleVirtualText call ToggleDiagType()
nnoremap <silent> <leader>se :call ToggleDiagType()<CR>

let g:python3_host_prog = 'C:\Python38\python.exe'
