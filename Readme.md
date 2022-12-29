If you want nvim to support a new language please do the following.

1. Install a LSP for the language using Mason. Update the mason.lua file to add the server. Mason-lspconfig plugin is
   used to setup the lsp servers.
2. Manually install a formatter and a diagnostics tool(linter) for that language and update null-ls.lua with
   that information.

Auto completions is handled by nvim cmp. It has the rules on how the variables/functions/methods appear in the drop down
menu.
