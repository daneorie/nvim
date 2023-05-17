--   Here's the circle of mappings: n -> h -> i -> k -> o -> l -> e -> j -> n
vim.cmd[[
	augroup calendar-mappings
		autocmd!
		" diamond cursor
		autocmd FileType calendar nmap <buffer> n <Plug>(calendar_left)
		autocmd FileType calendar nmap <buffer> e <Plug>(calendar_down)
		autocmd FileType calendar nmap <buffer> i <Plug>(calendar_up)
		autocmd FileType calendar nmap <buffer> o <Plug>(calendar_right)

		" Colemak fixes
		autocmd FileType calendar nmap <buffer> h <Plug>(calendar_start_insert)
		autocmd FileType calendar nmap <buffer> j <Plug>(calendar_next_match)
		autocmd FileType calendar nmap <buffer> J <Plug>(calendar_prev_match)
		autocmd FileType calendar nmap <buffer> k <Plug>(calendar_start_insert_next_line)
		autocmd FileType calendar nmap <buffer> K <Plug>(calendar_start_insert_prev_line)
		autocmd FileType calendar nmap <buffer> l <Plug>(calendar_next)
		" autocmd FileType calendar nmap <buffer> N <Plug>()
		" autocmd FileType calendar nmap <buffer> O <Plug>()

		" swap v and V
		autocmd FileType calendar nmap <buffer> V <Plug>(calendar_visual)
		autocmd FileType calendar nmap <buffer> v <Plug>(calendar_visual_line)

		" unmap <C-n>, <C-p> for other plugins
		autocmd FileType calendar nunmap <buffer> <C-n>
		autocmd FileType calendar nunmap <buffer> <C-p>
	augroup END
]]
