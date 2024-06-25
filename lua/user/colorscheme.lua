-- vscode color settings
local colorscheme = "vscode"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.o.background = "dark"

local c = require("vscode.colors").get_colors()
require("vscode").setup({
	-- Alternatively set style in setup
	style = "dark",

	-- Enable transparent background
	transparent = true,

	-- Enable italic comment
	italic_comments = true,

	-- Underline `@markup.link.*` variants
	underline_links = true,

	-- Disable nvim-tree background color
	disable_nvimtree_bg = true,

	-- Override colors (see ./lua/vscode/colors.lua)
	color_overrides = {
		vscLineNumber = "#464d53",
	},

	-- Override highlight groups (see ./lua/vscode/theme.lua)
	group_overrides = {
		-- this supports the same val table as vim.api.nvim_set_hl
		-- use colors from this colorscheme by requiring vscode.colors!
		Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
	},
})

vim.cmd.colorscheme("vscode")

vim.api.nvim_set_hl(0, "Visual", { bg = "#338fcc", fg = "None" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#464d53", fg = "None" })

-- hi Pmenu bg=color to set popup menu background
-- hi PmenuSel bg=color to set popup menu selection background
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#4da9ff", fg = "None" })
