-- Configure nvim-treesitter
-- Following official docs: https://github.com/nvim-treesitter/nvim-treesitter
-- Using the new rewrite from main branch (requires Neovim 0.11.0+)

local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

-- Optional setup (not required for defaults)
treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- List of parsers to install
local parsers_to_install = {
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
}

-- Check if parser is installed
local function is_parser_installed(lang)
	local parser_path = vim.fn.stdpath("data") .. "/site/parser/" .. lang .. ".so"
	return vim.fn.filereadable(parser_path) == 1
end

-- Install missing parsers automatically
vim.schedule(function()
	local missing = {}
	for _, lang in ipairs(parsers_to_install) do
		if not is_parser_installed(lang) then
			table.insert(missing, lang)
		end
	end
	if #missing > 0 then
		treesitter.install(missing)
	end
end)

-- Filetypes that correspond to our installed parsers
local supported_filetypes = {
	"bash",
	"sh",
	"c",
	"cs",
	"css",
	"diff",
	"go",
	"hcl",
	"terraform",
	"html",
	"http",
	"javascript",
	"json",
	"lua",
	"markdown",
	"perl",
	"python",
	"rust",
	"toml",
	"tsx",
	"typescriptreact",
	"typescript",
	"vim",
	"xml",
	"yaml",
}

-- Enable treesitter highlighting for supported filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = supported_filetypes,
	callback = function()
		vim.treesitter.start()
	end,
})

-- Enable treesitter folding
local augroup = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = supported_filetypes,
	callback = function()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldlevel = 99
	end,
})

-- Enable treesitter indentation for most filetypes (experimental)
vim.api.nvim_create_autocmd("FileType", {
	pattern = supported_filetypes,
	callback = function()
		local disabled_indent = { "yaml", "html" }
		local filetype = vim.bo.filetype
		if not vim.tbl_contains(disabled_indent, filetype) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
