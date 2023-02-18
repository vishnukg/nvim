-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	view = {
		width = 30,
		adaptive_size = true,
		side = "left",
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = false,
		ignore_list = {},
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "*",
				},
			},
		},
	},
	filters = {
		dotfiles = false,
	},
	actions = {
		open_file = {
			quit_on_open = true,
			window_picker = {
				enable = false,
			},
		},
	},
})

-- Autoclose nvim_tree native option
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#naive-solution

vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
})

-- Autoclose nvim_tree option 2

-- local function tab_win_closed(winnr)
-- 	local api = require("nvim-tree.api")
-- 	local tabnr = vim.api.nvim_win_get_tabpage(winnr)
-- 	local bufnr = vim.api.nvim_win_get_buf(winnr)
-- 	local buf_info = vim.fn.getbufinfo(bufnr)[1]
-- 	local tab_wins = vim.tbl_filter(function(w)
-- 		return w ~= winnr
-- 	end, vim.api.nvim_tabpage_list_wins(tabnr))
-- 	local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
-- 	if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
-- 		-- Close all nvim tree on :q
-- 		if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
-- 			api.tree.close()
-- 		end
-- 	else -- else closed buffer was normal buffer
-- 		if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
-- 			local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
-- 			if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
-- 				vim.schedule(function()
-- 					if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
-- 						vim.cmd("quit") -- then close all of vim
-- 					else -- else there are more tabs open
-- 						vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
-- 					end
-- 				end)
-- 			end
-- 		end
-- 	end
-- end
--
-- vim.api.nvim_create_autocmd("WinClosed", {
-- 	callback = function()
-- 		local winnr = tonumber(vim.fn.expand("<amatch>"))
-- 		vim.schedule_wrap(tab_win_closed(winnr))
-- 	end,
-- 	nested = true,
-- })
