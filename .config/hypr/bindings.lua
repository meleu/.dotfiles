-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

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

------------------------------------
-- meleu: starting my own configs --
------------------------------------

-- disable annoying defaults
----------------------------
hl.unbind("SUPER + F")         -- full screen
hl.unbind("SUPER + SHIFT + F") -- file manager
hl.unbind("SUPER + L")         -- Toggle workspace layout
hl.unbind("SUPER + K")         -- Show Keybindings
hl.unbind("SUPER + ALT + K")   -- Tmux keybindings
hl.unbind("SUPER + CTRL + K")  -- Herdr keybindings
hl.unbind("SUPER + CTRL + L")  -- Lock screen
hl.unbind("SUPER + CTRL + H")  -- Hardware???
hl.unbind("SUPER + ALT + F")   -- Maximize (full width)
hl.unbind("SUPER + J")         -- Window split vertical/horizontal
hl.unbind("SUPER + O")         -- Pop window out
hl.unbind("SUPER + G")         -- Toggle window grouping
hl.unbind("SUPER + W")         -- Close window

-- rebind to match my muscle memory (coming from PopOS)
-------------------------------------------------------

-- Tap SUPER alone to open the Omarchy menu.
o.bind("SUPER + SUPER_L", "Omarchy menu (tap SUPER)", "omarchy-menu toggle", { release = true })

-- focus movements
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on down window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on up window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- swap windows using vim gestures
o.bind("SUPER + CTRL + h", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + CTRL + j", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + CTRL + k", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + CTRL + l", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- move window across workspaces
o.bind("SUPER + SHIFT + K", "Move window to previous workspace", hl.dsp.window.move({ workspace = "-1" }))
o.bind("SUPER + SHIFT + J", "Move window to next workspace", hl.dsp.window.move({ workspace = "+1" }))

-- more window controls
o.bind("SUPER + M", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + ALT + M", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + G", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + K", "Keybindings", "omarchy-menu-keybindings")

o.bind("SUPER + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + O", "Toggle window split vertical/horizontal", hl.dsp.layout("togglesplit"))
