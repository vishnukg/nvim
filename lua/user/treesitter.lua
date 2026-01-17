-- Configure nvim-treesitter (rewrite version)
-- Following official docs: https://github.com/nvim-treesitter/nvim-treesitter

local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

-- Install parsers asynchronously (no-op if already installed)
treesitter.install({
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
})

-- Filetypes to enable treesitter for
local enabled_filetypes = {
	"bash",
	"c",
	"cpp",
	"cs",
	"css",
	"diff",
	"go",
	"hcl",
	"html",
	"http",
	"javascript",
	"javascriptreact",
	"json",
	"lua",
	"markdown",
	"perl",
	"python",
	"rust",
	"sh",
	"terraform",
	"toml",
	"typescript",
	"typescriptreact",
	"vim",
	"xml",
	"yaml",
}

local augroup = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })

-- Enable treesitter highlighting (per docs)
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = enabled_filetypes,
	callback = function()
		vim.treesitter.start()
	end,
})

-- Enable treesitter folding (per docs)
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = enabled_filetypes,
	callback = function()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldlevel = 99
	end,
})

-- Enable treesitter indentation (experimental, per docs)
-- Skip yaml and html as they work better with default indentation
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = vim.tbl_filter(function(ft)
		return ft ~= "yaml" and ft ~= "html"
	end, enabled_filetypes),
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
