local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>uf", "<cmd> UndotreeFocus<CR>")
	vim.keymap.set("n", "<leader>ut", "<cmd> UndotreeToggle<CR>")
end

return M
