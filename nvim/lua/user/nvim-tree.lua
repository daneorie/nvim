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
	{ key = "e",                              action = "" }, -- defaults to `rename_basename`
	{ key = "<C-e>",                          action = "" }, -- defaults to `open_in_place`
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

-- Open For Directories And Change Neovim's Directory
local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
