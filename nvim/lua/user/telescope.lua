local status_ok, actions = pcall(require, "telescope.actions")
if not status_ok then
	return
end

require("telescope").setup({
	defaults = {
		mappings  = {
			n = {
				["<C-h>"] = "which_key",
				["e"] = actions.move_selection_next,
				["i"] = actions.move_selection_previous,
				["<C-u>"] = actions.results_scrolling_down,
				["<C-y>"] = actions.results_scrolling_up,
				["<C-,>"] = actions.preview_scrolling_down,
				["<C-.>"] = actions.preview_scrolling_up,
			},
			i = {
				["<C-h>"] = "which_key",
				["<C-e>"] = actions.move_selection_next,
				["<C-i>"] = actions.move_selection_previous,
				["<C-u>"] = actions.results_scrolling_down,
				["<C-y>"] = actions.results_scrolling_up,
				["<C-,>"] = actions.preview_scrolling_down,
				["<C-.>"] = actions.preview_scrolling_up,
			},
		},
	},
	pickers = {
	},
	extensions  = {
	},
});
