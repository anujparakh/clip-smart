//
//  self.swift
//  ClipSmart
//
//  Created by Anuj Parakh on 12/14/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

class PasteListPanel: NSPanel, NSWindowDelegate
{
    var pasteListStackView: NSStackView!
    
    override var canBecomeKey: Bool
    {
        return true
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool)
    {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // Floating related properties
        self.level = NSWindow.Level.popUpMenu
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.becomesKeyOnlyIfNeeded = true
        self.delegate = self
        
        // UI related properties
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
        self.center()
        self.isOpaque = false
        
        // Ready the table view
        pasteListStackView = NSStackView(frame: self.contentView!.bounds)
        pasteListStackView.distribution = .fill
        pasteListStackView.translatesAutoresizingMaskIntoConstraints = false
        pasteListStackView.orientation = .vertical
        pasteListStackView.alignment = .width
        pasteListStackView.spacing = 0
//        pasteListStackView.wantsLayer = true
//        pasteListStackView.layer?.backgroundColor = CGColor.black
    }
    
    override func keyDown(with event: NSEvent)
    {
        if event.keyCode == KeyCodeConstants.Escape.rawValue
        {
            self.resignKey() // Close the window
            return
        }
        
        
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == NSEvent.ModifierFlags.command
        {
            
            // Command is the only modifier
            switch event.keyCode
            {
                
            case KeyCodeConstants.Zero.rawValue:
                if PasteboardUtility.readyPasteboard(0)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }
                
            case KeyCodeConstants.One.rawValue:
                if PasteboardUtility.readyPasteboard(1)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Two.rawValue:
                if PasteboardUtility.readyPasteboard(2)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Three.rawValue:
                if PasteboardUtility.readyPasteboard(3)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Four.rawValue:
                if PasteboardUtility.readyPasteboard(4)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()

                    return
                }

            case KeyCodeConstants.Five.rawValue:
                if PasteboardUtility.readyPasteboard(5)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Six.rawValue:
                if PasteboardUtility.readyPasteboard(6)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Seven.rawValue:
                if PasteboardUtility.readyPasteboard(7)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Eight.rawValue:
                if PasteboardUtility.readyPasteboard(8)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }

            case KeyCodeConstants.Nine.rawValue:
                if PasteboardUtility.readyPasteboard(9)
                {
                    self.resignKey()
                    executePasteApplescript()
                    PasteboardUtility.restorePasteboard()
                    return
                }


            default:
                print("\(event.keyCode) was pressed")
            }
        }
        
        // Beep
        super.keyDown(with: event)
    }
    
    override func flagsChanged(with event: NSEvent)
    {
        super.flagsChanged(with: event)
        
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == NSEvent.ModifierFlags.command
        {
            for view in pasteListStackView.arrangedSubviews
            {
                if let listItem = view as? PasteListItem
                {
                    listItem.showNumberLabel()
                }
            }
        }
        else
        {
            for view in pasteListStackView.arrangedSubviews
            {
                if let listItem = view as? PasteListItem
                {
                    listItem.hideNumberLabel()
                }
            }
        }

    }
    
    /// Simple function to close panel if isVisible is true, otherwise call makeKeyAndOrderFront
    func toggleVisibility()
    {
        if self.isVisible
        {
            self.close()
        }
        else
        {
            updateStackView()
            self.makeKeyAndOrderFront(nil)
        }
    }
    
    /// Creates a TableView to be shown inside the panel
    func updateStackView()
    {
        // TODO: Check if it is same as last time (If yes, do nothing)
        
        // Now, empty the content view first
        for view in contentView!.subviews
        {
            view.removeFromSuperview()
        }

        // Add a message if no items are in the copy list
        if PasteboardUtility.numCopied == 0
        {
            let messageView = PasteListItem(frame: self.contentView!.bounds)
            messageView.setLabelText("No Items Copied!")
            self.contentView?.addSubview(messageView)
            return
        }
        
        // Empty the pasteListStackView
        for view in pasteListStackView.arrangedSubviews
        {
            view.removeFromSuperview()
        }

        pasteListStackView.frame = self.contentView!.bounds
        let singleHeight = (pasteListStackView.bounds.height) / CGFloat(PasteboardUtility.numCopied)
        var index = 0
        for copiedThing in PasteboardUtility.copiedThings
        {
            let viewToAdd = PasteListItem(frame: NSRect(x: 0, y: 0, width: pasteListStackView.bounds.width, height: singleHeight))
            viewToAdd.setLabelText(copiedThing)
            viewToAdd.numberLabel.stringValue = String(index)
            viewToAdd.wantsLayer = true
            viewToAdd.layer?.borderColor = CGColor.white
            viewToAdd.layer?.borderWidth = 0.5
            
//            viewToAdd.layer?.backgroundColor = CGColor.black
            pasteListStackView.addArrangedSubview(viewToAdd)
            index += 1

        }
        
        self.contentView?.addSubview(pasteListStackView)
    }
    
    
    // MARK: NSWindowDelegate Functions
    
    func windowDidResignKey(_ notification: Notification)
    {
        self.close()
    }
    
//    func windowWillClose(_ notification: Notification)
//    {
//    }
//
//    func windowDidBecomeKey(_ notification: Notification)
//    {
//    }
    
}
