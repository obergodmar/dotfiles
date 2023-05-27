local config = {}

local wezterm = require 'wezterm'
local act = wezterm.action

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Configs for Windows only
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'pwsh.exe', '-WorkingDirectory', '~' }
  config.font_size = 12
  config.font = wezterm.font('Iosevka Nerd Font', { weight = 'Bold' })
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end

-- Configs for OSX only
if wezterm.target_triple == 'x86_64-apple-darwin' then
  config.font_size = 11
  config.term = 'wezterm'
end

-- Configs for Linux only
if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  config.font_size = 11
  config.term = 'wezterm'
end

config.color_scheme = 'Dracula'

wezterm.on("format-tab-title", function(tab)
  local pane_title = tab.active_pane.title
  local user_title = tab.active_pane.user_vars.panetitle

  if user_title ~= nil and #user_title > 0 then
    pane_title = user_title
  end

  return {
    { Text = " " .. pane_title .. " " },
  }
end)

config.keys = {
  { key = '{', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
}

return config
