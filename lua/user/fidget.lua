local status_ok, fidget = pcall(require, "fidget")
if not status_ok then
	return
end

fidget.setup({
	notification = {
		window = {
			winblend = 0,
			border = "none", -- none, single, double, rounded, solid, shadow
			border_hl = "FloatBorder",
			max_width = 50,
			max_height = 10,
			x_padding = 1,
			y_padding = 1,
			avoid = { "NvimTree" },
		},
		view = {
			stack_upwards = false, -- Display from top to bottom
			icon_separator = " ", -- Separator between icon and message
			group_separator = "", -- No separator between notification groups
		},
	},
	progress = {
		display = {
			render_limit = 16,
			done_ttl = 3, -- How long to show completed messages
			progress_icon = { pattern = "dots", period = 1 },
		},
		lsp = {
			progress_ringbuf_size = 0, -- Disable LSP progress tracking if too noisy
		},
	},
})
