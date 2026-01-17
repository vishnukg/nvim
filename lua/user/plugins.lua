local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

return lazy.setup({

	-- Core Lua functions and utilities
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",

	-- UI Enhancements
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({})
		end,
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		event = "VimEnter",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { indent = { char = "╎" } },
		event = { "BufReadPre", "BufNewFile" },
	},

	-- Colorscheme
	"Mofiqul/vscode.nvim",

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
	},

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", lazy = false, branch = "master", build = ":TSUpdate" },

	-- Autopairs
	{ "windwp/nvim-autopairs", event = "InsertEnter" },

	-- Terminal Integration
	{ "akinsho/toggleterm.nvim", cmd = "ToggleTerm" },

	-- Undo Tree
	{ "mbbill/undotree", cmd = "UndotreeToggle" },

	-- Git Integration
	{ "tpope/vim-fugitive", cmd = { "Git", "G" } },
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },

	-- Search and Replace
	{ "windwp/nvim-spectre", cmd = "Spectre" },

	-- Commenting
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
		event = { "BufReadPost", "BufNewFile" },
	},

	-- Completion Plugins (nvim-cmp and sources)
	{ "hrsh7th/nvim-cmp", event = "InsertEnter" },
	{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
	{ "hrsh7th/cmp-path", after = "nvim-cmp" },
	{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
	{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },

	-- Snippets
	{ "L3MON4D3/LuaSnip", event = "InsertEnter" },
	{ "rafamadriz/friendly-snippets", event = "InsertEnter" },

	-- LSP and Linting/Formatting
	{ "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
	{ "williamboman/mason.nvim", cmd = "Mason" },
	{ "williamboman/mason-lspconfig.nvim", after = "mason.nvim" },
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
	},

	-- Testing
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-go",
			"nsidorenco/neotest-vstest",
		},
		cmd = { "Neotest", "NeotestSummary", "NeotestOutput" },
	},

	-- AI/Copilot
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {},
		cmd = "CopilotChat",
	},

	-- Language Specific Plugins
	-- .NET
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("easy-dotnet").setup()
		end,
		ft = { "cs", "fs", "vb" },
	},
	-- Go
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		config = function(lp, opts)
			require("go").setup(opts)
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").goimports()
				end,
				group = format_sync_grp,
			})
		end,
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	-- Diff Viewer
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
	},
})
