-- https://github.com/fikovnik/ShiftIt/wiki/The-Hammerspoon-Alternative
-- https://github.com/derekwyatt/dotfiles/blob/master/hammerspoon-init.lua
hs.window.animationDuration = 0
units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right26       = { x = 0.74, y = 0.00, w = 0.26, h = 1.00 },
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left74        = { x = 0.00, y = 0.00, w = 0.74, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  upright26     = { x = 0.74, y = 0.00, w = 0.26, h = 0.50 },
  botright26    = { x = 0.74, y = 0.50, w = 0.26, h = 0.50 },
  upleft74      = { x = 0.00, y = 0.00, w = 0.74, h = 0.50 },
  botleft74     = { x = 0.00, y = 0.50, w = 0.74, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

mash = { 'ctrl', 'option', 'cmd' }
hs.hotkey.bind(mash, 'u', function() hs.window.focusedWindow():move(units.left74,     nil, true) end)
hs.hotkey.bind(mash, 'i', function() hs.window.focusedWindow():move(units.right26,    nil, true) end)
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right50,    nil, true) end)
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left50,     nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.upright26,  nil, true) end)
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.upleft74,   nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.botleft74,  nil, true) end)
hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.botright26, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)

-- https://stackoverflow.com/a/58662204
hs.hotkey.bind(mash, 'n', function()
    -- get the focused window
    local win = hs.window.focusedWindow()
    -- get the screen where the focused window is displayed, a.k.a. current screen
    local screen = win:screen()
    -- compute the unitRect of the focused window relative to the current screen
    -- and move the window to the next screen setting the same unitRect
    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)
