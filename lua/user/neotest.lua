local function has_file(patterns)
	for _, pattern in ipairs(patterns) do
		if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. pattern) == 1 then
			return true
		end
	end
	return false
end

local vitest_configs = {
	"vitest.config.ts",
	"vitest.config.js",
	"vitest.config.mjs",
	"vitest.config.cjs",
	"vite.config.js",
	"vite.config.ts",
}

local jest_configs = {
	"jest.config.js",
	"jest.config.ts",
	"jest.config.mjs",
	"jest.config.cjs",
	"jest.config.json",
}

local adapters = {
	require("neotest-go")({
		experimental = { test_table = true },
		args = { "-v" },
		cwd = function()
			return vim.fn.getcwd()
		end,
		test_pattern = { "*_test.go" },
	}),
}

if has_file(vitest_configs) then
	table.insert(
		adapters,
		require("neotest-vitest")({
			cwd = function()
				return vim.fn.getcwd()
			end,
		})
	)
end

if has_file(jest_configs) then
	table.insert(
		adapters,
		require("neotest-jest")({
			jestCommand = "npm test --",
			env = { CI = true },
			cwd = function()
				return vim.fn.getcwd()
			end,
		})
	)
end

require("neotest").setup({
	adapters = adapters,
})
