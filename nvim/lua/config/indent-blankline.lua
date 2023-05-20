local M = {}

function M.setup()
	vim.opt.list = true
	vim.opt.listchars:append("space:⋅")
	--set.listchars:append("eol:↴")
	indent_blankline.setup {
		--space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
	}
end

return M
