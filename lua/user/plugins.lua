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
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },

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
		event = "UIEnter",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = { indent = { char = "╎" } },
		event = { "BufReadPre", "BufNewFile" },
	},

	-- Colorscheme
	{ "Mofiqul/vscode.nvim", lazy = false, priority = 1000 },

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
	},

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },

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
	{ "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
	}},
	{ "hrsh7th/cmp-buffer", lazy = true },
	{ "hrsh7th/cmp-path", lazy = true },
	{ "hrsh7th/cmp-cmdline", lazy = true },
	{ "saadparwaiz1/cmp_luasnip", lazy = true },
	{ "hrsh7th/cmp-nvim-lsp", lazy = true },
	{ "hrsh7th/cmp-nvim-lua", lazy = true },

	-- Snippets
	{ "L3MON4D3/LuaSnip", event = "InsertEnter", dependencies = { "rafamadriz/friendly-snippets" } },
	{ "rafamadriz/friendly-snippets", lazy = true },

	-- LSP and Linting/Formatting
	{ "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
	{ "williamboman/mason.nvim", cmd = "Mason" },
	{ "williamboman/mason-lspconfig.nvim", dependencies = "mason.nvim" },
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
		event = "LspAttach",
		opts = {},
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
			"fredrikaverpil/neotest-golang",
			"nsidorenco/neotest-vstest",
		},
		config = function()
			require("user.neotest")
		end,
		ft = { "go", "javascript", "typescript", "typescriptreact", "javascriptreact", "cs" },
		keys = {
			{ "<leader>tr", "<cmd>lua require('neotest').run.run()<CR>", desc = "Run nearest test" },
			{ "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", desc = "Run file tests" },
			{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Toggle test summary" },
			{ "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<CR>", desc = "Open test output" },
		},
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


	-- Diff Viewer
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
	},

	-- Surround - manipulate surrounding characters
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Trouble - better diagnostics UI
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
		opts = {},
	},

	-- Session Management
	{
		"folke/persistence.nvim",
		event = "VimEnter",
		opts = {},
	},
})
