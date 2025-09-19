-- Linting/formatting tools
local lint_and_format = {
	--linters
	"pylint",
	"revive",
	"stylelint",
	"yamllint",
	"eslint_d",
	--formatters
	"black",
	"csharpier",
	"prettierd",
	"stylua",
	"yamlfmt",
}

-- LSP servers
local lsp_servers = {
	"lua_ls",
	"html",
	"ts_ls",
	"pyright",
	"bashls",
	"jsonls",
	"gopls",
	"yamlls",
	"emmet_ls",
	"taplo",
	"terraformls",
	"csharp_ls",
}

-- Mason setup
require("mason").setup({
	ui = {
		border = "none",
		icons = {
			package_installed = "✓",
			package_pending = "⏳",
			package_uninstalled = "✗",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
})

-- Mason-null-ls
require("mason-null-ls").setup({
	ensure_installed = lint_and_format,
	automatic_installation = true,
})

-- Mason-lspconfig
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
	automatic_installation = true,
	automatic_enable = false,
})

-- Setup LSP servers using the new vim.lsp.config API
local lspconfig_status_ok, lspconfig = pcall(require, "vim.lsp.config")
if not lspconfig_status_ok then
	return
end

local default_opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

for _, server in ipairs(lsp_servers) do
	server = vim.split(server, "@")[1]

	local ok, server_opts = pcall(require, "user.lsp.settings." .. server)
	if ok then
		default_opts = vim.tbl_deep_extend("force", default_opts, server_opts)
	end

	lspconfig[server].setup(default_opts)
end
