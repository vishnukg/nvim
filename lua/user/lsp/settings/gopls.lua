-- user/lsp/settings/gopls.lua
return {
	settings = {
		gopls = {
			codelenses = {
				gc_details = true,        -- toggle gc optimisation details
				generate = true,          -- run go generate
				regenerate_cgo = true,    -- regenerate cgo definitions
				run_govulncheck = true,   -- run govulncheck
				test = true,              -- run go test for a specific test function
				tidy = true,              -- run go mod tidy
				upgrade_dependency = true,-- upgrade a dependency
				vendor = true,            -- run go mod vendor
			},
			analyses = {
				unusedparams = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
				useany = true,
			},
			staticcheck = true, -- enables extra checks from staticcheck
			gofumpt = true, -- use stricter formatting
			buildFlags = { "-tags=unitTests journeyTests" },
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
