-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font("CaskaydiaCove Nerd Font")

config.enable_tab_bar = false
config.font_size = 13.0
config.window_background_image = "/home/akyrey/.config/wezterm/background.png"
config.window_background_image_hsb = {
	brightness = 0.01,
	hue = 1.0,
	saturation = 0.5,
}
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.initial_rows = 56
config.initial_cols = 200
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config.term = "wezterm"

return config
