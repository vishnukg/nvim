return {
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			procMacro = {
				enable = true,
			},
			diagnostics = {
				enable = true,
			},
			assist = {
				importEnforceGranularity = true,
				importPrefix = "crate",
			},
			cargo = {
				allFeatures = true,
				buildScripts = {
					enable = true,
				},
			},
			checkOnSave = {
				-- default: `cargo check`
				command = "clippy",
			},
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true,
				},
			},
		},
	},
}
