vim.cmd [[
	augroup _general_settings
		autocmd!
		autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
		autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
		autocmd BufWinEnter * :set formatoptions-=cro
		autocmd FileType qf set nobuflisted
	augroup end

	augroup _git
		autocmd!
		autocmd FileType gitcommit setlocal wrap
		autocmd FileType gitcommit setlocal spell
	augroup end

	augroup _markdown
		autocmd!
		autocmd FileType markdown setlocal wrap
		autocmd FileType markdown setlocal spell
	augroup end

	augroup _auto_resize
		autocmd!
		autocmd VimResized * tabdo wincmd = 
	augroup end

	augroup _alpha
		autocmd!
		autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
	augroup end

	augroup filetypedetect
		au! BufRead,BufNewFile *.jsx setfiletype javascript
	augroup END

	" highlight yanked text for 200ms using the "Visual" highlight group
	augroup highlight_yank
		autocmd!
		au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
	augroup END
]]

--	Autoformat
--	augroup _lsp
--		autocmd!
--		autocmd BufWritePre * lua vim.lsp.buf.formatting()
--	augroup end

