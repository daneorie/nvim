local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

vim.keymap.set("n", "<leader>gw", '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>')
vim.keymap.set("n", "<leader>gc", '<cmd>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>')
