local M = {}

local hop = require("hop")
local directions = require("hop.hint").HintDirection
local keymap = vim.keymap.set

function M.setup()
	hop.setup({ keys = "arstdhneioqwfpgjluy;ARSTDHNEIOQWFPGJLUY:" })

	vim.keymap.set({"n", "x"}, "f", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
	end, {remap=true})
	vim.keymap.set({"n", "x"}, "F", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
	end, {remap=true})
	vim.keymap.set({"n", "x"}, "t", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
	end, {remap=true})
	vim.keymap.set({"n", "x"}, "T", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
	end, {remap=true})
	vim.keymap.set({"n", "x"}, "+", function()
		hop.hint_lines_skip_whitespace({ direction = directions.AFTER_CURSOR })
	end, {remap=true})
	vim.keymap.set({"n", "x"}, "-", function()
		hop.hint_lines_skip_whitespace({ direction = directions.BEFORE_CURSOR })
	end, {remap=true})
end

return M
