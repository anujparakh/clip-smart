//
//  Utility.swift
//  ClipSmart
//
//  Created by Anuj Parakh on 12/13/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa
import HotKey


// MARK: Shortcut Related Things
var shortcutHotKey: HotKey?

func registerShortcut(withHandler shortcutHandler: @escaping () -> Void)
{
    shortcutHotKey = HotKey(key: .v, modifiers: [.command, .option])
    shortcutHotKey?.keyDownHandler = shortcutHandler
}

// MARK: Key Code Constants

enum KeyCodeConstants: UInt16
{
    case Escape = 53
    case Zero   = 29
    case One    = 18
    case Two    = 19
    case Three  = 20
    case Four   = 21
    case Five   = 23
    case Six    = 22
    case Seven  = 26
    case Eight  = 28
    case Nine   = 25    
}

// MARK: Size Constants and Calculators

let WINDOW_WIDTH: CGFloat = 400

func calculateSizeForView(_ screenSize: CGSize, numThings: Int) -> CGSize
{
    if numThings == 0
    {
        return CGSize(width: WINDOW_WIDTH, height: 150)
    }
    // TODO: Take Screen Size into account
    if numThings < 4
    {
        return CGSize(width: WINDOW_WIDTH, height: CGFloat(numThings) * 180)
    }
    else if numThings < 8
    {
        return CGSize(width: WINDOW_WIDTH, height: CGFloat(numThings) * 140)
    }
    else
    {
        return CGSize(width: WINDOW_WIDTH, height: CGFloat(numThings) * 120)
    }
}

// MARK: AppleScript Functions

let PASTING_APPLE_SCRIPT = """
tell application "System Events"
    tell (first application process whose frontmost is true) -- Or a named, frontmost process.
        click menu item "Paste" of menu "Edit" of menu bar 1
    end tell
end tell
"""
let pasteScript = NSAppleScript(source: PASTING_APPLE_SCRIPT)

let CHECK_PASTE_APPLE_SCRIPT = """
tell application "System Events"
    tell (first application process whose frontmost is true)
        get enabled of menu item "Paste" of menu "Edit" of menu bar 1
        return "true"
    end tell
end tell
"""

let checkPasteScript = NSAppleScript(source: CHECK_PASTE_APPLE_SCRIPT)

func precompileAppleScripts()
{
//    pasteScript?.compileAndReturnError(nil)
//    checkPasteScript?.compileAndReturnError(nil)
}

func executePasteApplescript()
{
    if let script = pasteScript
    {
        var error: NSDictionary?
        let _ = script.executeAndReturnError(&error).stringValue // May need this
        
        // Might be an error
        if let err = error
        {
            print(err) // Could not paste
        }
    }
}



func checkPasteAccessible() -> Bool
{
    if let script = checkPasteScript
    {
        var error: NSDictionary?

        let start = CFAbsoluteTimeGetCurrent()
        
        let optionalResult = script.executeAndReturnError(&error).stringValue
        
        let diff = CFAbsoluteTimeGetCurrent() - start
        print("Took \(diff) seconds")

        
        if let result = optionalResult
        {
            return result == "true"
        }
        // Might be an error
        else if let err = error
        {
            print(err)
        }
    }
    
    return false
}
