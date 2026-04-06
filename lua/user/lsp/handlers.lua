local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	vim.diagnostic.config({
		virtual_text = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN]  = "",
				[vim.diagnostic.severity.HINT]  = "",
				[vim.diagnostic.severity.INFO]  = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			source = "always",
			header = "",
			prefix = "",
		},
	})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- 0.12 built-in defaults (no explicit mapping needed, listed for reference):
	--   K        → hover documentation
	--   gra      → code actions
	--   grn      → rename symbol
	--   grr      → references
	--   gri      → implementations
	--   grt      → type definition
	--   grx      → run codelens
	--   gO       → document symbols
	--   <C-S>    → signature help (insert + select mode)

	-- Custom mappings (not covered by 0.12 built-ins, or overriding defaults)
	vim.keymap.set("n", "gd",  vim.lsp.buf.definition, opts)     -- go to definition (NOT a 0.12 built-in)
	vim.keymap.set("n", "gD",  vim.lsp.buf.declaration, opts)    -- go to declaration
	vim.keymap.set("n", "gI",  vim.lsp.buf.implementation, opts)  -- go to implementation
	vim.keymap.set("n", "gr",  vim.lsp.buf.references, opts)      -- go to references
	vim.keymap.set("n", "gca", vim.lsp.buf.code_action, opts)    -- code actions (prefer over built-in gra)
	vim.keymap.set("n", "gl",  vim.diagnostic.open_float, opts)  -- show diagnostic float
	vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
	vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", opts)
	vim.keymap.set("n", "<leader>lI", "<cmd>Mason<CR>", opts)
	vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
	vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
end

M.on_attach = function(client, bufnr)
	-- Sometimes the lsp for a particular language (Ex: tsserver) has
	-- its own formatting provider. The following statement disables
	-- the builtin formatter from the lsp for that language. We instead
	-- rely on the formatter provided by none-ls plugin
	if client.name == "ts_ls" or client.name == "lua_ls" or client.name == "gopls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- ruby_lsp handles format on save via its standard addon
	if client.name == "ruby_lsp" and client:supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
			end,
		})
	end

	-- Enable inlay hints if the server supports it
	if client.server_capabilities.inlayHintProvider and client.name ~= "csharp_ls" then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Enable codelens if the server supports it
	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end

	lsp_keymaps(bufnr)
end

return M
