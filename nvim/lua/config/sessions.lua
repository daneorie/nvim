local M = {}

function M.setup()
	require("sessions").setup({
		events = { "WinEnter" },
		session_filepath = "~/.nvim/session",
	})
end

return M
