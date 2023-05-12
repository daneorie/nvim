vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope workspaces<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fv", "<cmd>Telescope vim_bookmarks current_file<CR>", {noremap = true})
vim.keymap.set("n", "<leader>fV", "<cmd>Telescope vim_bookmarks all<CR>", {noremap = true})
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope telescope-tabs list_tabs<CR>", {noremap = true})
vim.keymap.set("n", "<leader>bf", "<cmd>Telescope file_browser<CR>", {noremap = true})
vim.keymap.set("n", "<leader>bh", "<cmd>Telescope file_browser hidden=true<CR>", {noremap = true})
