local config = {}

local wezterm = require 'wezterm'
local act = wezterm.action

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Configs for Windows only
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.default_prog = { 'pwsh.exe', '-WorkingDirectory', '~' }
  config.font_size = 12
  config.font = wezterm.font { family = 'Iosevka Nerd Font', weight = 'Bold' }
end

-- Configs for OSX only
if wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  config.font_size = 14
  config.font = wezterm.font { family = 'Iosevka Nerd Font', weight = 'Bold' }
end

-- Configs for Linux only
if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.font = wezterm.font { family = "Iosevka Nerd Font Mono", weight = "DemiBold" }
  config.font_size = 11
  config.term = 'wezterm'
end

config.color_scheme = 'Dracula'
config.use_fancy_tab_bar = false
config.tab_max_width = 30
config.show_tab_index_in_tab_bar = true
config.hide_mouse_cursor_when_typing = false
config.underline_thickness = '2px'
config.underline_position = '-6px'

config.window_frame = {
  font = config.font,
  font_size = config.font_size,
  inactive_titlebar_bg = '#353535',
  active_titlebar_bg = '#282a36',
  inactive_titlebar_fg = '#6272a4',
  active_titlebar_fg = '#f8f8f2',
  inactive_titlebar_border_bottom = '#6272a4',
  active_titlebar_border_bottom = '#6272a4',
  button_fg = '#f8f8f2',
  button_bg = '#282a36',
  button_hover_fg = '#f8f8f2',
  button_hover_bg = '#44475a',

  border_left_width = '0.25cell',
  border_right_width = '0.25cell',
  border_bottom_height = '0.1cell',
  border_top_height = '0.1cell',
  border_left_color = '#6272a4',
  border_right_color = '#6272a4',
  border_bottom_color = '#6272a4',
  border_top_color = '#6272a4',
}

config.colors = {
  tab_bar = {
    background = '#282a36',
    active_tab = {
      bg_color = '#44475a',
      fg_color = '#f8f8f2',
      intensity = 'Bold',
      underline = 'Single'
    },
    inactive_tab = {
      bg_color = '#282a36',
      fg_color = '#6272a4',
      intensity = 'Half',
      italic = true
    },
    inactive_tab_hover = {
      bg_color = '#44475a',
      fg_color = '#6272a4',
    },
    new_tab = {
      bg_color = '#282a36',
      fg_color = '#6272a4',
    },
    new_tab_hover = {
      bg_color = '#44475a',
      fg_color = '#6272a4',
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
  { key = '{', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
}

return config
