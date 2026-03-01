local wezterm = require("wezterm")

local tabline = wezterm.plugin.require("https://github.com/obergodmar/tabline.wez")
local wez_tmux = wezterm.plugin.require("https://github.com/sei40kr/wez-tmux")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local act = wezterm.action
local c = wezterm.config_builder()

c.term = "xterm-256color"
c.front_end = "WebGpu"
c.max_fps = 255
c.status_update_interval = 3000

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

---@param workspace string
---@return MuxWindow
local function get_current_mux_window(workspace)
  for _, mux_win in ipairs(wezterm.mux.all_windows()) do
    if mux_win:get_workspace() == workspace then
      return mux_win
    end
  end

  error("Could not find a workspace with the name: " .. workspace)
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
  {
    key = "s",
    mods = "ALT",
    action = wezterm.action_callback(function()
      resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
    end),
  },
  {
    key = "r",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
        local type = string.match(id, "^([^/]+)") -- match before '/'
        id = string.match(id, "([^/]+)$") -- match after '/'
        id = string.match(id, "(.+)%..+$") -- remove file extention

        if type == "workspace" then
          local state = resurrect.state_manager.load_state(id, "workspace")
          win:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = state.workspace,
            }),
            pane
          )

          local opts = {
            relative = true,
            restore_text = true,
            close_open_tabs = true,
            window = get_current_mux_window(wezterm.mux.get_active_workspace()),
            spawn_in_workspace = false,
            resize_window = false,
          }

          resurrect.workspace_state.restore_workspace(state, opts)
        end
      end, { ignore_tabs = true, ignore_windows = true, show_state_with_date = true })
    end),
  },
  {
    key = "d",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
        resurrect.state_manager.delete_state(id)
      end, {
        title = "Delete State",
        description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
        fuzzy_description = "Search State to Delete: ",
        fmt_workspace = function(label)
          return wezterm.format({
            { Foreground = { AnsiColor = "Red" } },
            { Text = "󱂬 : " .. label:gsub("(.*)%.json(.*)", "%1%2") },
          })
        end,
        is_fuzzy = true,
        ignore_tabs = true,
        ignore_windows = true,
        show_state_with_date = true,
      })
    end),
  },
  { key = "a", mods = "LEADER", action = act.ActivateLastTab },
  { key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
}

wezterm.on("update-status", function(window)
  local current = window:active_workspace()
  local _, last = (wezterm.GLOBAL.ws_pair or ""):match("([^|]*)|(.*)")

  if current ~= (last or "") then
    wezterm.GLOBAL.ws_pair = string.format("%s|%s", last or "", current)
  end
end)

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
    tabline_y = { "battery", "uptime" },
    tabline_z = { "hostname", "domain" },
  },
  extensions = {},
})

tabline.apply_to_config(c)
wez_tmux.apply_to_config(c, {})

c.window_decorations = "TITLE|RESIZE"

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
  c.font_size = 10.8
  c.enable_wayland = true
end

return c
