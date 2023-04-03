local n_mappings = {}
local i_mappings = {}

local a_status_ok, actions = pcall(require, "telescope.actions")
if a_status_ok then
	local action_n_mappings = {
		["<C-e>"] = actions.move_selection_next,
		["e"]     = actions.move_selection_next,
		["\x33[105;5u"] = actions.move_selection_previous, -- <C-i>
		["i"]     = actions.move_selection_previous,
		["<C-u>"] = actions.results_scrolling_down,
		["<C-y>"] = actions.results_scrolling_up,
		["<C-,>"] = actions.preview_scrolling_down,
		["<C-.>"] = actions.preview_scrolling_up,
	}
	local action_i_mappings = {
		["<C-e>"] = actions.move_selection_next,
		["\x33[105;5u"] = actions.move_selection_previous, -- <C-i>
		["<C-u>"] = actions.results_scrolling_down,
		["<C-y>"] = actions.results_scrolling_up,
		["<C-,>"] = actions.preview_scrolling_down,
		["<C-.>"] = actions.preview_scrolling_up,
	}
	n_mappings = vim.tbl_extend("force", n_mappings, action_n_mappings)
	i_mappings = vim.tbl_extend("force", i_mappings, action_i_mappings)
end

local as_status_ok, action_state = pcall(require, "telescope.actions.state")
local n_status_ok, nvim_tree = pcall(require, "nvim-tree.api")
if as_status_ok and n_status_ok then
	local open_in_nvim_tree = function(prompt_bufnr)
		local opts = {
			buf = action_state.get_selected_entry()[1],
			open = true,
			focus = true,
		}

		nvim_tree.tree.find_file(opts)
	end

	n_mappings = vim.tbl_extend("force", n_mappings, { ["<C-b>"] = open_in_nvim_tree })
	i_mappings = vim.tbl_extend("force", i_mappings, { ["<C-b>"] = open_in_nvim_tree })
end

local i_status_ok, insert_path = pcall(require, "user.telescope-insert-path")
if i_status_ok then
	n_mappings = vim.tbl_extend("force", n_mappings, insert_path.n_mappings())
	i_mappings = vim.tbl_extend("force", i_mappings, insert_path.i_mappings())
end

local w_status_ok, whichkey = pcall(require, "which-key")
if w_status_ok then
	n_mappings = vim.tbl_extend("force", n_mappings, { ["<C-h>"] = "which_key" })
	i_mappings = vim.tbl_extend("force", i_mappings, { ["<C-h>"] = "which_key" })
end

require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"^.git/",
		},
		mappings = {
			n = n_mappings,
			i = i_mappings,
		},
	},
	pickers = {
		buffers = {
			mappings = {
				i = {
					["<C-d>"] = "delete_buffer"
				}
			}
		}
	},
	extensions = {
	},
});
