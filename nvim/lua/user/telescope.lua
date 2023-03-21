local status_ok, actions = pcall(require, "telescope.actions")
if not status_ok then
	return
end

require("telescope").setup({
	defaults = {
		mappings  = {
			n = {
				["<C-h>"] = "which_key",
				["<C-e>"] = actions.move_selection_next,
				["e"]     = actions.move_selection_next,
				["\x33[105;5u"] = actions.move_selection_previous,
				["i"]     = actions.move_selection_previous,
				["<C-u>"] = actions.results_scrolling_down,
				["<C-y>"] = actions.results_scrolling_up,
				["\x33[44;5u"] = actions.preview_scrolling_down,
				["\x33[46;5u"] = actions.preview_scrolling_up,
			},
			i = {
				["<C-h>"] = "which_key",
				["<C-e>"] = actions.move_selection_next,
				["\x33[105;5u"] = actions.move_selection_previous,
				["<C-u>"] = actions.results_scrolling_down,
				["<C-y>"] = actions.results_scrolling_up,
				["\x33[44;5u"] = actions.preview_scrolling_down,
				["\x33[46;5u"] = actions.preview_scrolling_up,
			},
		},
	},
	pickers = {
	},
	extensions  = {
	},
});
