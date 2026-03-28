-- bootstrap.lua
-- Loaded by init.lua BEFORE lazy.nvim or any plugins initialise.
--
-- Neovim reads vim.g.* globals at startup to decide which built-in providers
-- and optional subsystems to activate. By the time the plugin manager runs,
-- those decisions have already been made — so anything here must be set early.
--
-- Rule of thumb: if removing a line here causes a checkhealth warning or a
-- plugin to misbehave on first load, it belongs in this file.

-- ── Providers ────────────────────────────────────────────────────────────────
-- Neovim ships with optional "providers" for Python, Ruby, Perl and Node that
-- allow legacy Vim plugins to call out to those runtimes. We don't use any of
-- them. Disabling them:
--   • removes the "provider not found" warnings in :checkhealth
--   • shaves a few milliseconds off startup (no subprocess probing)
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_node_provider    = 0

-- ── Leader keys ──────────────────────────────────────────────────────────────
-- Must be set before lazy.nvim loads so that any plugin that defines keymaps
-- via `keys = { "<leader>..." }` in its spec picks up the correct leader.
-- Both are set to backslash — change here to affect the entire config.
vim.g.mapleader      = "\\"
vim.g.maplocalleader = "\\"
-- nvim-tree replaces Neovim's built-in file explorer (netrw).
-- These two globals must be set before netrw loads — which happens the moment
-- any plugin or autocmd tries to open a directory. Setting them here, before
-- lazy.nvim runs, guarantees nvim-tree wins that race every time.
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

