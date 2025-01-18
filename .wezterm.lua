local config = {}

local wezterm = require("wezterm")
local act = wezterm.action

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.term = "wezterm"
config.color_schemes = {
  ["kanagawa-wave"] = {
    background = "#1f1f28",
    foreground = "#dcd7ba",

    cursor_bg = "#c8c093",
    cursor_fg = "#1f1f28",
    cursor_border = "#c8c093",

    selection_fg = "#c8c093",
    selection_bg = "#2d4f67",

    ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
    brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
    indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
  },

  ["kanagawa-lotus"] = {
    background = "#f2ecbc",
    foreground = "#545464",

    cursor_bg = "#43436c",
    cursor_fg = "#f2ecbc",

    selection_bg = "#c9cbd1",
    selection_fg = "#43436c",

    ansi = { "#1F1F28", "#c84053", "#6f894e", "#77713f", "#4d699b", "#b35b79", "#597b75", "#545464" },

    brights = { "#8a8980", "#d7474b", "#6e915f", "#836f4a", "#6693bf", "#624c83", "#5e857a", "#43436c" },

    indexed = { [16] = "#cc6d00", [17] = "#e82424" },
  },
}

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
  -- config.term = "wezterm"
  config.enable_wayland = false
end

config.color_scheme = "kanagawa-wave"
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

wezterm.on("user-var-changed", function(window, _, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "colorscheme" and value == "update" then
    if not overrides.color_scheme or overrides.color_scheme == "kanagawa-wave" then
      overrides.color_scheme = "kanagawa-lotus"
    else
      overrides.color_scheme = "kanagawa-wave"
    end
  end

  window:set_config_overrides(overrides)
end)

config.keys = {
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
}

return config
