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

local minitest_configs = {
	"test/test_helper.rb",
	"test/minitest_helper.rb",
}

local adapters = {
	require("neotest-golang")({}),
	require("neotest-vstest")({}),
}

if has_file(minitest_configs) then
	table.insert(
		adapters,
		require("neotest-minitest")({
			test_cmd = function()
				return vim.tbl_flatten({
					"bundle",
					"exec",
					"ruby",
					"-Itest",
				})
			end,
		})
	)
end

if has_file(vitest_configs) then
	table.insert(
		adapters,
		require("neotest-vitest")({
			cwd = function()
				return vim.fn.getcwd()
			end,
			filter_dir = function(name)
				return not (name == "node_modules" or name == "dist")
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
			filter_dir = function(name)
				return not (name == "node_modules" or name == "dist")
			end,
		})
	)
end
--
-- Default to jest if neither vitest nor jest config files are found
if not has_file(vitest_configs) and not has_file(jest_configs) then
	table.insert(
		adapters,
		require("neotest-jest")({
			jestCommand = "npm test --",
			env = { CI = true },
			cwd = function()
				return vim.fn.getcwd()
			end,
			filter_dir = function(name)
				return not (name == "node_modules" or name == "dist")
			end,
		})
	)
end

require("neotest").setup({
	adapters = adapters,
})
