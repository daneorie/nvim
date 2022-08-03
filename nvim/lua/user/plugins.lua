local fn = vim.fn

-- Automatically install packer
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
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return require("packer").startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim"
	use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
	use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
	use "bagrat/vim-buffet" -- buffer labeling
	use "preservim/nerdcommenter" -- an easy way for commenting out lines
	--use "preservim/nerdtree" -- a file explorer for neovim (netrw comes as default for neovim)
	use "ryanoasis/vim-devicons" -- devicon support for nerdtree
	use {
		"nvim-lualine/lualine.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			opt = true
		},
	}
	use {
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons"
		},
	}
	use "lewis6991/impatient.nvim"
	use "lukas-reineke/indent-blankline.nvim"
	use "mhinz/vim-startify" -- a really handy start page with lots of customizations
	use { "neoclide/coc.nvim", branch = "release" } -- a fast code completion engine
	use "akinsho/toggleterm.nvim"
	use "nvim-orgmode/orgmode"
	use "folke/which-key.nvim"
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use { "mg979/vim-visual-multi", branch = "master" }
 
	-- Colorschemes
	use "EdenEast/nightfox.nvim" -- theme

	-- cmp plugins
	use "hrsh7th/nvim-cmp" -- The completion plugin
	use "hrsh7th/cmp-buffer" -- buffer completions
	use "hrsh7th/cmp-path" -- path completions
	use "saadparwaiz1/cmp_luasnip" -- snippet completions
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-nvim-lua"

	-- snippets
	use "L3MON4D3/LuaSnip" -- snippet engine
	use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- LSP
	use "neovim/nvim-lspconfig" -- enable LSP
	--use "williamboman/nvim-lsp-installer" -- simple to use language server installer
	use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
	use "mfussenegger/nvim-jdtls" -- Java LSP

	-- Telescope
	use { "nvim-telescope/telescope.nvim", tag = "0.1.0", }
	use "nvim-telescope/telescope-file-browser.nvim"

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
	}
	use "nvim-treesitter/nvim-treesitter-textobjects"

	-- Git
	--use "Xuyuanp/nerdtree-git-plugin" -- show git status flags in NERDTree
	use "lewis6991/gitsigns.nvim" -- show git decorations in buffers

	-- DAP
	use "mfussenegger/nvim-dap"
	use "rcarriga/nvim-dap-ui"
	use "ravenxrz/DAPInstall.nvim"

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
