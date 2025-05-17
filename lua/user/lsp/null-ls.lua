local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

-- Built-in sources
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Autoformat on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true }) -- Added 'clear = true'

null_ls.setup({
    debug = false,
    sources = {
        -- Formatters
        formatting.prettier.with({ disabled_filetypes = { "yaml" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua,
        formatting.goimports,
        formatting.terraform_fmt,
        formatting.csharpier,
        formatting.yamlfmt,
        formatting.clang_format,
        -- Diagnostics
        diagnostics.revive,
        diagnostics.yamllint,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false, bufnr = bufnr }) -- Explicit bufnr
                end,
            })
        end
    end,
})
