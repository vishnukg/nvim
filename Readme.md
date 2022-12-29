If you want nvim to support a new language please do the following.

1. Install a LSP for the language using Mason. Update the mason.lua file to add the server. Mason-lspconfig plugin is
   used to setup the lsp servers.
2. If you need additional settings for your lsp config, looks into this place https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
   and add that to config section under LSP/ folder
3. Install treesitter for your specific language to get good syntax highlighting
4. Manually install a formatter and a diagnostics tool(linter) for that language and update null-ls.lua with
   that information.

Auto completions is handled by nvim cmp. It has the rules on how the variables/functions/methods appear in the drop down
menu.

After installing a plugin using packer, you need to initialise the package by setting it up. check the corresponding plugin files
to see how the setup method is invoked.
