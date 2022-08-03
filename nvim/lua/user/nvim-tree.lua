local function print_node_path(node)
	print(node.absolute_path)
end

-- Change some default mappings for Colemak
local list = {
	{ key = "p", action = "print_path", action_cb = print_node_path },
	{ key = { "<CR>", "k", "<2-LeftMouse>" }, action = "edit" },
	{ key = "<C-l>",                          action = "edit_in_place" },
	{ key = "K",                              action = "edit_no_picker" },
	{ key = "I",                              action = "first_sibling" },
	{ key = "E",                              action = "last_sibling" },
	{ key = "H",                              action = "toggle_git_ignored" },
	{ key = "N",                              action = "toggle_dotfiles" },
	{ key = "L",                              action = "expand_all" },
}

require("nvim-tree").setup({
	view = {
		mappings = {
			custom_only = false,
			list = list,
		},
	},
})
