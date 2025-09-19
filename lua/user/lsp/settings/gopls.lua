-- user/lsp/settings/gopls.lua
return {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
				useany = true,
			},
			staticcheck = true, -- enables extra checks from staticcheck
			gofumpt = true, -- use stricter formatting
		},
	},
}
