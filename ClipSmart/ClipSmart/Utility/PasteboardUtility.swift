//
//  PasteboardUtilities.swift
//  ClipSmart
//
//  Created by Anuj Parakh on 12/14/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

// MARK: PasteBoard Related Things
class PasteboardUtility
{
    /* --------------------------------------------------------------- */
    /* NOTE: Currently, only strings will be stored on the pasteboard  */
    /*       If files/images or other media is copied, it will only be */
    /*       stored, displayed and used as a string                    */
    /* --------------------------------------------------------------- */
    
    
    static fileprivate let MAX_COPIES = 10
    static fileprivate var lastChangeCount = 0
    static fileprivate var ignoringCopies = false
    
    static var copiedThings: [String] = []
//    static var copiedThings = ["One", "Two"]
    
    static func startWatchingPasteboard(timeInSeconds time: Double)
    {
        let pasteboard = NSPasteboard.general
        lastChangeCount = NSPasteboard.general.changeCount
        Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: true) { _ in
            if pasteboard.changeCount != lastChangeCount
            {
                lastChangeCount = NSPasteboard.general.changeCount
                
                if let copiedString = pasteboard.string(forType: .string)
                {
                    if !ignoringCopies
                    {
                        addCopiedString(copiedString)
                    }
                }
            }
        }
    }
    
    static var numCopied: Int {
        return copiedThings.count
    }
    
    static func getStringForIndex(_ index: Int) -> String
    {
        if index < 0 || index >= copiedThings.count
        {
            return "Indexing Error"
        }
        
        return copiedThings[index]
    }
    
    static func readyPasteboard(_ toPasteIndex: Int) -> Bool
    {
        if toPasteIndex > (numCopied - 1)
        {
            return false
        }
        
        print("Pasting index: \(toPasteIndex)")
        
        // Ignore copies
        ignoringCopies = true
        
        // TODO: Save the current pasteboard

        
        // Put the given string onto the pasteboard
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(copiedThings[toPasteIndex], forType: NSPasteboard.PasteboardType.string)
        
        return true
    }
    
    static func restorePasteboard()
    {
        
        // TODO: Restore the pasteboard
        
        // Stop ignoring copies
        ignoringCopies = false
        
    }
    
    static fileprivate func addCopiedString(_ toAdd: String)
    {
        // Skip if last thing has been recopied
        if(copiedThings.count > 0)
        {
            if(copiedThings[0] == toAdd)
            {
                return
            }
        }
        
        // Add to end of list
        copiedThings.insert(toAdd, at: 0)
        
        if copiedThings.count > MAX_COPIES
        {
            // Remove the oldest copied item
            copiedThings.removeLast()
        }
        
        //        print("Updated copy list: \(copiedThings)")
    }
}
