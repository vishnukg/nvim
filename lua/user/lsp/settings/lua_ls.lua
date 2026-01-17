-- user/lsp/settings/lua_ls.lua
return {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
				},
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}
