-- UNUSED
local M = {}

function M.setup()
	require("project_nvim").setup({
		manual_mode = true,

		-- detection_methods = { "lsp", "pattern" }
		-- NOTE: lsp detection will get annoying with multiple langs in one project
		detection_methods = { "pattern" },

		-- patterns used to detect root dir, when **"pattern"** is in detection_methods
		patterns = { ".git", "Makefile", "package.json", "pom.xml" },
	})

	local tele_status_ok, telescope = pcall(require, "telescope")
	if tele_status_ok then
		telescope.load_extension('projects')
	end
end

return M
