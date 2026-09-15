-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.
------------------------------------
-- meleu: starting my own configs --
------------------------------------

-- disable annoying defaults
----------------------------
hl.unbind("SUPER + F") -- full screen
hl.unbind("SUPER + SHIFT + A") -- AI (ChatGPT)
hl.unbind("SUPER + SHIFT + B") -- Browswer
hl.unbind("SUPER + SHIFT + E") -- Email
hl.unbind("SUPER + SHIFT + F") -- file manager
hl.unbind("SUPER + SHIFT + S") -- Google Maps
hl.unbind("SUPER + SHIFT + P") -- Google Photos
hl.unbind("SUPER + SHIFT + M") -- Music (Spotify)
hl.unbind("SUPER + SHIFT + X") -- X
hl.unbind("SUPER + SHIFT + ALT + X") -- X Compose
hl.unbind("SUPER + SHIFT + SLASH") -- Password manager (1password)
hl.unbind("SUPER + SHIFT + SPACE") -- Toggle top bar
hl.unbind("SUPER + L") -- Toggle workspace layout
hl.unbind("SUPER + K") -- Show Keybindings
hl.unbind("SUPER + ALT + K") -- Tmux keybindings
hl.unbind("SUPER + ALT + RETURN") -- Launch tmux
hl.unbind("SUPER + CTRL + K") -- Herdr keybindings
hl.unbind("SUPER + CTRL + L") -- Lock screen
hl.unbind("SUPER + CTRL + H") -- Hardware???
hl.unbind("SUPER + ALT + F") -- Maximize (full width)
hl.unbind("SUPER + J") -- Window split vertical/horizontal
hl.unbind("SUPER + O") -- Pop window out
hl.unbind("SUPER + G") -- Toggle window grouping
hl.unbind("SUPER + W") -- Close window

---------------
-- applications
---------------
--o.bind("SUPER", "O", "exec, omarchy-shell shell summon bibek.obsidian-search")-
o.bind("SUPER + ALT + O", "Obsidian Search", "omarchy-shell shell summon bibek.obsidian-search")
o.bind("SUPER + SHIFT + V", "VPN", "xdg-terminal-exec --app-id=TUI.float -e dg vpn on")
-- obsidian-quick-switcher requires Obsidian CLI
-- o.bind(
--   "SUPER + ALT + O",
--   "Obsidian quick switcher",
--   "omarchy-shell shell toggle mateuszkowalczyk.obsidian-quick-switcher '{}'"
-- )

o.bind("SUPER + SHIFT + B", "Bookmarks menu", "omarchy-shell shell toggle io.github.meleu.bmm '{}'")

o.bind("SUPER + SHIFT + A", "AI (Claude Desktop)", { launch = "claude-desktop", focus = true })
o.bind("SUPER + SHIFT + M", "Google Maps", { webapp = "https://maps.google.com/", focus = true })
o.bind("SUPER + SHIFT + P", "Password manager (Bitwarden)", { launch = "bitwarden-desktop", focus = true })
o.bind("SUPER + SHIFT + T", "Microsoft Teams", { launch = "teams-for-linux", focus = true })
o.bind("SUPER + CTRL + SHIFT + T", "Telegram", { launch = "Telegram", focus = "org.telegram.desktop" })
o.bind("SUPER + SHIFT + E", "Outlook", { webapp = "https://outlook.cloud.microsoft/", focus = true })

-- Obsidian: launch, or focus the window if it's already open.
-- The Omarchy default already tries this, but its "^obsidian$" pattern never
-- matches: omarchy-launch-or-focus wraps the pattern in \b...\b, so the ^ and $
-- anchors can only match a class/title that is literally "obsidian". Our window
-- class is "md.obsidian.Obsidian", so match on that instead.
hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "md.obsidian.Obsidian" })
-------------------------------------------------------
-- rebind to match my muscle memory (coming from PopOS)
-------------------------------------------------------

-- Tap SUPER alone to open the Omarchy menu.
o.bind("SUPER + SUPER_L", "Omarchy menu (tap SUPER)", "omarchy-menu toggle", { release = true })

-- focus movements
--
-- Horizontal focus is layout-aware. The generic hl.dsp.focus() is geometric:
-- when a window is maximized (SUPER+M) it covers the whole monitor, so there
-- is nothing "to the left/right" of it and focus either does nothing or falls
-- through to the other monitor. The scrolling layout ships its own focus
-- message that walks the tape instead, keeps the maximized state intact, and
-- scrolls the neighbour into view. Use it on scrolling workspaces, and the
-- normal directional focus everywhere else (dwindle/master).
local function focus_horizontally(direction)
  return function()
    local workspace = hl.get_active_workspace()
    if workspace and workspace.tiled_layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("focus " .. direction))
    else
      hl.dispatch(hl.dsp.focus({ direction = direction }))
    end
  end
end

o.bind("SUPER + H", "Focus on left window", focus_horizontally("l"))
o.bind("SUPER + L", "Focus on right window", focus_horizontally("r"))
o.bind("SUPER + J", "Focus on down window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on up window", hl.dsp.focus({ direction = "u" }))

-- swap windows using vim gestures
o.bind("SUPER + CTRL + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + CTRL + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + CTRL + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + CTRL + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- move window across workspaces
o.bind("SUPER + SHIFT + K", "Move window to previous workspace", hl.dsp.window.move({ workspace = "-1" }))
o.bind("SUPER + SHIFT + J", "Move window to next workspace", hl.dsp.window.move({ workspace = "+1" }))

-- more window controls
o.bind("SUPER + M", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + ALT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + G", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + K", "Keybindings", "omarchy-menu-keybindings")

o.bind("SUPER + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + O", "Toggle window split vertical/horizontal", hl.dsp.layout("togglesplit"))

-------------------------------------
-- original instructions in this file
-------------------------------------
-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
