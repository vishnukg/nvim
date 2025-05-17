local servers = {
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
    "clangd",
    "omnisharp",
}

local mason_settings = {
    ui = {
        border = "none",
        icons = {
            package_installed = "✓", -- Checkmark for installed
            package_pending = "⏳", -- Hourglass for pending/installing
            package_uninstalled = "✗", -- Crossmark for uninstalled
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

require("mason").setup(mason_settings)

local mason_lspconfig_settings = {
    ensure_installed = servers,
    automatic_installation = true,
}
require("mason-lspconfig").setup(mason_lspconfig_settings)

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    vim.notify("lspconfig not found!", vim.log.levels.ERROR)
    return
end

local handlers = require("user.lsp.handlers")

for _, server in ipairs(servers) do
    local server_name = vim.split(server, "@")[1]
    local opts = {
        on_attach = handlers.on_attach,
        capabilities = handlers.capabilities,
        settings = {
            [server_name] = {},
        },
    }

    local config_module_name = "user.lsp.settings." .. server_name
    local require_ok, conf_opts = pcall(require, config_module_name)
    if require_ok then
        opts.settings[server_name] = vim.tbl_deep_extend("force", opts.settings[server_name] or {}, conf_opts or {})
    end

    lspconfig[server_name].setup(opts)
end
