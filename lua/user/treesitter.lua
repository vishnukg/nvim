-- Enable treesitter-based highlighting for all filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Enable treesitter-based indentation (experimental)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype ~= "yaml" and vim.bo.filetype ~= "html" then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
