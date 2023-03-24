local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
	return
end

surround.setup {
	keymaps = { -- vim-surround style keymaps
		insert = "<C-s>s",
		insert_line = "<C-s>S",
	},
}

