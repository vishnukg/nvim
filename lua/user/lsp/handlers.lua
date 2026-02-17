local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}
	local sign_texts = {}
	for _, sign in ipairs(signs) do
		sign_texts[sign.name] = sign.text
	end

	local config = {
		virtual_text = true, -- enable/disable virtual text
		signs = {
			active = sign_texts, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	-- ============================================================================
	-- WORKAROUND: Fix gopls package rename in Neovim 0.11.6
	-- Issue: https://github.com/neovim/neovim/issues/37724
	-- Fixed in: PR #37725 (merged to master, will be in v0.12 or v0.11.7+)
	-- TODO: Remove this entire block when upgrading to Neovim 0.11.7+ or 0.12+
	-- ============================================================================
	local original_fs_rm = vim.fs.rm
	---@diagnostic disable-next-line: duplicate-set-field
	vim.fs.rm = function(path, opts)
		opts = opts or {}
		-- Use lstat (not stat) to properly detect symlinks and directories
		-- This is the same fix as the official PR #37725
		local stat = vim.uv.fs_lstat(path)

		if stat and stat.type == "directory" then
			-- Recursively delete directory contents (safe for all LSPs)
			for name, _ in vim.fs.dir(path) do
				---@diagnostic disable-next-line: param-type-mismatch
				vim.fs.rm(vim.fs.joinpath(path, name), { recursive = true, force = opts.force })
			end
			-- Remove the now-empty directory
			local ok, err = vim.uv.fs_rmdir(path)
			if not ok and not opts.force then
				error(err)
			end
		elseif stat then
			-- For files, use original function (unchanged behavior)
			original_fs_rm(path, opts)
		elseif not opts.force then
			-- Path doesn't exist - let original handle the error
			original_fs_rm(path, opts)
		end
	end
	-- ============================================================================
	-- END WORKAROUND
	-- ============================================================================

	vim.lsp.handlers["textDocument/hover"] = function(_, result)
		-- Check if result exists and contains the necessary hover information
		if not result or not result.contents then
			return
		end

		-- Prepare content for hover preview
		local lines = {}
		if type(result.contents) == "table" then
			for _, item in ipairs(result.contents) do
				table.insert(lines, item.value or item)
			end
		else
			table.insert(lines, result.contents)
		end

		-- Set up the options for the floating window with rounded borders
		local opts = vim.tbl_deep_extend("force", config or {}, {
			border = "rounded", -- Add a rounded border
			focusable = true,
		})

		-- Open a floating window to display hover information
		vim.lsp.util.open_floating_preview(lines, "markdown", opts)
	end
	vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result)
		-- Ensure that result is not nil and handle the signature help properly
		if not result or not result.signatures then
			return
		end

		-- Create the signature help content
		local lines = {}
		for _, signature in ipairs(result.signatures) do
			table.insert(lines, signature.label)
		end

		-- Create a floating window with a rounded border
		local opts = vim.tbl_deep_extend("force", config or {}, {
			border = "rounded", -- Add rounded border
			focusable = true,
		})

		-- Show the signature help in a floating window
		vim.lsp.util.open_floating_preview(lines, "plaintext", opts)
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<CR>", opts)
	keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<CR>", opts)
	keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	-- Sometimes the lsp for a particular language (Ex: tsserver) has
	-- its own formatting provider. The following statement disables
	-- the builtin formatter from the lsp for that language. We instead
	-- rely on the formatter provided by none-ls plugin
	if client.name == "ts_ls" or client.name == "lua_ls" or client.name == "gopls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Enable inlay hints if the server supports it
	if client.server_capabilities.inlayHintProvider and client.name ~= "csharp_ls" then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	lsp_keymaps(bufnr)
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
