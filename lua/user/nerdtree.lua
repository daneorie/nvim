local g = vim.g
g.NERDTreeMapActivateNode = "k"
g.NERDTreeMapOpenRecursively = "K"
g.NERDTreeHijackNetrw = 0
g.NERDTreeMapOpenExpl = ""
g.NERDTreeMapOpenSplit = "h"
g.NERDTreeMapJumpFirstChild = "E"
g.NERDTreeMapJumpLastChild = "I"
g.NERDTreeMapJumpNextSibling = "<C-e>"
g.NERDTreeMapJumpPrevSibling = "<C-i>"
g.NERDTreeMapToggleHidden = "K"
g.NERDTreeMapMenuDown = "e"
g.NERDTreeMapMenuUp = "i"

vim.cmd [[
	" Exit Vim if NERDTree is the only window remaining in the only tab.
	augroup NERDTree_close_vim_when_solo
		autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	augroup end

	" Close the tab if NERDTree is the only window remaining in it.
	augroup NERDTree_close_tab_when_solo
		autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	augroup end

	" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
	augroup NERDTree_static
		autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
	augroup end
]]
