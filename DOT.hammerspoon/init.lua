-- Automatically reloads config files after change
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- Unity like CMD-Ctrl+PAD number window positioning
-- Ctrl-Alt left and right for half-screen windows
function bindresize(mods, name, fun)
    hs.hotkey.bind(mods, name, function()
        local win = hs.window.focusedWindow()

        if win:isFullScreen() then
            win:setFullScreen(false)
        end
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()


        local size = fun(max)
        f.x = size[1]
        f.y = size[2]
        f.w = size[3]
        f.h = size[4]
        win:setFrame(f)
    end)
end

padmod = {"cmd", "ctrl" }
bindresize(padmod, "pad4", function(max) return {max.x, max.y, max.w/2, max.h} end)
bindresize({"alt", "ctrl"}, "left", function(max) return {max.x, max.y, max.w/2, max.h} end)
bindresize(padmod, "pad6", function(max) return {max.x + max.w/2, max.y, max.w/2, max.h} end)
bindresize({"alt", "ctrl"}, "right", function(max) return {max.x + max.w/2, max.y, max.w/2, max.h} end)
bindresize(padmod, "pad8", function(max) return {max.x, max.y, max.w, max.h/2} end)
bindresize(padmod, "pad2", function(max) return {max.x, max.y + max.h/2, max.w, max.h/2} end)
bindresize(padmod, "pad7", function(max) return {max.x, max.y, max.w/2, max.h/2} end)
bindresize(padmod, "pad9", function(max) return {max.x + max.w/2, max.y, max.w/2, max.h/2} end)
bindresize(padmod, "pad1", function(max) return {max.x, max.y + max.h/2, max.w/2, max.h/2} end)
bindresize(padmod, "pad3", function(max) return {max.x + max.w/2, max.y + max.h/2, max.w/2, max.h/2} end)

-- Crtl-Alt-Up maximizes window
restore = {}
hs.hotkey.bind({"alt", "ctrl"}, "up", function()
  local win = hs.window.focusedWindow()
  restore[win:id()] = win:frame()
  win:maximize()
end)

-- Crtl-Alt-Down restores or minimizes a window
hs.hotkey.bind({"alt", "ctrl"}, "down", function()
    local win = hs.window.focusedWindow()
    local rect = restore[win:id()]
    if rect then
      win:setFrame(rect)
      restore[win:id()]=nil
    else
      win:minimize()
    end
end)

-- Not yet working
function movescreen(key, where) 
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, key, function()
    local win = hs.window.focusedWindow()
    hs.alert.show("FN LOCK")
    where(win)
  end)
end

movescreen("left", function(w) w:moveOneScreenWest() end)
movescreen("right", function(w) w:moveOneScreenEast() end)

-- Ctrl-Cmd-T opens a new iterm window
hs.hotkey.bind({"cmd", "ctrl"}, "t", function()
    local term = hs.appfinder.appFromName("iTerm2")
    hs.application.launchOrFocus("iTerm")
    local menu = {"Shell", "New Window"}
    if (term and #(term:allWindows())>0) then term:selectMenuItem(menu) end
end)

-- Drag window with ALT+Mouse
function get_window_under_mouse()
  -- Invoke `hs.application` because `hs.window.orderedWindows()` doesn't do it
  -- and breaks itself
  local _ = hs.application

  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()

  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return my_screen == w:screen() and my_pos:inside(w:frame())
  end)
end

dragging_win = nil
drag_event = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDragged }, function(e)
  local mods = hs.eventtap.checkKeyboardModifiers()
  if mods.alt and dragging_win then
    local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
    local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)

    dragging_win:move({dx, dy}, nil, false, 0)
    return true
  end

  return nil
end)
drag_event:start()

start_event = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function(e)
  local mods = hs.eventtap.checkKeyboardModifiers()
  if e:getFlags().alt then
    dragging_win = get_window_under_mouse()
  end
end)
start_event:start()

-- Toggle FN-Lock with FN+ESC
esccode = hs.keycodes.map["escape"]
fnesc = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e) 
  if e:getKeyCode() == esccode and e:getFlags().fn then
    hs.osascript.applescript([[
      tell application "System Preferences"
          reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
      end tell
      tell application "System Events" to tell process "System Preferences"
          click checkbox 1 of tab group 1 of window 1
      end tell
      quit application "System Preferences"
      ]])

    lock_status = hs.execute("defaults read 'Apple Global Domain' 'com.apple.keyboard.fnState'")
    if lock_status == "1\n" then
        hs.alert.show("Function keys")
    else
        hs.alert.show("Multimedia keys")
    end

    return true
  end
  return nil
end)
fnesc:start()
