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

-- This is where you actually apply your config choices

config.window_background_opacity = 0.5
config.text_background_opacity = 0.5
config.macos_window_background_blur = 40
config.enable_kitty_keyboard = true
config.tab_bar_at_bottom = true

local function is_inside_vim(pane)
	local tty = pane:get_tty_name()
	if tty == nil then
		return false
	end

	local success, stdout, stderr = wezterm.run_child_process({
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

local function map(things)
	local t = {}
	for key in string.gmatch(things, "([^,]+)") do
		table.insert(t, act.SendKey({ key = key }))
	end
	return t
end

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

wezterm.on("update-right-status", function(window, pane)
	window:set_right(window:active_workspace())
end)

config.leader = { key = "Space", mods = "ALT" }
config.keys = {
	-- ALT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- ALT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	--{
	--	key = "a",
	--	mods = "LEADER",
	--	action = act.ActivateKeyTable({
	--		name = "activate_pane",
	--		timeout_milliseconds = 1000,
	--	}),
	--},

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

	-- NeoVim
	bind_if(is_inside_vim, "a", "CMD", act.Multiple(map("Escape,g,g,V,G"))),
	bind_if(is_inside_vim, "s", "CMD", act.Multiple(map("Escape,:,w,Enter"))),

	-- 5u - ctrl -- any overlaps require \x33 instead of \x1b, which will need to be passed on with tmux and interpretted by NeoVim
	{ key = "Tab", mods = "CTRL", action = act.SendString("\x1b[9;5u") }, -- ctrl-tab
	{ key = ",", mods = "CTRL", action = act.SendString("\x1b[44;5u") }, -- ctrl-,
	{ key = "-", mods = "CTRL", action = act.SendString("\x1b[45;5u") }, -- ctrl--
	{ key = ".", mods = "CTRL", action = act.SendString("\x1b[46;5u") }, -- ctrl-.
	{ key = "=", mods = "CTRL", action = act.SendString("\x1b[61;5u") }, -- ctrl-=
	{ key = "[", mods = "CTRL", action = act.SendString("\x33[91;5u") }, -- ctrl-[ - overlaps ESC
	{ key = "]", mods = "CTRL", action = act.SendString("\x1b[93;5u") }, -- ctrl-]
	{ key = "h", mods = "CTRL", action = act.SendString("\x33[104;5u") }, -- ctrl-h - overlaps BS/Backspace
	--{ key = "i", mods = "CTRL", action = act.SendString("\x33[105;5u") }, -- ctrl-i - overlaps TAB
	{ key = "m", mods = "CTRL", action = act.SendString("\x33[109;5u") }, -- ctrl-m - overlaps CR/Enter

	-- 6u - shift-ctrl
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.SendString("\x1b[9;6u") }, -- shift-ctrl-tab
	{ key = ",", mods = "CTRL|SHIFT", action = act.SendString("\x1b[44;6u") }, -- shift-ctrl-, OR ctrl-<
	{ key = "-", mods = "CTRL|SHIFT", action = act.SendString("\x1b[45;6u") }, -- shift-ctrl-- OR ctrl-_
	{ key = ".", mods = "CTRL|SHIFT", action = act.SendString("\x1b[46;6u") }, -- shift-ctrl-. OR ctrl->
	{ key = "=", mods = "CTRL|SHIFT", action = act.SendString("\x1b[61;6u") }, -- shift-ctrl-= OR ctrl-+
	{ key = "[", mods = "CTRL|SHIFT", action = act.SendString("\x1b[91;6u") }, -- shift-ctrl-[ OR ctrl-{
	{ key = "]", mods = "CTRL|SHIFT", action = act.SendString("\x1b[93;6u") }, -- shift-ctrl-] OR ctrl-}
	{ key = "a", mods = "CTRL|SHIFT", action = act.SendString("\x1b[97;6u") }, -- shift-ctrl-a
	{ key = "b", mods = "CTRL|SHIFT", action = act.SendString("\x1b[98;6u") }, -- shift-ctrl-b
	{ key = "c", mods = "CTRL|SHIFT", action = act.SendString("\x1b[99;6u") }, -- shift-ctrl-c
	{ key = "d", mods = "CTRL|SHIFT", action = act.SendString("\x1b[100;6u") }, -- shift-ctrl-d
	{ key = "e", mods = "CTRL|SHIFT", action = act.SendString("\x1b[101;6u") }, -- shift-ctrl-e
	{ key = "f", mods = "CTRL|SHIFT", action = act.SendString("\x1b[102;6u") }, -- shift-ctrl-b
	{ key = "g", mods = "CTRL|SHIFT", action = act.SendString("\x1b[103;6u") }, -- shift-ctrl-g
	{ key = "h", mods = "CTRL|SHIFT", action = act.SendString("\x1b[104;6u") }, -- shift-ctrl-h
	{ key = "i", mods = "CTRL|SHIFT", action = act.SendString("\x1b[105;6u") }, -- shift-ctrl-i
	{ key = "j", mods = "CTRL|SHIFT", action = act.SendString("\x1b[106;6u") }, -- shift-ctrl-j
	{ key = "k", mods = "CTRL|SHIFT", action = act.SendString("\x1b[107;6u") }, -- shift-ctrl-k
	{ key = "l", mods = "CTRL|SHIFT", action = act.SendString("\x1b[108;6u") }, -- shift-ctrl-l
	{ key = "m", mods = "CTRL|SHIFT", action = act.SendString("\x1b[109;6u") }, -- shift-ctrl-m
	{ key = "n", mods = "CTRL|SHIFT", action = act.SendString("\x1b[110;6u") }, -- shift-ctrl-n
	{ key = "o", mods = "CTRL|SHIFT", action = act.SendString("\x1b[111;6u") }, -- shift-ctrl-o
	{ key = "p", mods = "CTRL|SHIFT", action = act.SendString("\x1b[112;6u") }, -- shift-ctrl-p
	{ key = "q", mods = "CTRL|SHIFT", action = act.SendString("\x1b[113;6u") }, -- shift-ctrl-q
	{ key = "r", mods = "CTRL|SHIFT", action = act.SendString("\x1b[114;6u") }, -- shift-ctrl-r
	{ key = "s", mods = "CTRL|SHIFT", action = act.SendString("\x1b[115;6u") }, -- shift-ctrl-s
	{ key = "t", mods = "CTRL|SHIFT", action = act.SendString("\x1b[116;6u") }, -- shift-ctrl-t
	{ key = "u", mods = "CTRL|SHIFT", action = act.SendString("\x1b[117;6u") }, -- shift-ctrl-u
	{ key = "v", mods = "CTRL|SHIFT", action = act.SendString("\x1b[118;6u") }, -- shift-ctrl-v
	{ key = "w", mods = "CTRL|SHIFT", action = act.SendString("\x1b[119;6u") }, -- shift-ctrl-w
	{ key = "x", mods = "CTRL|SHIFT", action = act.SendString("\x1b[120;6u") }, -- shift-ctrl-x
	{ key = "y", mods = "CTRL|SHIFT", action = act.SendString("\x1b[121;6u") }, -- shift-ctrl-y
	{ key = "z", mods = "CTRL|SHIFT", action = act.SendString("\x1b[122;6u") }, -- shift-ctrl-z

	-- 9u - cmd
	--{ key = ";", mods = "CMD", action = act.SendString("\x1b[59;9u") }, -- cmd-;
	--{ key = "a", mods = "CMD", action = act.SendString("\x1b[97;9u") }, -- cmd-a
	{ key = "e", mods = "CMD", action = act.SendString("\x1b[101;9u") }, -- cmd-e
	{ key = "i", mods = "CMD", action = act.SendString("\x1b[105;9u") }, -- cmd-i
	{ key = "l", mods = "CMD", action = act.SendString("\x1b[108;9u") }, -- cmd-l
	{ key = "n", mods = "CMD", action = act.SendString("\x1b[110;9u") }, -- cmd-n
	{ key = "o", mods = "CMD", action = act.SendString("\x1b[111;9u") }, -- cmd-o
	--{ key = "s", mods = "CMD", action = act.SendString("\x1b[115;9u") }, -- cmd-s
	{ key = "u", mods = "CMD", action = act.SendString("\x1b[117;9u") }, -- cmd-u
	{ key = "y", mods = "CMD", action = act.SendString("\x1b[121;9u") }, -- cmd-y

	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
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
}

config.key_tables = {
	--unbind   -T copy-mode-vi C-d
	--bind-key -T copy-mode-vi C-u send-keys -X half-page-down
	--bind-key -T copy-mode-vi C-y send-keys -X half-page-up

	-- alacritty vi-mode
	--{ key = "h", mode = "Vi|~Search", action = ToggleViMode } -- Colemak
	--{ key = "h", mode = "Vi|~Search", action = ScrollToBottom } -- Colemak
	--{ key = "l", mods = "Control", mode = Vi|~Search, action = ScrollLineDown } -- Colemak
	--{ key = "n", mode = "Vi|~Search", action = Left } -- Colemak
	--{ key = "e", mode = "Vi|~Search", action = Down } -- Colemak
	--{ key = "i", mode = "Vi|~Search", action = Up } -- Colemak
	--{ key = "o", mode = "Vi|~Search", action = Right } -- Colemak
	--{ key = "n", mods = "Shift", mode = Vi|~Search, action = High } -- Colemak
	--{ key = "o", mods = "Shift", mode = Vi|~Search, action = Low } -- Colemak
	--{ key = "l", mode = "Vi|~Search", action = SemanticRightEnd } -- Colemak
	--{ key = "l", mods = "Shift", mode = Vi|~Search, action = WordRightEnd } -- Colemak
	--{ key = "j", mode = "Vi|~Search", action = SearchNext } -- Colemak
	--{ key = "j", mods = "Shift", mode = Vi|~Search, action = SearchPrevious } -- Colemak
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

	--activate_pane = {
	--	{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
	--	{ key = "n", action = act.ActivatePaneDirection("Left") },

	--	{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
	--	{ key = "e", action = act.ActivatePaneDirection("Down") },

	--	{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
	--	{ key = "i", action = act.ActivatePaneDirection("Up") },

	--	{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
	--	{ key = "o", action = act.ActivatePaneDirection("Right") },
	--},

	copy_mode = {
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
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
}

for i = 1, 9 do
	-- CMD + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.ActivateTab(i - 1),
	})
end

-- and finally, return the configuration to wezterm
return config
