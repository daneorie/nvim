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
map({"n", "v"}, "<leader>s", ":w<CR>")
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
map({"n", "v"}, "<leader>d", ":bprevious<CR>:bdelete #<CR>")

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

--------------------------
-- Plugin-specific keymaps

-- NERDTree
map("n", "<leader>nt", ":NERDTreeFocus<CR>")
map("n", "<C-h>", ":NERDTree<CR>")
map("n", "<leader>t", ":NERDTreeToggle<CR>")
map("n", "<C-f>", ":NERDTreeFind<CR>")
map("n", "<leader>r", ":NERDTreeRefreshRoot<CR>") --refresh file list

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

-- LSP
silent_map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
silent_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
silent_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
silent_map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
silent_map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
silent_map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
silent_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
silent_map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
silent_map("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>")
silent_map("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
silent_map("n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
silent_map("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
silent_map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
