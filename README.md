# nvim

## Basic Setup
Requires the installation of [fd](https://github.com/sharkdp/fd), [fzf](https://github.com/junegunn/fzf). I used [Homebrew](https://brew.sh) for such installations.

Install NeoVim
```
brew install neovim
```

Node is necessary for some plugins
```
brew install node
```

Antigen is the plugin manager for zsh
```
brew install antigen
```

For proper devicon support, a patched font must be added to the terminal.
```
brew tap homebrew/cask-fonts
brew install font-bitstream-vera-sans-mono-nerd-font
```
Then select the BitStream font in the terminal for proper devicon support

In order to not have issues with Alt commands in iTerm2, set the 'Option key' to 'Esc+' in
Preferences > Profiles > Keys > General.

Set or create an environment variable NVIM_HOME in the 'rc' file to the location of the nvim directory. Currently, this is only referenced for the swap file directory.
```
set NVIM_HOME="/path/to/nvim/"
```

## Java LSP Setup (configuration files are already setup)
Download [eclipse.jdt.ls](https://github.com/eclipse/eclipse.jdt.ls#installation) to `/Library/Java/LanguageServers`

Clone and build in `$HOME/Documents/GitHub/`:
* [java-debug](https://github.com/microsoft/java-debug)
```
./mvnw clean install
```
* [vscode-java-test](https://github.com/microsoft/vscode-java-test)
```
npm install; npm run build-plugin
```


1. Install the various JDKs.
	```
	brew install openjdk@11 # for example
	```
2. Link them to `/Library/Java/JavaVirtualMachines`.
	```
	sudo ln -sfn ~/Documents/zulu-OpenJDK/openjdk-11.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
	```
3. Add `Contents/Home` to `jenv`. If an installation fails (for ARM or something), use [zulu](https://www.azul.com/downloads/?version=java-8-lts&architecture=arm-64-bit&package=jdk) instead.
	```
	jenv add /Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home
	```

## Plugin List
* [packer.nvim](https://github.com/wbthomason/packer.nvim)
* [popup.nvim](https://github.com/nvim-lua/popup.nvim)
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
* [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
* [vim-buffet](https://github.com/bagrat/vim-buffet)
* [nerdcommenter](https://github.com/preservim/nerdcommenter)
* ~~[nerdtree](https://github.com/preservim/nerdtree)~~
* [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
* [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
* [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
* [impatient.nvim](https://github.com/lewis6991/impatient.nvim)
* [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
* [vim-startify](https://github.com/mhinz/vim-startify)
* [coc.nvim](https://github.com/neoclide/coc.nvim)
* [vim-devicons](https://github.com/ryanoasis/vim-devicons)
* [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
* [orgmode](https://github.com/nvim-orgmode/orgmode)
* [whick-key.nvim](https://github.com/folke/which-key.nvim)
* [vim-visual-multi](https://github.com/mg979/vim-visual-multi)
 
-- Colorschemes
* [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)

-- cmp plugins
* [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
* [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
* [cmp-path](https://github.com/hrsh7th/cmp-path)
* [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
* [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
* [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)

-- snippets
* [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
* [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)

-- LSP
* [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)
* [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)

-- Telescope
* [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
* [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)

-- Treesitter
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
* [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

-- Git
* ~~[nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)~~
* [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

-- DAP
* [nvim-dap](https://github.com/mfussenegger/nvim-dap)
* [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
* [DAPInstall.nvim](https://github.com/ravenxrz/DAPInstall.nvim)
