return {
	init_options = {
		preferences = {
			disableSuggestions = false,
			includeCompletionsForModuleExports = true,
			includeCompletionsWithInsertText = true,
		},
		inlayHints = {
			includeInlayParameterNameHints = "all", -- or "none", "literals"
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
}
