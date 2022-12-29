-- :help options
local options = {
    backup = false,                         -- creates a backup file
    clipboard = "unnamedplus",              -- allows neovim to access the system clipboard
    cmdheight = 1,                          -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" },-- mostly just for cmp
    conceallevel = 0,                       -- so that `` is visible in markdown files
    fileencoding = "utf-8",                 -- the encoding written to a file
    hlsearch = true,                        -- highlight all matches on previous search pattern
    ignorecase = true,                      -- ignore case in search patterns
    mouse = "a",                            -- allow the mouse to be used in neovim
    pumheight = 10,                         -- pop up menu height
    showmode = true,                        -- we don't need to see things like -- INSERT -- anymore
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                       -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 300,                       -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    tabstop = 4,                           -- insert 2 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                          -- set numbered lines
    relativenumber = true,                  -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 2 {default 4}
    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    wrap = false,                            -- display lines as one long line
    scrolloff = 8,                          -- is one of my fav
    sidescrolloff = 8,
    guifont = "monospace:h17",              -- the font used in graphical neovim applications
    guicursor = "",                          -- Set block cursor in insert mode
    hidden = true,                          -- set hidden buffers
    autoread = true,                         -- Reload files changed outside vim
    showmatch = true,                       -- Highlights matching brackets in programming languages
    background = "dark",
}
vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[ 
    syntax enable
    filetype plugin indent on
]]
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use
vim.opt.fillchars:append { eob = " " }                 -- Remove tilde characters
