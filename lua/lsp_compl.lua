function setup()
	local lsp = require('lspconfig')

	lsp.tsserver.setup {}
	lsp.omnisharp.setup { }
	lsp.gopls.setup {}

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false
	}
	)
end

return setup()
