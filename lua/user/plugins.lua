local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

	-- Core Lua utilities (plenary needed by telescope/gitsigns)
	{ "nvim-lua/plenary.nvim", lazy = false },

	-- UI Enhancements
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user.nvimtree")
		end,
	},
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
		lazy = false,
	},

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("user.autopairs")
		end,
	},

	-- Terminal Integration
	{ "akinsho/toggleterm.nvim", cmd = "ToggleTerm" },

	-- Undo Tree: use built-in since 0.12 (:packadd nvim.undotree | :Undotree)

	-- Git Integration
	{ "tpope/vim-fugitive", lazy = false },
	{ "lewis6991/gitsigns.nvim", lazy = false },

	-- Search and Replace
	{ "windwp/nvim-spectre", cmd = "Spectre" },

	-- Commenting handled by built-in gc/gcc (since nvim 0.10)

	-- Completion Plugins
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
		},
	},
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
	{ "neovim/nvim-lspconfig", lazy = false },
	{ "williamboman/mason.nvim", lazy = false },
	{ "williamboman/mason-lspconfig.nvim", lazy = false, dependencies = "mason.nvim" },
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		lazy = false,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
	},
	{
		"j-hui/fidget.nvim",
		lazy = false,
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
			"zidhuss/neotest-minitest",
		},
		config = function()
			require("user.neotest")
		end,
		ft = { "go", "javascript", "typescript", "typescriptreact", "javascriptreact", "cs", "ruby" },
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

	-- Markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {
			enabled = true,
		},
	},

	-- Language Specific Plugins
	-- OpenFGA authorization models
	{
		"hedengran/fga.nvim",
		opts = {
			install_treesitter_grammar = true,
		},
	},

	-- Bruno API client (.bru syntax highlighting via tree-sitter)
	{ "kristoferssolo/tree-sitter-bruno" },

	-- Test coverage overlay (green = covered, red = uncovered)
	-- Workflow: run tests with neotest → <leader>cv to overlay coverage
	{
		"andythigpen/nvim-coverage",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("coverage").setup({
				commands = true,
				auto_reload = true,
				highlights = {
					covered   = { bg = "#004400" },
					uncovered = { bg = "#440000" },
				},
				signs = {
					covered   = { hl = "CoverageCovered",   text = "▎" },
					uncovered = { hl = "CoverageUncovered", text = "▎" },
				},
				lang = {
					-- Go: run `go test -coverprofile=coverage.out ./...`
					go = { coverage_file = "coverage.out" },
					-- TypeScript/JavaScript: run `npm run test:coverage` (needs lcov reporter in vitest/jest config)
					typescript = { coverage_file = "coverage/lcov.info" },
					javascript = { coverage_file = "coverage/lcov.info" },
					-- Python: run `coverage run -m pytest && coverage json`
					python = { coverage_file = ".coverage" },
					-- Ruby: requires SimpleCov with JSON formatter in spec_helper.rb
					-- `require 'simplecov'; require 'simplecov-json'; SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter`
					ruby = { coverage_file = "coverage/coverage.json" },
					-- C#: run `dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=lcov /p:CoverletOutput=TestResults/lcov.info`
					cs = { coverage_file = "TestResults/lcov.info" },
				},
			})
		end,
		ft = { "go", "javascript", "typescript", "python", "ruby", "cs" },
	},

	-- Go: struct tags, iferr, impl, go mod commands.
	-- Explicitly NOT an LSP tool — no interference with gopls/none-ls/neotest.
	-- Run :GoInstallDeps once after install to fetch required binaries.
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
			-- Auto-install deps when first Go file opens, only if binaries are missing
			if vim.fn.executable("gomodifytags") == 0 then
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "go",
					once = true,
					callback = function()
						vim.cmd("GoInstallDeps")
					end,
				})
			end
		end,
		opts = {
			commands = {
				gotests = "gotests", -- installed but unused; testing handled by neotest-golang
			},
			gotag = {
				transform = "camelcase",
				default_tag = "json",
				option = nil, -- omitempty should be added explicitly per field, not by default
			},
		},
	},

	-- .NET
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("easy-dotnet").setup({
				lsp = {
					-- Roslyn LSP disabled: csharp_ls handles all LSP features consistently
					-- with the rest of the LSP setup (gopls, pyright, etc). Nvim 0.12's
					-- built-in LSP client covers code actions, diagnostics, code lens,
					-- completions, references natively.
					enabled = false,
				},
			})
		end,
		ft = { "cs", "fs", "vb" },
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
		cmd = { "Trouble" },
		opts = {},
	},
})
