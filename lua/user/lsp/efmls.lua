-- Register linters and formatters per language
-- This is where you add more formatters and linters. If you want to add a formatter, first install the binary (Ex. stylua or black)
local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")

local stylua = require("efmls-configs.formatters.stylua")

local golangci_lint = require("efmls-configs.linters.golangci_lint")
local goimports = require("efmls-configs.formatters.goimports")

local black = require("efmls-configs.formatters.black")
local flake8 = require("efmls-configs.linters.flake8")

local stylelint = require("efmls-configs.linters.stylelint")

local yamllint = require("efmls-configs.linters.yamllint")

local languages = {
	javascript = { eslint, prettier },
	jsx = { eslint, prettier },
	typescript = { eslint, prettier },
	tsx = { eslint, prettier },
	lua = { stylua },
	go = { golangci_lint, goimports },
	python = { flake8, black },
	html = { prettier },
	css = { stylelint, prettier },
	scss = { stylelint, prettier },
	less = { stylelint, prettier },
	sass = { stylelint, prettier },
	json = { prettier },
	yaml = { yamllint },
	markdown = { prettier },
}

-- Or use the defaults provided by this plugin
-- check doc/SUPPORTED_LIST.md for the supported languages
--
-- local languages = require("efmls-configs.defaults").languages()

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
}

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
	-- Pass your custom lsp config below like on_attach and capabilities
	--
	on_attach = require("lsp-format").on_attach,
	-- capabilities = capabilities,
	-- on_attach = function(client, bufnr)
	-- 	if client.supports_method("textDocument/formatting") then
	-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			group = augroup,
	-- 			buffer = bufnr,
	-- 			callback = function()
	-- 				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
	-- 				vim.lsp.buf.format({ async = false })
	-- 			end,
	-- 		})
	-- 	end
	-- end,
}))
