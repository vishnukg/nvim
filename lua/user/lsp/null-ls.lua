local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local completion = null_ls.builtins.completion
-- LspFormatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- This is where you add more formatters. If you want to add a formatter, first install the binary (Ex. stylua or black)
-- to the system and then setup it up here so null-ls can use it behind the scenes.
-- Behind the scenes its uses lua vim.lsp.buf.format to autoformat

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.goimports,
		formatting.terraform_fmt,
		formatting.rubocop,
		formatting.csharpier,
		diagnostics.golangci_lint,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})

-- Auto formatting on save
-- vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({async = true})]])
