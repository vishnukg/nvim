-- Format Ruby files on save using standardrb (runs independently from ruby_lsp)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rb",
	callback = function()
		local standardrb = vim.fn.exepath("standardrb")
		if standardrb == "" then
			return
		end
		local buf = vim.api.nvim_get_current_buf()
		local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
		local filename = vim.api.nvim_buf_get_name(buf)
		local result = vim.system(
			{ standardrb, "--fix", "--format", "quiet", "--stderr", "--stdin", filename },
			{ stdin = content }
		):wait()
		if result.code == 0 and result.stdout and result.stdout ~= "" then
			local lines = vim.split(result.stdout, "\n", { trimempty = false })
			if #lines > 0 and lines[#lines] == "" then
				table.remove(lines)
			end
			local view = vim.fn.winsaveview()
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.fn.winrestview(view)
		end
	end,
})
