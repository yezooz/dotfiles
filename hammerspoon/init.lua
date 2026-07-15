-- Toggle show/hide of Ghostty's existing windows with a global hotkey.
-- Cmd+` : if Ghostty is frontmost, hide it; otherwise raise all its windows.
hs.hotkey.bind({"ctrl"}, "`", function()
  local app = hs.application.get("Ghostty")
  if app then
    if app:isFrontmost() then
      app:hide()
    else
      app:activate()   -- brings all Ghostty windows forward
      app:unhide()
    end
  else
    hs.application.launchOrFocus("Ghostty")
  end
end)
