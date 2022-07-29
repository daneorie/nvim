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
	indent = {
		enable = true,
		disable = { },
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aA"] = "@attribute.outer",   --  1
				["iA"] = "@attribute.inner",   --  2
				["ab"] = "@block.outer",       --  3
				["ib"] = "@block.inner",       --  4
				["ac"] = "@call.outer",        --  5
				["ic"] = "@call.inner",        --  6
				["at"] = "@class.outer",       --  7
				["it"] = "@class.inner",       --  8
				["a/"] = "@comment.outer",     --  9
				["i/"] = "@comment.inner",     -- 
				["ai"] = "@conditional.outer", -- 10
				["ii"] = "@conditional.inner", -- 11
				["aF"] = "@frame.outer",       -- 12
				["iF"] = "@frame.inner",       -- 13
				["af"] = "@function.outer",    -- 14
				["if"] = "@function.inner",    -- 15
				["al"] = "@loop.outer",        -- 16
				["il"] = "@loop.inner",        -- 17
				["aa"] = "@parameter.outer",   -- 18
				["ia"] = "@parameter.inner",   -- 19
				["is"] = "@scopename.inner",   -- 20
				["as"] = "@statement.outer",   -- 21
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
}
