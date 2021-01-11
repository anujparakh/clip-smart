//
//  PasteListItem.swift
//  ClipSmart
//
//  Created by Anuj Parakh on 12/14/20.
//  Copyright © 2020 Anuj Parakh. All rights reserved.
//

import Cocoa

// Each cell of the PasteListTableView will have an instance of this class
class PasteListItem: NSView, LoadableView
{
    @IBOutlet weak var copyItemLabel: NSTextView!
    @IBOutlet weak var copyItemLabelScrollView: NSScrollView!
    @IBOutlet weak var numberLabel: NSTextField!
    // Things to add: button
    // Constraints to adjust when view isn't fully filled
    @IBOutlet weak var scrollViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomLayoutConstraint: NSLayoutConstraint!

    var frameHeight: CGFloat = 0
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        _ = load(fromNIBNamed: "PasteListItem")
        frameHeight = frameRect.height
        
        // Copy Item Label Setup
//        copyItemLabel.preferredMaxLayoutWidth = WINDOW_WIDTH - 10
        copyItemLabelScrollView.frame.size = CGSize(width: WINDOW_WIDTH - 10, height: frameHeight)
        copyItemLabel.isEditable = false
        copyItemLabel.isSelectable = false

        
        // Number Label Setup
        numberLabel.wantsLayer = true
        numberLabel.layer?.cornerRadius = 5
        numberLabel.isHidden = true
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    /// Sets the label and autorizes the NSTextField accordingly
    func setLabelText(_ text: String)
    {        
        copyItemLabel.string = text
        copyItemLabel.font = NSFont.systemFont(ofSize: 30)

        print("---------------")
        print("Text Count: \(text.count)")
        
        if text.count > 80
        {
            copyItemLabel.font = NSFont.systemFont(ofSize: 25)
        }
        if text.count > 120
        {
            copyItemLabel.font = NSFont.systemFont(ofSize: 20)
        }
        if text.count > 200
        {
            copyItemLabel.font = NSFont.systemFont(ofSize: 15)
        }
        
        print(copyItemLabel.string)
        print("Before: \(copyItemLabel.frame)")
        if copyItemLabel.attributedString().size().height < copyItemLabelScrollView.frame.height
        {
            let constraintConstant = copyItemLabelScrollView.frame.height / 2 - copyItemLabel.attributedString().size().height / 2
            scrollViewTopLayoutConstraint.constant = constraintConstant
            scrollViewBottomLayoutConstraint.constant = constraintConstant
            copyItemLabel.alignment = .center
        }
            
        print("After: \(copyItemLabel.frame)")
        print("---------------")

    }
    
    func showNumberLabel()
    {
        numberLabel.isHidden = false
    }
    
    func hideNumberLabel()
    {
        numberLabel.isHidden = true
    }
    
    override var intrinsicContentSize: NSSize
    {
        return CGSize(width: WINDOW_WIDTH, height: frameHeight)
    }
    
    
}


