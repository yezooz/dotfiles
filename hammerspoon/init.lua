-- Per-app show/hide toggles.
-- Press the hotkey: if the app is frontmost, hide it; otherwise raise all its
-- windows. If it isn't running yet, launch it.
local function toggleApp(name)
  return function()
    local app = hs.application.get(name)
    if app then
      if app:isFrontmost() then
        app:hide()
      else
        app:activate()   -- brings all the app's windows forward
        app:unhide()
      end
    else
      hs.application.launchOrFocus(name)
    end
  end
end

hs.hotkey.bind({"alt"}, "1", toggleApp("Ghostty"))
hs.hotkey.bind({"alt"}, "2", toggleApp("Brave Browser"))
hs.hotkey.bind({"alt"}, "3", toggleApp("Slack"))
