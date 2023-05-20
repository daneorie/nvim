local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>l", "<cmd>call Swoop()<CR>", {noremap = true})
	vim.keymap.set("x", "<leader>l", "<cmd>call SwoopSelection()<CR>", {noremap = true})
	vim.keymap.set("n", "<leader>ml", "<cmd>call SwoopMulti()<CR>", {noremap = true})
	vim.keymap.set("x", "<leader>ml", "<cmd>call SwoopMultiSelection()<CR>", {noremap = true})
end

return M
