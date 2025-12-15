local wezterm = require("wezterm")

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local wez_tmux = wezterm.plugin.require("https://github.com/sei40kr/wez-tmux")

local act = wezterm.action
local c = wezterm.config_builder()

c.term = "xterm-256color"
c.front_end = "WebGpu"

c.underline_thickness = "300%"
c.underline_position = "200%"
c.font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Medium" })

c.check_for_updates = false
c.warn_about_missing_glyphs = false
c.audible_bell = "Disabled"
c.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "CursorColor",
}

-- Configs for Windows only
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  c.default_prog = { "pwsh.exe", "-nologo", "-WorkingDirectory", "~" }
  c.font_size = 10.8
end

-- Configs for OSX only
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  c.font_size = 14
end

-- Configs for Linux only
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  c.font_size = 11.5
  c.enable_wayland = true
end

c.color_scheme = "Catppuccin Macchiato"
c.hide_mouse_cursor_when_typing = false

c.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
c.window_frame = {
  font = c.font,
  font_size = c.font_size,
  border_left_width = "0.25cell",
  border_right_width = "0.25cell",
  border_bottom_height = "0.1cell",
  border_top_height = "0.1cell",
}
c.default_cursor_style = "SteadyBlock"
c.exit_behavior = "Hold"

local function switch_workspace(window, pane, workspace, spawn)
  if window:active_workspace() == workspace then
    return
  end
  window:perform_action(act.SwitchToWorkspace({ name = workspace, spawn = spawn }), pane)
end

local function switch_to_previous_workspace(window, pane)
  local prev, last = (wezterm.GLOBAL.ws_pair or ""):match("([^|]*)|(.*)")
  if not prev or prev == "" or prev == last or not last or last == "" then
    wezterm.log_info("No previous workspace to switch to")
    return
  end

  switch_workspace(window, pane, prev)
end

c.leader = { key = "a", mods = "CTRL" }
c.keys = {
  {
    key = "s",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(switch_to_previous_workspace),
  },
  {
    key = "C",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          switch_workspace(window, pane, line)
        end
      end),
    }),
  },
  { key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
}

tabline.setup({
  options = {
    icons_enabled = true,
    theme = c.color_scheme,
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = "",
    component_separators = "",
    tab_separators = "",
  },
  sections = {
    tabline_a = { "mode" },
    tabline_b = { "workspace" },
    tabline_c = { " " },
    tab_active = {
      "index",
      { "parent", padding = 0 },
      "/",
      { "cwd", padding = { left = 0, right = 1 } },
      { "zoomed", padding = 0 },
    },
    tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
    tabline_x = { "ram", "cpu" },
    tabline_y = { "battery" },
    tabline_z = { "hostname", "domain" },
  },
  extensions = {},
})

wez_tmux.apply_to_config(c, {})
tabline.apply_to_config(c)

return c
