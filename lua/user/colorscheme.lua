require('rose-pine').setup({
    disable_background = true
})
local colorscheme = "rose-pine"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

-- Transparency setting
vim.api.nvim_set_hl(0, "Normal", { bg = "none",fg ="none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none",fg= "none"})
vim.api.nvim_set_hl(0, "StatusLine",{bg = "none", fg="None"})
vim.api.nvim_set_hl(0, "Folded",{bg = "none", fg="None"})
vim.api.nvim_set_hl(0, "SpecialKey",{bg = "none", fg="None"})
vim.api.nvim_set_hl(0, "VertSplit",{bg = "none", fg="None"})
vim.api.nvim_set_hl(0, "SignColumn",{bg = "none", fg="None"})

vim.api.nvim_set_hl(0, "Visual",{bg = "#4da9ff", fg="None"})
vim.api.nvim_set_hl(0, "CursorLine",{bg = "#464d53", fg="None"})

