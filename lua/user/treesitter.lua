-- Configure nvim-treesitter (main branch rewrite, Neovim 0.11+)

local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
	return
end

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Install a small baseline of essential parsers upfront
local baseline = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
treesitter.install(baseline)

-- Filetypes where treesitter indentation is known to be broken
local indent_disabled = { yaml = true, html = true }

---Attach treesitter features (highlighting, folding, indentation) to a buffer.
---If the parser .so is missing (stale queries), force-reinstall once.
---@param buf integer
---@param language string
---@param retried boolean?
local function try_attach(buf, language, retried)
	if not vim.treesitter.language.add(language) then
		-- .so missing despite queries existing — force a reinstall once
		if not retried and vim.tbl_contains(treesitter.get_available(), language) then
			treesitter.install(language, { force = true }):await(function()
				try_attach(buf, language, true)
			end)
		end
		return
	end

	vim.treesitter.start(buf, language)

	vim.wo[0][0].foldexpr  = "v:lua.vim.treesitter.foldexpr()"
	vim.wo[0][0].foldmethod = "expr"
	vim.wo[0][0].foldlevel  = 99

	if not indent_disabled[vim.bo[buf].filetype] then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local available_parsers = treesitter.get_available()

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then return end

		local installed = treesitter.get_installed("parsers")

		if vim.tbl_contains(installed, language) then
			try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- auto-install then attach
			treesitter.install(language):await(function() try_attach(buf, language) end)
		else
			-- parser may exist outside nvim-treesitter (e.g. bundled by Neovim)
			try_attach(buf, language)
		end
	end,
})
