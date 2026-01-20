-- Configure nvim-treesitter
-- Following official docs: https://github.com/nvim-treesitter/nvim-treesitter

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
		"bash",
		"c",
		"c_sharp",
		"css",
		"diff",
		"go",
		"hcl",
		"html",
		"http",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"perl",
		"python",
		"rust",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"xml",
		"yaml",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "yaml", "html" },
	},
})

-- Enable treesitter folding
local augroup = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldlevel = 99
	end,
})
