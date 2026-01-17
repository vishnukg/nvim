local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

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

-- This unsets the last search pattern register by hitting return
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
keymap("n", "<leader>sp", function()
	require("spectre").open()
end, opts)

-- Spectre search current word
keymap("n", "<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, opts)
keymap("n", "<leader>s", function()
	require("spectre").open_visual()
end, opts)

-- Toggle Term
keymap("n", "<leader>tv", "<cmd>ToggleTerm size=90 direction=vertical<CR>", opts)
keymap("n", "<leader>th", "<cmd>ToggleTerm size=20 direction=horizontal<CR>", opts)
keymap("n", "<leader>gt", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Diff two files in the split buffers
keymap("n", "<leader>df", ":windo diffthis<CR>", opts)

-- Neotest runner
keymap("n", "<leader>tr", function()
	require("neotest").run.run()
end, opts)
keymap("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, opts)
keymap("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, opts)
keymap("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, opts)

-- Rest.NVIM
keymap("n", "<leader>ht", "<cmd>Rest run<CR>", opts)
keymap("n", "<leader>hto", "<cmd>Rest open<CR>", opts)

--Copilot chat and copilot
keymap("n", "<leader>cp", "<cmd>CopilotChat<CR>", opts)
keymap("n", "<leader>cpe", "<cmd>CopilotChatExplain<CR>", opts)
keymap("n", "<leader>cpt", "<cmd>CopilotChatTests<CR>", opts)
keymap("n", "<leader>cpr", "<cmd>CopilotChatReset<CR>", opts)

--Vim Code Diff
keymap("n", "<leader>cd", "<cmd>CodeDiff<CR>", opts)

-- Trouble diagnostics
keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", opts)
keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)
keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", opts)

-- Session Management
keymap("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore Session" })
keymap("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
keymap("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Don't Save Current Session" })
