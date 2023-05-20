local M = {}

function M.setup()
	vim.cmd[[
		let g:lists_maps_default_override = {
		\ '<plug>(lists-moveup)': '<leader>wli',
		\ '<plug>(lists-movedown)': '<leader>wle',
		\}
	]]
end

return M
