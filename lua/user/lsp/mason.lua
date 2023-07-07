local servers = {
	"lua_ls",
	"html",
	"tsserver",
	"pyright",
	"bashls",
	"jsonls",
	"elixirls",
	"gopls",
	"rust_analyzer",
	"yamlls",
	"omnisharp",
	"solargraph",
	"emmet_ls",
}

-- Mason doesn't support perl PLS language server. So I'm directly adding it here. Also
-- install perl PLS through CPAN module
-- If you need to add
local non_mason_servers = {
	"perlpls",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end

local nm_opts = {}

for _, server in pairs(non_mason_servers) do
	nm_opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, nm_opts)
	end

	lspconfig[server].setup(nm_opts)
end
