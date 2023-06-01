local M = {}

function M.setup()
	-- Indicate first time installation
	local is_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		max_jobs = 8,
		profile = {
			enable = true,
			--threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			PACKER_BOOTSTRAP = fn.system({
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			})
			print("Installing packer close and reopen Neovim...")
			vim.cmd([[packadd packer.nvim]])
			is_bootstrap = true
		end

		-- Run PackerCompile if there are changes in this file
		-- vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerSync"
		local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			pattern = "plugins.lua",
			callback = function(ev)
				require("plugins").setup()
				require("packer").sync()
				require("packer").compile()
			end,
			group = packer_grp,
		})
	end

	-- Plugins
	local function plugins(use)
		use({ "wbthomason/packer.nvim" })

		-- Performance
		use({ "lewis6991/impatient.nvim" })
		--use {
		--"lewis6991/impatient.nvim",
		--config = function() require("impatient").enable_profile() end
		--}

		-- Load only when require
		use({ "nvim-lua/plenary.nvim", module = "plenary" })

		-- Notification
		use({
			"rcarriga/nvim-notify",
			event = "BufReadPre",
			config = function()
				require("config.notify").setup()
			end,
			disable = false,
		})
		use({
			"simrat39/desktop-notify.nvim",
			config = function()
				require("desktop-notify").override_vim_notify()
			end,
			disable = true,
		})
		use({
			"vigoux/notifier.nvim",
			config = function()
				require("notifier").setup({})
			end,
			disable = true,
		})

		-- Colorschemes
		use({
			"EdenEast/nightfox.nvim",
			config = function()
				vim.cmd.colorscheme([[nightfox]])
			end,
			disable = false,
		})

		-- Git
		use({ -- show git decorations in buffers
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup()
			end,
		})
		use({ -- git commands
			"tpope/vim-fugitive",
			opt = true,
			cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
		})
		use({
			"f-person/git-blame.nvim",
			cmd = { "GitBlameToggle" },
		})

		-- WhichKey
		use({
			"folke/which-key.nvim",
			event = "VimEnter",
			module = { "which-key" },
			config = function()
				require("config.which-key").setup()
			end,
			disable = false,
		})
		use({
			"mrjones2014/legendary.nvim",
			config = function()
				require("legendary").setup({ which_key = { auto_register = true } })
			end,
			disable = true,
		})

		-- IndentLine
		use({
			"lukas-reineke/indent-blankline.nvim",
			event = "BufReadPre",
			config = function()
				require("config.indent-blankline").setup()
			end,
		})

		-- Better icons
		use({
			"kyazdani42/nvim-web-devicons",
			module = "nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({ default = true })
			end,
		})

		-- Better comment
		use({
			"numToStr/Comment.nvim",
			--keys = { "gc", "gcc", "gbc" },
			config = function()
				require("config.comment").setup()
			end,
			disable = false,
		})

		-- Better surround
		use({
			"kylechui/nvim-surround",
			config = function()
				require("config.surround").setup()
			end,
		})
		use({
			"andymass/vim-matchup",
			setup = function()
				-- may set any options here
				vim.g.matchup_matchparen_offscreen = { method = "popup" }
			end,
			config = function()
				require("config.vim-matchup").setup()
			end,
			disable = true, -- until I can ignore the text object mappings, this must be disabled
		})

		-- IDE
		use({
			"mbbill/undotree",
			cmd = { "UndotreeToggle" },
			config = function()
				require("config.undotree").setup()
			end,
		})

		-- Jumps
		use({
			"christoomey/vim-tmux-navigator",
			config = function()
				require("config.vim-tmux-navigator").setup()
			end,
		})
		use({
			"phaazon/hop.nvim",
			cmd = "HopWord",
			module = "hop",
			keys = { "f", "F", "t", "T" },
			config = function()
				require("config.hop").setup()
			end,
			disable = true,
		})
		use({
			"jinh0/eyeliner.nvim",
			config = function()
				require("eyeliner").setup({
					highlight_on_key = true, -- show highlights only after keypress
					dim = false, -- dim all other characters if set to true (recommended!)
				})
			end,
		})
		use({
			"ggandor/leap.nvim",
			requires = { "tpope/vim-repeat" },
			config = function()
				require("leap").add_default_mappings()
			end,
		})

		-- Markdown
		use({
			"iamcco/markdown-preview.nvim",
			opt = true,
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
			ft = "markdown",
			cmd = { "MarkdownPreview" },
			requires = {
				{ "zhaozg/vim-diagram" },
				{ "aklt/plantuml-syntax" },
			},
		})

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			event = "BufReadPre",
			config = function()
				require("config.lualine").setup()
			end,
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
			requires = {
				{ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPre" },
				{
					"windwp/nvim-ts-autotag",
					event = "InsertEnter",
					config = function()
						require("nvim-treesitter.configs").setup({ autotag = { enable = true } })
					end,
				},
			},
		})

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			event = { "VimEnter" },
			config = function()
				require("config.telescope").setup()
			end,
			requires = {
				{ "nvim-lua/popup.nvim" },
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				{ "nvim-telescope/telescope-file-browser.nvim" },
				{ "nvim-telescope/telescope-dap.nvim" },
				{
					"AckslD/nvim-neoclip.lua",
					requires = {
						{ "tami5/sqlite.lua", module = "sqlite" },
					},
					config = function()
						require("config.neoclip").setup()
					end,
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
				{ "daneorie/telescope-insert-path.nvim" },
				{ "LinArcX/telescope-env.nvim" },
				{
					"LukasPietzschmann/telescope-tabs",
					config = function()
						require("telescope-tabs").setup()
					end,
				},
				{ "nvim-telescope/telescope-hop.nvim" },
				{
					"nvim-telescope/telescope-ui-select.nvim",
					config = function()
						require("config.telescope-ui-select").setup()
					end,
				},
			},
		})

		-- File Explorer
		use({
			"nvim-tree/nvim-tree.lua",
			--opt = true,
			--cmd = { "NvimTreeToggle", "NvimTreeClose" },
			commit = "6117582578d2e5b81212f04db4ad206836bcd24a",
			config = function()
				require("config.nvim-tree").setup()
			end,
		})
		use({
			"stevearc/oil.nvim",
			config = function()
				require("config.oil").setup()
			end,
		})

		-- Completion
		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			opt = true,
			config = function()
				require("config.cmp").setup()
			end,
			requires = {
				{ "hrsh7th/cmp-buffer" }, -- buffer completions
				{ "hrsh7th/cmp-path" }, -- path completions
				{ "hrsh7th/cmp-nvim-lua" },
				{ "hrsh7th/cmp-cmdline" },
				{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
				{ "hrsh7th/cmp-nvim-lsp", module = { "cmd_nvim_lsp" } },
				{
					"L3MON4D3/LuaSnip",
					config = function()
						--require("config.snip").setup()
					end,
					module = { "luasnip" },
				},
			},
		})

		-- Auto pairs
		use({ -- Autopairs, integrates with both cmp and treesitter
			"windwp/nvim-autopairs",
			opt = true,
			event = "InsertEnter",
			module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
			config = function()
				require("config.autopairs").setup()
			end,
		})

		-- Auto tag
		use({
			"windwp/nvim-ts-autotag",
			opt = true,
			event = "InsertEnter",
			config = function()
				require("nvim-ts-autotag").setup({ enable = true })
			end,
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("config.lsp").setup()
			end,
			requires = {
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
				{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
				{ "jayp0521/mason-null-ls.nvim" },
				{ "folke/neodev.nvim" },
				{
					"RRethy/vim-illuminate",
					config = function()
						require("config.illuminate").setup()
					end,
				},
				{ "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
				{
					"j-hui/fidget.nvim",
					config = function()
						require("fidget").setup()
					end,
				},
				{ "b0o/schemastore.nvim", module = { "schemastore" } },
				{ "jose-elias-alvarez/typescript.nvim", module = { "typescript" } },
				{
					"SmiteshP/nvim-navic",
					config = function()
						require("nvim-navic").setup()
					end,
					module = { "nvim-navic" },
				},
				{ "lvimuser/lsp-inlayhints.nvim" },
				--{
				--	"simrat39/inlay-hints.nvim",
				--	config = function()
				--		require("inlay-hints").setup()
				--	end,
				--},
				{
					"zbirenbaum/neodim",
					event = "LspAttach",
					config = function()
						require("config.neodim").setup()
					end,
					disable = true,
				},
				{
					"theHamsta/nvim-semantic-tokens",
					config = function()
						require("config.semantictokens").setup()
					end,
					disable = true,
				},
				{
					"David-Kunz/markid",
					disable = true,
				},
				{
					"simrat39/symbols-outline.nvim",
					cmd = { "SymbolsOutline" },
					config = function()
						require("symbols-outline").setup()
					end,
					disable = true,
				},
				--{
				--	"weilbith/nvim-code-action-menu",
				--	cmd = "CodeActionMenu",
				--},
				--{
				--	"rmagatti/goto-preview",
				--	config = function()
				--		require("goto-preview").setup({})
				--	end,
				--},
				{
					"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
					config = function()
						require("lsp_lines").setup()
					end,
				},
				{ "ray-x/lsp_signature.nvim" },
				{ "pierreglaser/folding-nvim" },
			},
		})

		-- lspsaga.nvim
		use({
			"glepnir/lspsaga.nvim",
			cmd = { "Lspsaga" },
			config = function()
				require("config.lspsaga").setup()
			end,
		})

		-- Rust
		use({
			"simrat39/rust-tools.nvim",
			ft = { "rust" },
			module = "rust-tools",
			requires = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
			opt = true,
		})
		use({
			"saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			requires = { { "nvim-lua/plenary.nvim" } },
			config = function()
				require("crates").setup({
					null_ls = {
						enabled = true,
						name = "crates.nvim",
					},
				})
			end,
			disable = false,
		})

		-- Go
		use({
			"ray-x/go.nvim",
			ft = { "go" },
			config = function()
				require("go").setup()
			end,
			disable = true,
		})

		-- Java
		use({
			"mfussenegger/nvim-jdtls",
			ft = { "java" },
		})

		-- Terminal
		use({
			"akinsho/toggleterm.nvim",
			keys = { [[<C-\>]] },
			cmd = { "ToggleTerm", "TermExec" },
			module = { "toggleterm", "toggleterm.terminal" },
			config = function()
				require("config.toggleterm").setup()
			end,
		})

		-- Debugging
		use({
			"mfussenegger/nvim-dap",
			opt = true,
			module = { "dap" },
			requires = {
				{ "theHamsta/nvim-dap-virtual-text", module = { "nvim-dap-virtual-text" } },
				{ "rcarriga/nvim-dap-ui", module = { "dapui" } },
				{ "mfussenegger/nvim-dap-python", module = { "dap-python" } },
				{ "nvim-telescope/telescope-dap.nvim" },
				{ "leoluz/nvim-dap-go", module = "dap-go" },
				{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
				{ "mxsdev/nvim-dap-vscode-js", module = { "dap-vscode-js" } },
				{
					"microsoft/vscode-js-debug",
					opt = true,
					run = "npm install --legacy-peer-deps && npm run compile",
					disable = false,
				},
			},
			config = function()
				require("config.dap").setup()
			end,
			disable = false,
		})

		-- vimspector
		use({
			"puremourning/vimspector",
			cmd = { "VimspectorInstall", "VimspectorUpdate" },
			fn = { "vimspector#Launch()", "vimspector#ToggleBreakpoint", "vimspector#Continue" },
			config = function()
				require("config.vimspector").setup()
			end,
			disable = true,
		})

		-- Harpoon
		use({
			"ThePrimeagen/harpoon",
			config = function()
				require("config.harpoon").setup()
			end,
		})

		-- Refactoring
		use({
			"ThePrimeagen/refactoring.nvim",
			module = { "refactoring", "telescope" },
			keys = { [[<leader>r]] },
			config = function()
				require("config.refactoring").setup()
			end,
		})

		-- Session
		use({
			"rmagatti/auto-session",
			opt = true,
			cmd = { "SaveSession", "RestoreSession" },
			requires = { "rmagatti/session-lens" },
			config = function()
				require("auto-session").setup()
			end,
			disable = true,
		})

		-- Quickfix
		use({
			"romainl/vim-qf",
			event = "BufReadPre",
			disable = true,
		})

		-- Sidebar
		use({
			"sidebar-nvim/sidebar.nvim",
			cmd = { "SidebarNvimToggle" },
			config = function()
				require("sidebar-nvim").setup({ open = false })
			end,
		})
		use({
			"stevearc/aerial.nvim",
			module = { "aerial", "telescope._extensions.aerial" },
			cmd = { "AerialToggle" },
			config = function()
				require("aerial").setup({
					backends = { "treesitter", "lsp" },
					on_attach = function(bufnr)
						vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
						vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
					end,
				})
			end,
		})

		-- Lua Development
		use({ "folke/lua-dev.nvim" })
		use({ "folke/neodev.nvim" })

		-- Marks
		use({ "MattesGroeger/vim-bookmarks" })
		use({
			"natecraddock/sessions.nvim",
			config = function()
				require("config.sessions").setup()
			end,
		})
		use({
			"natecraddock/workspaces.nvim",
			config = function()
				require("config.workspaces").setup()
			end,
		})

		-- Fuzzy Finder/Telescope/Navigation
		use({
			"junegunn/fzf.vim",
			requires = { "junegunn/fzf", run = ":call fzf#install()" },
		})
		--use {
		--"adoyle-h/lsp-toggle.nvim",
		--config = function()
		--require("lsp-toggle").setup()
		--end,
		--}
		use({ "ThePrimeagen/git-worktree.nvim" })

		-- Note Taking
		use({
			"lervag/wiki.vim",
			config = function()
				require("config.wiki").setup()
			end,
		})
		use({
			"lervag/lists.vim",
			config = function()
				require("config.lists").setup()
			end,
		})
		use({
			"dhruvasagar/vim-table-mode",
			config = function()
				require("config.vim-table-mode").setup()
			end,
		})
		use({ "junegunn/vim-easy-align" })
		use({
			"itchyny/calendar.vim",
			config = function()
				require("config.calendar").setup()
			end,
		})

		-- Multi-buffer Editing
		use({
			"pelodelfuego/vim-swoop",
			config = function()
				require("config.vim-swoop").setup()
			end,
		})
		use({ "AckslD/muren.nvim" })

		-- Ulility
		use({ -- a fast code completion engine
			"neoclide/coc.nvim",
			branch = "release",
		})
		use({
			"mg979/vim-visual-multi",
			branch = "master",
			config = function()
				require("config.vim-visual-multi").setup()
			end,
		})
		use({
			"folke/zen-mode.nvim",
			config = function()
				require("config.zen-mode").setup()
			end,
		})

		use({
			"tpope/vim-unimpaired",
			requires = { "tpope/vim-repeat" },
		})

		-- Bootstrap Neovim
		if is_bootstrap then
			print("Neovim restart is required after installation!")
			require("packer").sync()
		end
	end

	-- Init and start packer
	packer_init()
	local packer = require("packer")

	-- Performance
	pcall(require, "impatient")
	-- pcall(require, "packer_compiled")

	packer.init(conf)
	packer.startup(plugins)
end

return M
