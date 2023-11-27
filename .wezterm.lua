-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "nordfox"
config.window_background_opacity = 0.6
config.text_background_opacity = 0.6
config.macos_window_background_blur = 40
config.enable_kitty_keyboard = true
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false

local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end

	local success, _, _ = wezterm.run_child_process({
		"sh",
		"-c",
		"ps -o state= -o comm= -t"
			.. wezterm.shell_quote_arg(tty)
			.. " | "
			.. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
	})

	return success
end

local function is_outside_vim(pane)
	return not is_inside_vim(pane)
end

local function bind_if(cond, key, mods, action, alt_str)
	local function callback(win, pane)
		if cond(pane) then
			win:perform_action(action, pane)
		elseif alt_str then
			win:perform_action(act.SendString(alt_str), pane)
		else
			win:perform_action(act.SendKey({ key = key, mods = mods }), pane)
		end
	end

	return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

local format_title = function(title, is_active, max_width)
	local background = { Background = { Color = "#1f1f28" } }
	local title_len = #title
	local pad_left_len = math.floor((max_width - title_len) / 2) - 1
	local pad_right_len = max_width - pad_left_len - title_len - 2

	local formatted_title = {
		Text = "|" .. string.rep(" ", pad_left_len) .. title .. string.rep(" ", pad_right_len) .. "|",
	}
	if is_active then
		return { background, { Foreground = { Color = "#957fb8" } }, formatted_title }
	else
		return { background, { Foreground = { Color = "#cad3f5" } }, formatted_title }
	end
end

-- Equivalent to POSIX basename(3)
local function basename(s)
	return s:gsub("(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- if there is title already set, proceed with it
	if type(tab.tab_title) == "string" and #tab.tab_title > 0 then
		return format_title(tab.tab_title, tab.is_active, max_width)
	end

	local title = tab.active_pane.title
	if title == "nvim" then
		title = basename(tab.active_pane.current_working_dir)
	end

	return format_title(title, tab.is_active, max_width)
end)

wezterm.on("toggle-ligatures", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.harfbuzz_features then
		overrides.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
	else
		overrides.harfbuzz_features = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-transparency", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
		overrides.text_background_opacity = 1.0
		overrides.macos_window_background_blur = 0
	else
		overrides.window_background_opacity = nil
		overrides.text_background_opacity = nil
		overrides.macos_window_background_blur = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("update-status", function(window, pane)
	local key_table = window:active_key_table() or "default"
	window:set_left_status(" " .. key_table .. " ")

	local workspace = window:active_workspace() or ""
	local cwd = basename(pane:get_current_working_dir()) or ""
	local cmd = basename(pane:get_foreground_process_name()) or ""
	local time = wezterm.strftime("%H:%M")
	window:set_right_status(wezterm.format({
		{ Text = "| " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. workspace },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "FFB86C" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = " |" },
	}))
end)

