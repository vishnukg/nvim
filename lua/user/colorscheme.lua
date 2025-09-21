-- vscode color settings
local colorscheme = "vscode"

pcall(function()
	vim.cmd("colorscheme " .. colorscheme)
end)

vim.o.background = "dark"

local c = require("vscode.colors").get_colors()
require("vscode").setup({
	style = "dark",
	transparent = true,
	italic_comments = true,
	underline_links = true,
	disable_nvimtree_bg = true,
	terminal_colors = true,
	color_overrides = {
		vscLineNumber = "#464d53",
	},
	group_overrides = {
		Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
	},
})

vim.cmd.colorscheme("vscode")

vim.api.nvim_set_hl(0, "Visual", { bg = "#338fcc", fg = "None" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#464d53", fg = "None" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#4da9ff", fg = "None" })

-- ===== Floating window styling =====
-- Default float windows (hover, signature help, etc.)
vim.api.nvim_set_hl(0, "FloatBorder", { fg = c.vscWhite, bold = true })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = c.vscBack }) -- theme background

-- Diagnostics floats (use palette colors)
vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = c.vscRed, bg = c.vscBackLight, bold = true })
vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = c.vscYellow, bg = c.vscBackLight, bold = true })
vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = c.vscBlue, bg = c.vscBackLight, bold = true })
vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = c.vscLightBlue, bg = c.vscBackLight, bold = true })
