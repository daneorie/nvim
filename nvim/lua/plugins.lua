local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	{ "folke/neodev.nvim" },

	-- WhichKey
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("config.which-key").setup()
		end,
	},

	-- Colorschemes
	{
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd.colorscheme([[nightfox]])
		end,
		enabled = true,
	},

	-- Better icons
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim", -- show git decorations in buffers
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({ enable_builtin = true })
			vim.cmd([[hi OctoEditable guibg=none]])
		end,
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			require("config.diffview").setup()
		end,
	},

	-- Better surround
	{
		"kylechui/nvim-surround",
		config = function()
			require("config.surround").setup()
		end,
	},

	-- IDE
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle" },
		config = function()
			require("config.undotree").setup()
		end,
	},

	-- Jumps
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			require("config.vim-tmux-navigator").setup()
		end,
	},
	{
		"ggandor/leap.nvim",
		dependencies = { "tpope/vim-repeat" },
		config = function()
			require("leap").add_default_mappings()
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "BufReadPre",
		config = function()
			require("config.lualine").setup()
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("config.treesitter").setup()
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
			{
				"windwp/nvim-ts-autotag",
				event = "InsertEnter",
				config = function()
					require("nvim-treesitter.configs").setup({ autotag = { enable = true } })
				end,
			},
		},
	},

	-- Telescope
	{
		"tami5/sqlite.lua",
	},
	{
		"nvim-telescope/telescope.nvim",
		event = { "VimEnter" },
		config = function()
			require("config.telescope").setup()
		end,
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"LinArcX/telescope-env.nvim",
			{
				"LukasPietzschmann/telescope-tabs",
				config = true,
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
				config = function()
					require("config.telescope-ui-select").setup()
				end,
			},
			{
				"tom-anders/telescope-vim-bookmarks.nvim",
				config = function()
					require("config.bookmarks").setup()
				end,
			},
			{
				"AckslD/nvim-neoclip.lua",
				dependencies = { "tami5/sqlite.lua" },
				config = function()
					require("config.neoclip").setup()
				end,
			},
			"daneorie/telescope-insert-path.nvim",
		},
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"nvim-telescope/telescope-dap.nvim",
			"leoluz/nvim-dap-go",
			"jbyuki/one-small-step-for-vimkind",
			"mxsdev/nvim-dap-vscode-js",
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npm run compile",
			},
		},
		config = function()
			require("config.dap").setup()
		end,
	},

	-- File Explorer
	{
		"stevearc/oil.nvim",
		config = function()
			require("config.oil").setup()
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			require("config.cmp").setup()
		end,
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			{
				"L3MON4D3/LuaSnip",
				config = function()
					--require("config.snip").setup()
				end,
			},
		},
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lsp").setup()
		end,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"jayp0521/mason-null-ls.nvim",
			"folke/neodev.nvim",
			{
				"RRethy/vim-illuminate",
				config = function()
					require("config.illuminate").setup()
				end,
			},
			"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				config = function()
					require("fidget").setup()
				end,
			},
			"b0o/schemastore.nvim",
			"jose-elias-alvarez/typescript.nvim",
			{
				"SmiteshP/nvim-navic",
				config = function()
					require("nvim-navic").setup()
				end,
			},
			"lvimuser/lsp-inlayhints.nvim",
			{
				"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
				config = function()
					require("lsp_lines").setup()
				end,
			},
			"ray-x/lsp_signature.nvim",
			"pierreglaser/folding-nvim",
		},
	},

	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		keys = { [[<C-\>]] },
		cmd = { "ToggleTerm", "TermExec" },
		config = function()
			require("config.toggleterm").setup()
		end,
	},

	-- quickly select the closest text object among a group of candidates
	{
		"sustech-data/wildfire.nvim",
		config = function()
			require("wildfire").setup({
				keymaps = {
					init_selection = "<Space>",
					node_incremental = "<Space>",
					node_decremental = "<BS>",
				},
			})
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Fuzzy Finder/Telescope/Navigation
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf", build = ":call fzf#install()" },
	},
	{
		"ThePrimeagen/git-worktree.nvim",
	},
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("config.harpoon").setup()
		end,
	},

	-- Better comment
	{
		"numToStr/Comment.nvim",
		config = function()
			require("config.comment").setup()
		end,
	},

	-- Utility
	{
		"neoclide/coc.nvim", -- a fast code completion engine
		branch = "release",
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("config.zen-mode").setup()
		end,
	},
	{
		"tpope/vim-unimpaired",
		dependencies = { "tpope/vim-repeat" },
	},
	{
		"tpope/vim-abolish",
	},

	-- Note Taking
	{
		"lervag/wiki.vim",
		config = function()
			require("config.wiki").setup()
		end,
	},

	-- REST
	{
		"rest-nvim/rest.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("rest-nvim").setup({
				-- Open request results in a horizontal split
				result_split_horizontal = false,
				-- Keep the http file buffer above|left when split horizontal|vertical
				result_split_in_place = false,
				-- Skip SSL verification, useful for unknown certificates
				skip_ssl_verification = true,
				-- Encode URL before making request
				encode_url = true,
				-- Highlight request on run
				highlight = {
					enabled = true,
					timeout = 150,
				},
				result = {
					-- toggle showing URL, HTTP info, headers at top the of result window
					show_url = true,
					-- show the generated curl command in case you want to launch
					-- the same request via the terminal (can be verbose)
					show_curl_command = false,
					show_http_info = true,
					show_headers = true,
					-- executables or functions for formatting response body [optional]
					-- set them to false if you want to disable them
					formatters = {
						json = "jq",
						html = function(body)
							return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
						end,
					},
				},
				-- Jump to request line on run
				jump_to_request = false,
				env_file = ".env",
				custom_dynamic_variables = {},
				yank_dry_run = true,
			})
		end,
	},
	-- Rust
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"rust-lang/rust.vim",
		},
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	},

	-- Go
	--{
	--	"ray-x/go.nvim",
	--	ft = { "go" },
	--	config = function()
	--		require("go").setup()
	--	end,
	--	disable = true,
	--},

	-- Java
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
})