config.leader = { key = "Space", mods = "ALT" }
config.keys = {
	-- LEADER
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "l", mods = "LEADER", action = act.EmitEvent("toggle-ligatures") },
	{ key = "t", mods = "LEADER", action = act.EmitEvent("toggle-transparency") },

	-- basic usage
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "n", mods = "CMD|SHIFT", action = act.SpawnWindow },
	{ key = "n", mods = "CMD|ALT", action = act.SwitchToWorkspace },
	{ key = "Enter", mods = "CMD", action = act.ActivateCopyMode },

	-- wezterm navigation
	{ key = "[", mods = "CMD", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = act.ActivateTabRelative(1) },
	{ key = "6", mods = "CTRL", action = act.ActivateLastTab },
	{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "LeftArrow", mods = "CMD", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "DownArrow", mods = "CMD", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "UpArrow", mods = "CMD", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "RightArrow", mods = "CMD", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- Wezterm & NeoVim Pane Navigation
	bind_if(is_outside_vim, "n", "CTRL", act.ActivatePaneDirection("Left")),
	bind_if(is_outside_vim, "e", "CTRL", act.ActivatePaneDirection("Down")),
	bind_if(is_outside_vim, "i", "CTRL", act.ActivatePaneDirection("Up"), "\x33[105;5u"),
	bind_if(is_outside_vim, "o", "CTRL", act.ActivatePaneDirection("Right")),

	-- 5u - ctrl -- these overlaps require \x33 instead of \x1b, which will need to be interpretted by NeoVim
	{ key = "[", mods = "CTRL", action = act.SendString("\x33[91;5u") }, -- ctrl-[ - overlaps ESC
	{ key = "h", mods = "CTRL", action = act.SendString("\x33[104;5u") }, -- ctrl-h - overlaps BS/Backspace
	--{ key = "i", mods = "CTRL", action = act.SendString("\x33[105;5u") }, -- ctrl-i - overlaps TAB
	{ key = "m", mods = "CTRL", action = act.SendString("\x33[109;5u") }, -- ctrl-m - overlaps CR/Enter

	{ key = ";", mods = "CMD", action = act.SendString("\x1b;") },
	{ key = "a", mods = "CMD", action = act.SendString("\x1ba") },
	{ key = "b", mods = "CMD", action = act.SendString("\x1bb") },
	--{ key = "c", mods = "CMD", action = act.SendString("\x1bc") },
	--{ key = "d", mods = "CMD", action = act.SendString("\x1bd") },
	{ key = "e", mods = "CMD", action = act.SendString("\x1be") },
	{ key = "f", mods = "CMD", action = act.SendString("\x1bf") },
	{ key = "g", mods = "CMD", action = act.SendString("\x1bg") },
	{ key = "h", mods = "CMD", action = act.SendString("\x1bh") },
	{ key = "i", mods = "CMD", action = act.SendString("\x1bi") },
	{ key = "j", mods = "CMD", action = act.SendString("\x1bj") },
	{ key = "k", mods = "CMD", action = act.SendString("\x1bk") },
	{ key = "l", mods = "CMD", action = act.SendString("\x1bl") },
	{ key = "m", mods = "CMD", action = act.SendString("\x1bm") },
	{ key = "n", mods = "CMD", action = act.SendString("\x1bn") },
	{ key = "o", mods = "CMD", action = act.SendString("\x1bo") },
	{ key = "p", mods = "CMD", action = act.SendString("\x1bp") },
	--{ key = "q", mods = "CMD", action = act.SendString("\x1bq") },
	{ key = "r", mods = "CMD", action = act.SendString("\x1br") },
	{ key = "s", mods = "CMD", action = act.SendString("\x1bs") },
	--{ key = "t", mods = "CMD", action = act.SendString("\x1bt") },
	{ key = "u", mods = "CMD", action = act.SendString("\x1bu") },
	--{ key = "v", mods = "CMD", action = act.SendString("\x1bv") },
	--{ key = "w", mods = "CMD", action = act.SendString("\x1bw") },
	{ key = "x", mods = "CMD", action = act.SendString("\x1bx") },
	{ key = "y", mods = "CMD", action = act.SendString("\x1by") },
	{ key = "z", mods = "CMD", action = act.SendString("\x1bz") },

	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	-- rename the tab
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- switch between a list of workspaces
	{
		key = "s",
		mods = "SHIFT|CMD",
		action = wezterm.action_callback(function(window, pane)
			local home = wezterm.home_dir
			local workspaces = {
				{ id = home .. "/dotfiles|", label = home .. "/dotfiles" },
				{ id = "/Users/daneorie/wiki|/usr/local/bin/nvim +WikiIndex", label = "/Users/daneorie/wiki" },
			}

			for _, path in ipairs(wezterm.glob(home .. "/repos/*")) do
				table.insert(workspaces, {
					id = path .. "|",
					label = path,
				})
			end

			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							local name = label:gsub("^.*/", "")
							local cwd = id:gsub("|.*", "")
							local args = mysplit(id:gsub(".*|", ""), " ")
							wezterm.log_info("name = " .. name)
							wezterm.log_info("label = " .. label)
							wezterm.log_info("cwd = " .. cwd)
							inner_window:perform_action(
								act.SwitchToWorkspace({
									--name = label,
									name = name,
									spawn = {
										label = "Workspace: " .. label,
										args = args,
										cwd = cwd,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
				}),
				pane
			)
		end),
	},
}

for i = 1, 9 do
	-- CMD + number to activate that numbered tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.ActivateTab(i - 1),
	})
end

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "n", mods = "NONE", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "n", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "e", mods = "NONE", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "e", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "i", mods = "NONE", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "i", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "o", mods = "NONE", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "o", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
	copy_mode = {
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "/", mods = "NONE", action = act.Search({ CaseSensitiveString = "" }) },
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "N", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "N", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "K", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "K", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "a", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "h", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "n", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "i", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = ",", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = ".", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "y", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
	},
	search_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "h", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
	},
}

-- and finally, return the configuration to wezterm
return config
