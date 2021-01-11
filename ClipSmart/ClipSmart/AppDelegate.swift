//
//  AppDelegate.swift
//  ClipSmart
//
//  Created by Anuj Parakh on 12/13/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    // MARK: IBOutlets
    @IBOutlet weak var mainMenu: NSMenu?
    
    // MARK: Members
    var appStatusItem: NSStatusItem!
    var shortcutHotKey: HotKey!
//    var pasteListWindowController: PasteListWindowController!
    
    var pasteListPanel: PasteListPanel!
    
    // MARK: NSApplicationDelegate Functions
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }
    
    // Called once when app opens up
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Setup Menu Bar
        setupMenuBarItems()
        
        // Register for HotKey
        // TODO: This should be stored and done from preferences page
        registerShortcut {
            self.shortcutPressed()
        }
        
        // Setup the window and it's controller
        pasteListPanel = PasteListPanel(contentRect: NSRect(x: 50, y: 50, width: 400, height: 800), styleMask: [.nonactivatingPanel, .borderless], backing: .buffered, defer: true)
        
        // Start the pasteboard watcher
        PasteboardUtility.startWatchingPasteboard(timeInSeconds: 1)
        
        precompileAppleScripts()
    }

    // MARK: Private Methods
    
    /// Sets up the top menu bar items
    /// First, makes the status bar item and sets the image
    /// Then, sets the menu (to be shown when clicked)
    private func setupMenuBarItems()
    {
        // Get the menu bar status item
        appStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Set an image for it
        let menuItemImage = NSImage(named: "menu-item")!
        menuItemImage.isTemplate = true
        appStatusItem.button?.image = menuItemImage
        
        // Set the status menu as the app menu outlet
        appStatusItem.menu = mainMenu!

    }
    
    private func shortcutPressed()
    {
        
        // If the panel has been created, toggle it's visibility
        if let panel = pasteListPanel
        {
            if(panel.isVisible)
            {
                // Close the panel
                panel.toggleVisibility()
                return
            }
            
//            // First check if panel should be shown
//            if (!checkPasteAccessible())
//            {
//                // Play the sound
//                NSSound.beep()
//                return
//            }
            
            
            // Then, calculate the size of the panel
            let panelSize = calculateSizeForView(CGSize(width: 100, height: 100), numThings: PasteboardUtility.copiedThings.count)

            panel.setFrame(CGRect(origin: CGPoint(x: 0, y: 0), size: panelSize), display: true)
            panel.center()
            panel.toggleVisibility()
            
        }
        
    }
}


