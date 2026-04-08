-- Inspired by https://github.com/Adam13531/AdamsApple/blob/main/hammerspoon/window_navigation.lua
-- This script allows for quick navigation between applications. It
-- remembers which window was last focused so that you can switch
-- quickly back to that specific window.

local lastFocusedWindowByApp = {}

-- To determine the bundle IDs, run "codesign -dr - /Applications/FOO.app" or
-- osascript -e 'id of app "Finder"'
local mappings = {
	{ { "alt", "shift" }, "1", "com.mitchellh.ghostty" },
	{ { "alt", "shift" }, "2", "com.vivaldi.Vivaldi" },
	{ { "alt", "shift" }, "3", "com.google.Chrome" },
	{ { "alt", "shift" }, "4", "com.tinyspeck.slackmacgap" },
	{ { "alt", "shift" }, "5", "com.postmanlabs.mac" },
	{ { "alt", "shift" }, "6", "md.obsidian" },
	{ { "alt", "shift" }, "7", "com.jetbrains.datagrip" },
	{ { "alt", "shift" }, "8", "com.jetbrains.PhpStorm" },
	{ { "alt", "shift" }, "9", "com.spotify.client" },
}

for _, mapping in ipairs(mappings) do
	local mods = mapping[1]
	local key = mapping[2]
	local bundleId = mapping[3]

	print(string.format("Mapping %s+%s → %s", hs.inspect(mods), key, bundleId))

	hs.hotkey.bind(mods, key, function()
		activateApp(bundleId)
	end)
end

function activateApp(bundleId)
	-- (this only finds RUNNING applications)
	-- The second param is to only search for exact matches:
	-- https://www.hammerspoon.org/docs/hs.application.html#find
	local app = hs.application.find(bundleId, true)

	-- If the app isn't running, launch it.
	if app == nil then
		hs.application.launchOrFocusByBundleID(bundleId)
		return
	end

	-- If the app was already running but we weren't tracking a window,
	-- then focus the first window.
  local lastFocusedWindow = lastFocusedWindowByApp[app:bundleID()]
  if lastFocusedWindow == nil or not lastFocusedWindow:id() or lastFocusedWindow:id() == 0 then
      lastFocusedWindowByApp[app:bundleID()] = nil
      hs.application.launchOrFocusByBundleID(bundleId)
      return
  end
	-- Try to focus the last-focused window again. Due to race conditions,
	-- this can fail, so we retry in those situations.
	for i = 1, 3, 1 do
		if i == 1 or app:focusedWindow():title() ~= lastFocusedWindow:title() then
			lastFocusedWindow:focus()
			lastFocusedWindow:raise()
		else
			return
		end
	end
end

-- Block ⌘H. It just annoys me.
hs.hotkey.bind({ "cmd" }, "H", function()
	hs.alert.show("Hammerspoon blocked ⌘H 🔥")
end)
