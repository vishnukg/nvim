return {
	tools = {
		autoSetHints = true,
		hover_with_actions = true,
		inlay_hints = {
			show_parameter_hints = true,
			parameter_hints_prefix = "",
			other_hints_prefix = "",
		},
	},
	settings = {
		["rust-analyzer"] = {
			assist = {
				importEnforceGranularity = true,
				importPrefix = "crate",
			},
			cargo = {
				allFeatures = true,
			},
			checkOnSave = {
				-- default: `cargo check`
				command = "clippy",
			},
		},
		inlayHints = {
			lifetimeElisionHints = {
				enable = true,
				useParameterNames = true,
			},
		},
	},
}
