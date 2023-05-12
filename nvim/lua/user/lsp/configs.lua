local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

print("mason-lspconfig")
local lspconfig = require("lspconfig")

local servers = {
	"clangd",
	"cssls",
	"html",
	"jsonls",
	"tsserver",
	"ruby_ls",
	"lua_ls",
}

lsp_installer.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

--lspconfig.lua.setup{
	--settings = {
		--Lua = {
			--diagnostics = {
				--globals = { "vim" }
			--}
		--}
	--}
--}

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
