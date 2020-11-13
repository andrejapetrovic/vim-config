function setup()
	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {                       
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			}
		},
		refactor = {
			smart_rename = {
				enable = true,
				smart_rename = "grr"
			},
			highlight_definitions = {
				enable = true,
			},
			highlight_current_scope = {
				enable = false
			},
			navigation = {
				enable = true,
				goto_definition = "gnd",
				list_definitions = "gnD"
			},
			textobjects = {
				enable = false
			}
		}
	}

	-- require "nvim-treesitter.highlight"
	-- vim.treesitter.highlighter.hl_map.error = nil

	-- local hlmap = vim.treesitter.TSHighlighter.hl_map
	-- hlmap["variable.builtin"] = "TSVariableBuiltin"
end

return setup()
