local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

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

-- Turn off vim macro recording
keymap("n", "q", "<Nop>", opts)

-- Shortcut for saving all changed files in normal mode
keymap("n", "<leader><leader>", ":wa<cr>", opts)
keymap("", "<leader><leader>", ":wa<cr>", opts)

-- This unsets the last search pattern register by hitten return
keymap("n", "<C-l>", ":noh<cr><C-l>", opts)

-- Disable the use of arrow keys in normal mode
keymap("n", "<Left>", ':echoe "Use h"<cr>', opts)
keymap("n", "<Right>", ':echoe "Use l"<cr>', opts)
keymap("n", "<Up>", ':echoe "Use k"<cr>', opts)
keymap("n", "<Down>", ':echoe "Use j"<cr>', opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

--Telescope mappings
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

--NvimTree
keymap("n", "<C-g>", ":NvimTreeToggle<cr>", opts)

--Spectre
keymap("n", "<leader>sp", "<cmd>lua require('spectre').open()<CR>", opts)

-- Spectre search current word
keymap("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opts)
keymap("n", "<leader>s", "<esc>:lua require('spectre').open_visual()<CR>", opts)

-- Toggle Term
keymap("n", "<leader>tv", ":ToggleTerm size=90 direction=vertical<CR>", opts)
keymap("n", "<leader>th", ":ToggleTerm size=20 direction=horizontal<CR>", opts)
keymap("n", "<leader>gt", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Diff two files in the split buffers
keymap("n", "<leader>df", ":windo diffthis<CR>", opts)

-- Neotest runner
keymap("n", "<leader>tr", ":Neotest run<CR>", opts)
keymap("n", "<leader>tf", ":Neotest run file<CR>", opts)
keymap("n", "<leader>ts", ":Neotest summary<CR>", opts)
keymap("n", "<leader>to", ":Neotest output<CR>", opts)

-- Rest.NVIM
keymap("n", "<leader>ht", ":Rest run<CR>", opts)
keymap("n", "<leader>hto", ":Rest open<CR>", opts)

--Copilot chat and copilot
keymap("n", "<leader>cpe", ":CopilotChat<CR>", opts)
keymap("n", "<leader>cpe", ":CopilotChatExplain<CR>", opts)
keymap("n", "<leader>cpt", ":CopilotChatTests<CR>", opts)
keymap("n", "<leader>cpr", ":CopilotChatReset<CR>", opts)

--Vim Code Diff
keymap("n", "<leader>cd", ":CodeDiff<CR>", opts)
