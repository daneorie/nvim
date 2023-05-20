local M = {}

local harpoon = require("harpoon")
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

function M.setup()
	harpoon.setup({
		global_settings = {
			-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
			save_on_toggle = false,

			-- saves the harpoon file upon every change. disabling is unrecommended.
			save_on_change = true,

			-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
			enter_on_sendcmd = true,

			-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
			tmux_autoclose_windows = false,

			-- filetypes that you want to prevent from adding to the harpoon list menu.
			excluded_filetypes = { "harpoon" },

			-- set marks specific to each git branch inside git repository
			mark_branch = false,
		}
	})

	vim.keymap.set("n", "<leader>ma", mark.add_file)
	vim.keymap.set("n", "<leader>me", ui.toggle_quick_menu)

	vim.keymap.set("n", "<M-n>", function() ui.nav_file(1) end)
	vim.keymap.set("n", "<M-e>", function() ui.nav_file(2) end)
	vim.keymap.set("n", "<M-i>", function() ui.nav_file(3) end)
	vim.keymap.set("n", "<M-o>", function() ui.nav_file(4) end)

	-- Just Build in the third tmux pane
	vim.keymap.set("n", "<leader>td", '<cmd>lua require("harpoon.tmux").sendCommand("3", "just test")<CR>', {noremap = true})
	vim.keymap.set("n", "<leader>tb", '<cmd>lua require("harpoon.tmux").sendCommand("3", "just build")<CR>', {noremap = true})

	local status_ok, telescope = pcall(require, "telescope")
	if status_ok then
		telescope.load_extension("harpoon")
	end
end

return M
