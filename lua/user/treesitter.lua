-- Configure nvim-treesitter
-- Following official docs: https://github.com/nvim-treesitter/nvim-treesitter

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

-- Install parsers automatically (safe for new machines)
local install_ok, install_fn = pcall(function()
	return treesitter.install
end)

if install_ok and install_fn then
	-- New API available (nvim-treesitter rewrite)
	vim.schedule(function()
		treesitter.install(parsers_to_install)
	end)
else
	-- Fallback: Create command to install all parsers
	vim.api.nvim_create_user_command("TSInstallAll", function()
		vim.cmd("TSInstall " .. table.concat(parsers_to_install, " "))
	end, {})
	
	-- Auto-run on first launch if parsers are missing
	vim.schedule(function()
		local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
		if vim.fn.isdirectory(parser_dir) == 0 or vim.fn.empty(vim.fn.glob(parser_dir .. "/*.so")) == 1 then
			vim.cmd("TSInstallAll")
		end
	end)
end

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
