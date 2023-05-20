local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>gw", '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>')
	vim.keymap.set("n", "<leader>gc", '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>')
end

return M
