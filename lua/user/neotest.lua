local M = {}

function M.setup()
	require("neotest").setup({
		adapters = {
			require("neotest-python"),
			require("neotest-jest"),
			require("neotest-vitest"),
			require("neotest-go"),
		},
	})
end

return M
