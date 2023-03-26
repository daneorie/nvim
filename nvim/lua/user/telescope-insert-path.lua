local M = {}

local insert_path_n_mappings = {}
local insert_path_i_mappings = {}

local i_status_ok, path_actions = pcall(require, "telescope_insert_path")
if i_status_ok then
	insert_path_n_mappings = {
		["["] = path_actions.insert_relpath_visual,
		["]"] = path_actions.insert_abspath_visual,
		["{"] = path_actions.insert_relpath_insert,
		["}"] = path_actions.insert_abspath_insert,
		["-"] = path_actions.insert_relpath_normal,
		["="] = path_actions.insert_abspath_normal,
	}
	insert_path_i_mappings = {
		["\x33[91;5u"] = path_actions.insert_relpath_visual, -- <C-[>
		["\x33[93;5u"] = path_actions.insert_abspath_visual, -- <C-]>
		["\x33[91;6u"] = path_actions.insert_relpath_insert, -- <C-{>
		["\x33[93;6u"] = path_actions.insert_abspath_insert, -- <C-}>
		["\x33[45;5u"] = path_actions.insert_relpath_normal, -- <C-->
		["\x33[61;5u"] = path_actions.insert_abspath_normal, -- <C-=>
	}
end

function M.n_mappings() return insert_path_n_mappings end
function M.i_mappings() return insert_path_i_mappings end

return M
