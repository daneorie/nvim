-- UNUSED
local M = {}

function M.setup()
	local icons = require "config.icons2"

	require("nvim-navic").setup({
		icons = {
			File = icons.documents.File .. " ",
			Module = icons.kind.Module .. " ",
			Namespace = icons.kind.Namespace .. " ",
			Package = icons.kind.Package .. " ",
			Class = icons.kind.Class .. " ",
			Method = icons.kind.Method .. " ",
			Property = icons.kind.Property .. " ",
			Field = icons.kind.Field .. " ",
			Constructor = icons.kind.Constructor .. " ",
			Enum = icons.kind.Enum .. " ",
			Interface = icons.kind.Interface .. " ",
			Function = icons.kind.Function .. " ",
			Variable = icons.kind.Variable .. " ",
			Constant = icons.kind.Constant .. " ",
			String = icons.type.String .. " ",
			Number = icons.type.Number .. " ",
			Boolean = icons.type.Boolean .. " ",
			Array = icons.type.Array .. " ",
			Object = icons.type.Object .. " ",
			Key = icons.kind.Key .. " ",
			Null = icons.type.Null .. " ",
			EnumMember = icons.kind.EnumMember .. " ",
			Struct = icons.kind.Struct .. " ",
			Event = icons.kind.Event .. " ",
			Operator = icons.kind.Operator .. " ",
			TypeParameter = icons.kind.TypeParameter .. " "

		},
		highlight = true,
		separator = " " .. icons.ui.ChevronRight .. " ",
		depth_limit = 0,
		depth_limit_indicator = "..",
	})

	--vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
end

return M
