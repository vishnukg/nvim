local colorscheme = "darkplus"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

local api = vim.api
api.nvim_set_hl(0, "Normal", { bg = "none",fg = "none" })
api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg= "none" })
api.nvim_set_hl(0, "CursorLine",{bg = "#464d53", fg="None"})
api.nvim_set_hl(0, "StatusLine",{bg = "none", fg="None"})
api.nvim_set_hl(0, "Visual",{bg = "#4da9ff", fg="None"})


