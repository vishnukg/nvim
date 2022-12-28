local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
keymap("n", "<C-g>", ":Lex 30<cr>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Shortcut for saving all changed files in normal mode
keymap("n","<leader><leader>", ":wa<cr>",opts)

-- This unsets the last search pattern register by hitten return
keymap("n","<C-l>",":noh<cr><C-l>",opts)
