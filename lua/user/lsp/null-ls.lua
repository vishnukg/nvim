local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- This is where you add more formatters. If you want to add a formatter, first install the binary (Ex. stylua or black)
-- to the system and then setup it up here so null-ls can use it behind the scenes.
-- Behind the scenes its uses lua vim.lsp.buf.format to autoformat

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.gofmt,
		formatting.rustfmt,
		formatting.csharpier,
		diagnostics.flake8,
		diagnostics.golangci_lint,
	},
})

-- Auto formatting on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({async = true})]])
