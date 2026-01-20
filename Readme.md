Clone this repository under ~/.config (the result will look like ~/.config/nvim)

## Prerequisites

**IMPORTANT: Before first launch on a new machine:**

1. **Install tree-sitter CLI** (required for nvim-treesitter plugin, version 0.26.1+):
   ```bash
   # Option 1: Using Cargo (Recommended)
   cargo install tree-sitter-cli
   
   # Option 2: Using npm
   npm install -g tree-sitter-cli
   
   # Option 3: Using Homebrew (macOS)
   brew install tree-sitter
   ```
   
   Verify installation:
   ```bash
   tree-sitter --version  # Should show 0.26.1 or later
   ```

2. **Clean old treesitter installation** (if migrating from old nvim-treesitter version):
   ```bash
   rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
   rm -rf ~/.local/share/nvim/site/parser/*
   ```

3. **Install other required tools:**
   - FZF, Ripgrep for telescope to work correctly and to ignore gitignored paths
   - A C compiler (gcc, clang, or MSVC)
   - `tar` and `curl` in your PATH

## Post Install Config Steps

If you want nvim to support a new language please do the following:

0. Install FZF, Ripgrep for telescope to work correctly and to ignore gitignored paths.
1. Install a LSP for the language using Mason. Update the mason.lua file to add the server. Mason-lspconfig plugin is
   used to setup the lsp servers.
2. If you need additional settings for your lsp config, looks into this place https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
   and add that to config section under LSP/ folder
3. Treesitter parsers are automatically installed on first launch. To add a new language parser, update the `parsers_to_install` list in `lua/user/treesitter.lua`
4. Manually install a formatter and a diagnostics tool(linter) for that language and update null-ls.lua with
   that information. You can find the information on available formatter and diagnostics from here -> https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
5. We need to install rg and gnu-sed for nvim spectre to work.
6. We need to install xclip in linux for neovim to be able to copy to clipboard
7. install hack nerd fonts for proper display of special characters.
8. Also install powerline fonts in linux and mac for special characters to be visible.

Auto completions is handled by nvim cmp. It has the rules on how the variables/functions/methods appear in the drop down
menu.

After installing a plugin using packer, you need to initialise the package by setting it up. check the corresponding plugin files
to see how the setup method is invoked.

Mason installs lsp servers and other binaries here in your local machine $HOME/.local/share/nvim/mason

Commands:

1. :Lazy -> To update the plugins
2. :Mason -> Mason Dashboard
3. :TSUpdate -> Update Tree sitter for languages.
4. :LspInfo -> Shows information about the attached LSP clients in the current buffer.
5. :NullLsInfo -> Shows information about the attached null-ls clients in the current buffer.

A bit more context on how vim lsp and mason work together

vim.lsp (Neovim's built-in LSP client, enhanced in v0.11): This is the core engine within Neovim that understands the Language Server Protocol. It allows Neovim to communicate with language servers (once they are running and Neovim knows how to talk to them). It provides the APIs for features like go-to-definition, hover, diagnostics, etc. However, vim.lsp itself does not install or manage the language server programs/binaries.

nvim-lspconfig (a community plugin, but very widely used): This plugin provides a collection of default configurations for a vast number of language servers. It tells vim.lsp how to start and communicate with specific servers (e.g., "for pyright, use this command: pyright-langserver --stdio"). It standardizes the setup for many servers. It also does not install the server binaries themselves.

mason.nvim: This is a package manager. Its job is to download, install, and manage external tools like language servers, linters, formatters, and debug adapters. It ensures the actual server programs (e.g., the lua-language-server executable, ts_ls executable) are available on your system in a predictable location.

mason-lspconfig.nvim: This plugin acts as a bridge. It tells nvim-lspconfig where mason.nvim has installed the server binaries. It also often handles the ensure_installed logic, triggering Mason to install servers if they're missing.
