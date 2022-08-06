local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end
local function silent_map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- utility mappings
map({"n", "v"}, "<leader>w", ":w<CR>")
map({"n", "v"}, "<leader>oo", ":e ")
map({"n", "v"}, "<leader>nn", ":set number!<CR>") -- toggle line numbers
map({"n", "v"}, "<leader>nr", ":set relativenumber!<CR>") -- toggle relative numbers

-- Set keymaps for Colemak navigation.
--   Here's the circle of mappings: n -> h -> i -> k -> o -> l -> e -> j -> n
map({"n", "v"}, "n", "h")
map({"n", "v"}, "N", "H")
map({"n", "v"}, "e", "j")
map({"n", "v"}, "E", "J")
map({"n", "v"}, "i", "k")
map({"n", "v"}, "I", "K")
map({"n", "v"}, "o", "l")
map({"n", "v"}, "O", "L")
map({"n", "v"}, "h", "i")
map({"n", "v"}, "H", "I")
map({"n", "v"}, "k", "o")
map({"n", "v"}, "K", "O")
map({"n", "v"}, "l", "e")
map({"n", "v"}, "L", "E")
map({"n", "v"}, "j", "n")
map({"n", "v"}, "J", "N")

-- move between buffers
map("n", "<Tab>", ":bn<CR>")
map("n", "<S-Tab>", ":bp<CR>")
map("n", "<leader><Tab>", ":Bw<CR>")
map("n", "<leader><S-Tab>", ":Bw!<CR>")
map("n", "<C-t>", ":tabnew split<CR>")

-- resize current buffer
map({"n", "v", "i"}, "<A-Left>", ":vertical resize -2<CR>")  -- decrease width
map({"n", "v", "i"}, "<A-Down>", ":resize -2<CR>")           -- decrease height
map({"n", "v", "i"}, "<A-Up>", ":resize +2<CR>")             -- increase height
map({"n", "v", "i"}, "<A-Right>", ":vertical resize +2<CR>") -- increase width

-- delete current buffer and move to previous buffer
--map({"n", "v"}, "<leader>d", ":bprevious<CR>:bdelete #<CR>")

-- move line or visually selected block - alt+j/k (Colemak)
map("i", "<A-e>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-i>", "<Esc>:m .-2<CR>==gi")
map("v", "<A-e>", ":m '>+1<CR>gv=gv")
map("v", "<A-i>", ":m '<-2<CR>gv=gv")

--split the window vertically or horizontally
map("n", "<Bar>", "<C-w>v<C-w><Right>")
map("n", "_", "<C-w>s<C-w><Down>")

-- move split panes to left/bottom/top/right (Colemak)
map("n", "<A-n>", "<C-w>H")
map("n", "<A-e>", "<C-w>J")
map("n", "<A-i>", "<C-w>K")
map("n", "<A-o>", "<C-w>L")

-- move between panes to left/bottom/top/right (Colemak)
map("n", "<C-n>", "<C-w>h")
map("n", "<C-e>", "<C-w>j")
map("n", "<C-i>", "<C-w>k")
map("n", "<C-o>", "<C-w>l")

-- Clear highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>")

-- Stay in visual mode after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

--------------------------
-- Plugin-specific keymaps

-- nvim-tree
map("n", "<leader>nt", ":NvimTreeToggle<CR>")

-- Telescope
silent_map("n", "<leader>qr",  "<cmd>:lua require('user.telescope').reload()<CR>")
map("n", "<leader>ff",  "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg",  "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb",  "<cmd>Telescope buffers<CR>")
map("n", "<leader>fh",  "<cmd>Telescope help_tags<CR>")
map("n", "<leader>bf",  "<cmd>Telescope file_browser<CR>")

-- vim-buffet
map("n", "<leader>1", "<Plug>BuffetSwitch(1)")
map("n", "<leader>2", "<Plug>BuffetSwitch(2)")
map("n", "<leader>3", "<Plug>BuffetSwitch(3)")
map("n", "<leader>4", "<Plug>BuffetSwitch(4)")
map("n", "<leader>5", "<Plug>BuffetSwitch(5)")
map("n", "<leader>6", "<Plug>BuffetSwitch(6)")
map("n", "<leader>7", "<Plug>BuffetSwitch(7)")
map("n", "<leader>8", "<Plug>BuffetSwitch(8)")
map("n", "<leader>9", "<Plug>BuffetSwitch(9)")
map("n", "<leader>0", "<Plug>BuffetSwitch(10)")

-- DAP
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>")
map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>")
map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<CR>")
map("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<CR>")
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>")
map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>")
map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>")
map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>")
