-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end


nvim_tree.setup {
    open_on_setup = true,
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
                    ignored = "◌",
                },
            },
        },
    },
    filters = {
        dotfiles = true,
    },
}


