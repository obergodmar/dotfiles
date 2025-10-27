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
  config.font_size = 11.5
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
config.tab_bar_at_bottom = true
config.hide_mouse_cursor_when_typing = false

config.window_padding = {
  left = 12,
  right = 0,
  top = 45,
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

wezterm.on("update-right-status", function(window)
  local current = window:active_workspace()
  local _, last = (wezterm.GLOBAL.ws_pair or ""):match("([^|]*)|(.*)")

  if current ~= (last or "") then
    wezterm.GLOBAL.ws_pair = string.format("%s|%s", last or "", current)
  end

  window:set_right_status(current)
end)

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

config.keys = {
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },

  {
    key = "S",
    mods = "ALT",
    action = wezterm.action_callback(function(window, pane)
      local home = wezterm.home_dir
      local workspaces = {
        { id = home .. "/Code", label = "code" },
        { id = home .. "/dotfiles", label = "dotfiles" },
        { id = home .. "/notes", label = "notes" },
      }

      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            switch_workspace(inner_window, inner_pane, label, {
              label = "Workspace: " .. label,
              cwd = id,
            })
          end),
          title = "Choose Workspace",
          choices = workspaces,
          fuzzy = true,
          fuzzy_description = "Fuzzy find and/or make a workspace",
        }),
        pane
      )
    end),
  },

  { key = "s", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

  {
    key = "a",
    mods = "ALT",
    action = wezterm.action_callback(switch_to_previous_workspace),
  },
  { key = "n", mods = "ALT", action = act.SwitchWorkspaceRelative(1) },
  { key = "p", mods = "ALT", action = act.SwitchWorkspaceRelative(-1) },
  {
    key = "w",
    mods = "ALT",
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

  { key = "L", mods = "ALT", action = wezterm.action.ShowDebugOverlay },
}

return config
