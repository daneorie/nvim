local g = vim.g
g.wiki_root = '~/Documents/iCloud/iCloud~md~obsidian/Documents/wiki'
g.wiki_filetypes = {'md', 'wiki'}
g.wiki_journal = {
	date_format = {
		daily = '%Y/%m/%Y-%m-%d',
		weekly = '%Y/%Y-week_%V',
		monthly = '%Y/%m/%Y-%m-summary',
	},
}
g.wiki_link_extension = '.md'
g.wiki_link_target_type = 'md'
g.wiki_map_text_to_link = function(x)
	if string.find(x, "/") then
		return { string.gsub(x:lower(), " ", "-"), string.gsub(x, "^.*/", "") or x  }
	end

	local dir = vim.fn.expand('%:t:r')
	if dir == "index" then
		return { string.gsub(x:lower(), " ", "-"), x }
	end

	return { dir .. "/" .. string.gsub(x:lower(), " ", "-"), x }
end
