local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup {
	ensure_installed = "all", -- a list of parsers or "all"
	ignore_install = { }, -- list of parsers to ignore installing (for "all")
	sync_install = false, -- install parsers synchronously
	auto_install = true, -- automatically install missing parsers when entering buffer
	highlight = {
		enable = true, -- `false` will disable the whole extension
		disable = { "css" }, -- list of parsers (not languages) to ignore
		additional_vim_regex_highlighting = false, -- `true` or list of languages
	},
	autopairs = {
		enable = true
	},
}
