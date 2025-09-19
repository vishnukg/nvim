-- user/lsp/settings/lua_ls.lua
return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files for better completion
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Avoid diagnosing luarocks libraries
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
