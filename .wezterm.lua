local config = {}

local wezterm = require("wezterm")
local act = wezterm.action

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.term = "xterm-256color"

config.underline_thickness = "300%"
config.underline_position = "200%"
config.font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Medium" })

config.front_end = "WebGpu"
config.check_for_updates = false
config.warn_about_missing_glyphs = false
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- Configs for Windows only
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-nologo", "-WorkingDirectory", "~" }
  config.font_size = 10.8
end

-- Configs for OSX only
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  config.font_size = 14
end

-- Configs for Linux only
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.font_size = 12
  config.enable_wayland = false
end

config.color_scheme = "Catppuccin Macchiato"
config.use_fancy_tab_bar = false
config.tab_max_width = 30
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.tab_bar_style = {
  window_hide = wezterm.format({
    { Text = " _ " },
  }),
  window_hide_hover = wezterm.format({
    { Text = " _ " },
  }),
  window_maximize = wezterm.format({
    { Text = " [] " },
  }),
  window_maximize_hover = wezterm.format({
    { Text = " [] " },
  }),
  window_close = wezterm.format({
    { Text = " X " },
  }),
  window_close_hover = wezterm.format({
    { Text = " X " },
  }),
}
config.show_tab_index_in_tab_bar = true
config.hide_mouse_cursor_when_typing = false

config.window_padding = {
  left = 12,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_frame = {
  font = config.font,
  font_size = config.font_size,
  border_left_width = "0.25cell",
  border_right_width = "0.25cell",
  border_bottom_height = "0.1cell",
  border_top_height = "0.1cell",
}

config.default_cursor_style = "SteadyBlock"

wezterm.on("format-tab-title", function(tab)
  local tab_index = tab.tab_index + 1
  local tab_title = tab.active_pane.title
  local user_title = tab.active_pane.user_vars.panetitle

  if user_title ~= nil and #user_title > 0 then
    tab_title = user_title
  end

  return {
    { Text = " " .. tab_index .. ": " .. tab_title .. " " },
  }
end)

-- wezterm.on("user-var-changed", function(window, _, name, value)
--   local overrides = window:get_config_overrides() or {}
--   if name == "colorscheme" and value == "update" then
--     if not overrides.color_scheme or overrides.color_scheme == "kanagawa-wave" then
--       overrides.color_scheme = "kanagawa-lotus"
--     else
--       overrides.color_scheme = "kanagawa-wave"
--     end
--   end

--   window:set_config_overrides(overrides)
-- end)

config.keys = {
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

return config
