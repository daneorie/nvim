local g = vim.g
g.vista_executive_for = {
	typescript = 'nvim_lsp'
}

--vim.cmd [[
	--" Exit Vim if NERDTree is the only window remaining in the only tab.
	--augroup Vista_close_vim_when_solo
		--autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:Vista') | quit | endif
	--augroup end

	--" Close the tab if NERDTree is the only window remaining in it.
	--augroup Vista_close_tab_when_solo
		--autocmd BufEnter * if winnr('$') == 1 && exists('b:Vista') | quit | endif
	--augroup end
--]]
