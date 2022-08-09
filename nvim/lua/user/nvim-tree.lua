local function print_node_path(node)
	print(node.absolute_path)
end

-- Change some default mappings for Colemak
local list = {
	{ key = "<leader>p", action = "print_path", action_cb = print_node_path },
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
			list = list,
		},
	},
	renderer = {
		group_empty = true,
		indent_markers = {
			enable = true,
		},
	},
})

--vim.cmd [[
	--" Exit Vim if NERDTree is the only window remaining in the only tab.
	--augroup NERDTree_close_vim_when_solo
		--autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	--augroup end

	--" Close the tab if NERDTree is the only window remaining in it.
	--augroup NERDTree_close_tab_when_solo
		--autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	--augroup end
--]]
