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
	git = { timeout = 240 },

	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
	},
	{
		"folke/neodev.nvim",
	},

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
		"f-person/git-blame.nvim",
		cmd = "GitBlameToggle",
	},
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			--require("octo").setup()
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
		cmd = "UndotreeToggle",
		config = function()
			require("config.undotree").setup()
		end,
	},

	-- Jumps
	--{
	--	"christoomey/vim-tmux-navigator",
	--	config = function()
	--		require("config.vim-tmux-navigator").setup()
	--	end,
	--},
	{
		"numToStr/Navigator.nvim",
		config = function()
			require("config.navigator").setup()
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
		"nvim-telescope/telescope.nvim",
		event = { "VimEnter" },
		config = function()
			require("config.telescope").setup()
		end,
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"LinArcX/telescope-env.nvim",
			"daneorie/telescope-insert-path.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "LukasPietzschmann/telescope-tabs", config = true },
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
			{
				"ThePrimeagen/harpoon",
				config = function()
					require("config.harpoon").setup()
				end,
			},
		},
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
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
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
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
			"b0o/schemastore.nvim",
			"jose-elias-alvarez/typescript.nvim",
			"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
			"lvimuser/lsp-inlayhints.nvim",
			"ray-x/lsp_signature.nvim",
			"pierreglaser/folding-nvim",
			{
				"RRethy/vim-illuminate",
				config = function()
					require("config.illuminate").setup()
				end,
			},
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				config = function()
					require("fidget").setup()
				end,
			},
			{
				"SmiteshP/nvim-navic",
				config = function()
					require("nvim-navic").setup()
				end,
			},
			{
				"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
				config = function()
					require("lsp_lines").setup()
				end,
			},
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
		enabled = false,
	},

	-- REST
	{
		"vhyrro/luarocks.nvim",
		opts = {
			rocks = {
				"lua-curl",
				"nvim-nio",
				"mimetypes",
				"xml2lua",
			},
		},
		priority = 1000,
		config = true,
	},
	{
		"rest-nvim/rest.nvim",
		dependencies = { "luarocks.nvim" },
		ft = { "http", "https" },
		keys = {
			{
				"<localleader>rr",
				"<cmd>Rest run<cr>",
				desc = "Run request under the cursor",
			},
			{
				"<localleader>rl",
				"<cmd>Rest run last<cr>",
				desc = "Re-run latest request",
			},
		},
		config = function()
			require("rest-nvim").setup({
				result = {
					keybinds = {
						buffer_local = false,
						prev = "N",
						next = "O",
					},
				},
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

	-- Task Runner and Job Management
	{
		"stevearc/overseer.nvim",
		opts = {},
	},

	-- Go
	--{
	--	"ray-x/go.nvim",
	--	ft = { "go" },
	--	config = function()
	--		require("go").setup()
	--	end,
	--	enabled = false,
	--},

	-- Java
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},

	-- Scratch Buffer
	{
		"mtth/scratch.vim",
	},

	-- Dimming inactive panes
	{
		"levouh/tint.nvim",
		config = function()
			require("tint").setup()
		end,
	},

	-- Aerial
	{
		"stevearc/aerial.nvim",
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},

	-- Improved Searching
	{
		"backdround/improved-search.nvim",
		config = function()
			require("config.improved-search").setup()
		end,
	},

	-- Trouble
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- Align
	{
		"Vonr/align.nvim",
		branch = "v2",
		lazy = true,
		init = function()
			require("config.align").init()
		end,
	},

	-- Markdown
	{
		"jakewvincent/mkdnflow.nvim",
		config = function()
			require("config.mkdnflow").setup()
		end,
		enabled = true,
	},

	-- Better navigation with Tab
	{
		"boltlessengineer/smart-tab.nvim",
		config = function()
			require("smart-tab").setup()
		end,
	},

	-- Improved quickfix list
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			require("bqf").setup({
				func_map = {
					drop = "k",
					openc = "K",
				},
				--filter = {
				--	fzf = {
				--		action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
				--		extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
				--	},
				--},
			})
		end,
	},

	-- Markdown Images
	{
		"edluffy/hologram.nvim",
		config = function()
			require("hologram").setup({
				auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
			})
		end,
		enabled = false,
	},

	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		config = function()
			-- these keymaps will also accept a range,
			--vim.keymap.set('n', '<A-n>', require('smart-splits').resize_left)
			--vim.keymap.set('n', '<A-e>', require('smart-splits').resize_down)
			--vim.keymap.set('n', '<A-i>', require('smart-splits').resize_up)
			--vim.keymap.set('n', '<A-o>', require('smart-splits').resize_right)
			-- moving between splits
			vim.keymap.set("n", "<C-n>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-e>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-i>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-o>", require("smart-splits").move_cursor_right)
			-- swapping buffers between windows
			vim.keymap.set("n", "<leader><leader>n", require("smart-splits").swap_buf_left)
			vim.keymap.set("n", "<leader><leader>e", require("smart-splits").swap_buf_down)
			vim.keymap.set("n", "<leader><leader>i", require("smart-splits").swap_buf_up)
			vim.keymap.set("n", "<leader><leader>o", require("smart-splits").swap_buf_right)
		end,
	},
})
