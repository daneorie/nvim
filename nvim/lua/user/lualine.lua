local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local icons = require("user.icons")
local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = {
		error = icons.diagnostics.Error .. " ",
		warn = icons.diagnostics.Warning .. " ",
	},
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { -- changes diff symbols
		added = icons.git.Add .. " ",
		modified = icons.git.Mod .. " ",
		removed = icons.git.Remove .. " ",
	},
	cond = hide_in_width
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

-- cool function for progress
local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local navic = require("nvim-navic")
lualine.setup({
	options = {
		icons_enabled = true,
		theme = "solarized_dark",
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "Vista" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { branch, diagnostics },
		lualine_c = { {
			"filename",
			file_status = true,
			path = 0
		} },
		lualine_x = { diff, spaces, "encoding", filetype },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { {
			"filename",
			file_status = true,
			path = 1
		} },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { {
			function()
				return navic.get_location()
			end,
			cond = function()
				return navic.is_available()
			end
		} },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
})
