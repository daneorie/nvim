local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

local servers = {
	"clangd",
	"cssls",
	"cssmodules_ls",
	"html",
	"jsonls",
	"tsserver",
	"lua_ls",
	"ruby_ls",
}

local settings = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "lua_ls" then
		local l_status_ok, lua_dev = pcall(require, "neo-dev")
		if not l_status_ok then
			return
		end

		local luadev = lua_dev.setup({
			lspconfig = {
				on_attach = opts.on_attach,
				capabilities = opts.capabilities,
			},
		})
		lspconfig.lua_ls.setup(luadev)
		goto continue
	end

	if server == "tsserver" then
		local tsserver_opts = require("user.lsp.settings.tsserver")
		opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
	end

	if server == "jdtls" then
		goto continue
	end

	lspconfig[server].setup(opts)
	::continue::
end

-- Set a formatter.
--local formatters = require "lvim.lsp.null-ls.formatters"
--formatters.setup {
  --{ command = "prettier", filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "css" } },
--}

print("dap-vscode-js")
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
require("dap-vscode-js").setup {
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_path = mason_path .. "packages/js-debug-adapter", -- Path to vscode-js-debug installation.
	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
}

for _, language in ipairs { "typescript", "javascript" } do
	print(language .. " dap configuration")
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end

-- Set a linter.
-- local linters = require("lvim.lsp.null-ls.linters")
-- linters.setup({
--   { command = "eslint", filetypes = { "javascript", "typescript" } },
-- })
