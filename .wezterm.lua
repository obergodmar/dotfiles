local config = {}

local wezterm = require("wezterm")
local act = wezterm.action

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Configs for Windows only
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh.exe", "-WorkingDirectory", "~" }
  config.font_size = 12
  config.font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Bold" })
end

-- Configs for OSX only
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  config.font_size = 15
  config.font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Bold" })
end

-- Configs for Linux only
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  config.font = wezterm.font({ family = "Iosevka Nerd Font", weight = "DemiBold" })
  config.font_size = 12
  config.term = "wezterm"
  config.front_end = "OpenGL"
end

config.color_scheme = "Kanagawa (Gogh)"
config.use_fancy_tab_bar = false
config.tab_max_width = 30
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.tab_bar_style = {
  window_hide = wezterm.format({
    { Background = { Color = "#16161D" } },
    { Foreground = { Color = "#727169" } },
    { Text = " _ " },
  }),
  window_hide_hover = wezterm.format({
    { Background = { Color = "#2A2A37" } },
    { Foreground = { Color = "#DCD7BA" } },
    { Text = " _ " },
  }),
  window_maximize = wezterm.format({
    { Background = { Color = "#16161D" } },
    { Foreground = { Color = "#727169" } },
    { Text = " [] " },
  }),
  window_maximize_hover = wezterm.format({
    { Background = { Color = "#2A2A37" } },
    { Foreground = { Color = "#DCD7BA" } },
    { Text = " [] " },
  }),
  window_close = wezterm.format({
    { Background = { Color = "#16161D" } },
    { Foreground = { Color = "#727169" } },
    { Text = " X " },
  }),
  window_close_hover = wezterm.format({
    { Background = { Color = "#2A2A37" } },
    { Foreground = { Color = "#DCD7BA" } },
    { Text = " X " },
  }),
}
config.show_tab_index_in_tab_bar = true
config.hide_mouse_cursor_when_typing = false
config.underline_thickness = "2px"
config.underline_position = "-6px"

config.window_padding = {
  left = 12,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_frame = {
  font = config.font,
  font_size = config.font_size,
  inactive_titlebar_bg = "#16161D",
  active_titlebar_bg = "#1F1F28",
  inactive_titlebar_fg = "#727169",
  active_titlebar_fg = "#C8C093",
  inactive_titlebar_border_bottom = "#54546D",
  active_titlebar_border_bottom = "#54546D",
  button_fg = "#727169",
  button_bg = "#16161D",
  button_hover_fg = "#DCD7BA",
  button_hover_bg = "#2A2A37",

  border_left_width = "0.25cell",
  border_right_width = "0.25cell",
  border_bottom_height = "0.1cell",
  border_top_height = "0.1cell",
  border_left_color = "#16161D",
  border_right_color = "#16161D",
  border_bottom_color = "#16161D",
  border_top_color = "#16161D",
}

config.default_cursor_style = "SteadyBlock"

config.colors = {
  -- dark theme
  cursor_bg = "#c8c093",
  cursor_fg = "#192330",
  cursor_border = "#c8c093",

  -- light theme
  -- cursor_fg = "#f2eccd",
  -- cursor_bg = "#dc8a78",
  -- cursor_border = "#dc8a78",
  --
  background = "#16161D",
  tab_bar = {
    background = "#16161D",
    active_tab = {
      bg_color = "#1F1F28",
      fg_color = "#C8C093",
      underline = "Single",
    },
    inactive_tab = {
      bg_color = "#16161D",
      fg_color = "#727169",
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = "#2A2A37",
      fg_color = "#DCD7BA",
    },
    new_tab = {
      bg_color = "#16161D",
      fg_color = "#727169",
    },
    new_tab_hover = {
      bg_color = "#2A2A37",
      fg_color = "#DCD7BA",
    },
  },
}

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

config.keys = {
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

return config
