return {
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			hint = {
				enable = true,
				arrayIndex = "Disable",
				await = true,
				paramName = "Disable",
				paramType = false,
				semicolon = "Disable",
				setType = true,
			},
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				special = {
					reload = "require",
				},
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.stdpath "config" .. "/lua"] = true,
				},
			},
			-- Do not send telemetry data containing a randomized but unique indentifier
			telemetry = {
				enable = false,
			},
		},
	},
}
