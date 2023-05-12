local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ma", mark.add_file)
vim.keymap.set("n", "<leader>me", ui.toggle_quick_menu)

vim.keymap.set("n", "<M-n>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<M-e>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<M-i>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<M-o>", function() ui.nav_file(4) end)

-- Just Build in the third tmux pane
vim.keymap.set("n", "<leader>td", '<cmd>lua require("harpoon.tmux").sendCommand("3", "just test")<CR>', {noremap = true})
vim.keymap.set("n", "<leader>tb", '<cmd>lua require("harpoon.tmux").sendCommand("3", "just build")<CR>', {noremap = true})
