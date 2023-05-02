local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local status_ok, telescope_tabs = pcall(require, "telescope-tabs")
if not status_ok then
	return
end

telescope_tabs.setup {}
