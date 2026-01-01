-- user/lsp/settings/lua_ls.lua
return {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = { vim.env.VIMRUNTIME .. "/lua" },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}
