
tell application "System Events"
    tell (first application process whose frontmost is true) -- Or a named, frontmost process.
        get enabled of menu item "Paste" of menu "Edit" of menu bar 1
    end tell
end tell
