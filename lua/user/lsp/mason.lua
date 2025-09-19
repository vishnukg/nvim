-- =========================
-- Linting/Formatting Tools
-- =========================
local lint_and_format = {
	-- Linters
	"pylint",
	"revive",
	"stylelint",
	"yamllint",
	"eslint_d",
	-- Formatters
	"black",
	"csharpier",
	"prettierd",
	"stylua",
	"yamlfmt",
}

-- =========================
-- LSP Servers
-- =========================
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

-- =========================
-- Mason Setup
-- =========================
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

-- =========================
-- Mason-null-ls Setup
-- =========================
require("mason-null-ls").setup({
	ensure_installed = lint_and_format,
	automatic_installation = true,
})

-- =========================
-- Mason-lspconfig Setup
-- =========================
require("mason-lspconfig").setup({
	ensure_installed = lsp_servers,
	automatic_installation = true,
	automatic_enable = false,
})

-- =========================
-- LSP Servers Setup (new API)
-- =========================
for _, server in ipairs(lsp_servers) do
	server = vim.split(server, "@")[1]

	-- Base options
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	-- Merge server-specific settings if available
	local ok, server_opts = pcall(require, "user.lsp.settings." .. server)
	if ok then
		opts = vim.tbl_deep_extend("force", opts, server_opts)
	end

	-- Register server config (instead of lspconfig[server].setup)
	vim.lsp.config(server, opts)

	-- Enable it (activates based on filetype)
	vim.lsp.enable(server)
end
