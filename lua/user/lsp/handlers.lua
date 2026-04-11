local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	-- Enable codelens globally. The capability system automatically activates it
	-- only for clients that advertise codeLensProvider, so no per-buffer guard
	-- is needed. Doing this in setup() avoids a timing issue where enabling
	-- per-buffer inside on_attach could miss the attaching client.
	vim.lsp.codelens.enable(true)

	vim.diagnostic.config({
		virtual_text = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			source = true,
			header = "",
			prefix = "",
		},
	})
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- 0.12 built-in defaults (no explicit mapping needed):
	--   K        → hover documentation
	--   gra      → code actions
	--   grn      → rename symbol
	--   grr      → show references
	--   gri      → go to implementation
	--   grt      → go to type definition
	--   grl      → run codelens
	--   gO       → list document symbols
	--   <C-S>    → signature help (insert + select mode)

	-- Custom mappings (no 0.12 built-in equivalent)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "grl", vim.lsp.codelens.run, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "gch", vim.lsp.buf.incoming_calls, opts)
	vim.keymap.set("n", "gth", function() vim.lsp.buf.typehierarchy("supertypes") end, opts)
	vim.keymap.set("n", "gtH", function() vim.lsp.buf.typehierarchy("subtypes") end, opts)
	vim.keymap.set("n", "<leader>fo", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<CR>", opts)
	vim.keymap.set("n", "<leader>lI", "<cmd>Mason<CR>", opts)
	vim.keymap.set("n", "<leader>lj", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, opts)
	vim.keymap.set("n", "<leader>lk", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, opts)
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

	lsp_keymaps(bufnr)
end

return M
