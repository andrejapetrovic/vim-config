function setup()
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
end

return setup()
