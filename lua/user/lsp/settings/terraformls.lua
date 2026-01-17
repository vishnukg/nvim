return {
	terraform = {
		timeout = "30s",
	},
	validation = {
		enableEnhancedValidation = true,
	},
	experimentalFeatures = {
		validateOnSave = true,
		prefillRequiredFields = true,
	},
	indexing = {
		ignoreDirectoryNames = { ".terraform", ".git" },
	},
}
