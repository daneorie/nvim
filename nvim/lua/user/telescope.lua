local n_mappings = {}
local i_mappings = {}
local extensions = {}
local extensions_to_load = {
	"env",
	"file_browser",
	"fzf",
}

local a_status_ok, actions = pcall(require, "telescope.actions")
if a_status_ok then
	local action_n_mappings = {
		["<C-e>"] = actions.move_selection_next,
		["e"]     = actions.move_selection_next,
		["\x33[105;5u"] = actions.move_selection_previous, -- <C-i>
		["i"]     = actions.move_selection_previous,
		["<C-q>"] = function(bufnr)
			actions.smart_send_to_qflist(bufnr)
			require("telescope.builtin").quickfix()
		end,
		["<C-u>"] = actions.results_scrolling_down,
		["<C-y>"] = actions.results_scrolling_up,
		["<C-,>"] = actions.preview_scrolling_down,
		["<C-.>"] = actions.preview_scrolling_up,
	}
	local action_i_mappings = {
		["<C-e>"] = actions.move_selection_next,
		["\x33[105;5u"] = actions.move_selection_previous, -- <C-i>
		["<C-q>"] = function(bufnr)
			actions.smart_send_to_qflist(bufnr)
			require("telescope.builtin").quickfix()
		end,
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
	n_mappings = vim.tbl_extend("force", n_mappings, { ["\x33[104;5u"] = "which_key" })
	i_mappings = vim.tbl_extend("force", i_mappings, { ["\x33[104;5u"] = "which_key" })
end

local h_status_ok, hop = pcall(require, "hop")
if w_status_ok then
	local hop_mappings = {
		["<C-n>"] = R("telescope").extensions.hop.hop,
		["<C-space>"] = function(prompt_bufnr)
			local opts = {
				callback = actions.toggle_selection,
				loop_callback = actions.send_selected_to_qflist,
			}
			require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
		end,
	}
	n_mappings = vim.tbl_extend("force", n_mappings, hop_mappings)
	i_mappings = vim.tbl_extend("force", i_mappings, hop_mappings)
		
	extensions = vim.tbl_extend("force", extensions, {
		hop = {
			keys = {"a", "r", "s", "t", "d", "h", "n", "e", "i", "o",
					"q", "w", "f", "p", "g", "j", "l", "u", "y", ";",
					"A", "R", "S", "T", "D", "H", "N", "E", "I", "O",
					"Q", "W", "F", "P", "G", "J", "L", "U", "Y", ":",},
		-- Highlight groups to link to signs and lines; the below configuration refers to demo
			-- sign_hl typically only defines foreground to possibly be combined with line_hl
			sign_hl = { "WarningMsg", "Title" },
			-- optional, typically a table of two highlight groups that are alternated between
			line_hl = { "CursorLine", "Normal" },
			-- options specific to `hop_loop`
		-- true temporarily disables Telescope selection highlighting
			clear_selection_hl = false,
			-- highlight hopped to entry with telescope selection highlight
			-- note: mutually exclusive with `clear_selection_hl`
			trace_entry = true,
			-- jump to entry where hop loop was started from
			reset_selection = true,
		}
	})

	extensions_to_load[#extensions_to_load + 1] = "hop"
end

local telescope = require("telescope")
telescope.setup({
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
	extensions = extensions,
});

for _, extension in ipairs(extensions_to_load) do
	telescope.load_extension(extension)
end
