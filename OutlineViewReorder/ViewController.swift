//
//  ViewController.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var theOutline: NSOutlineView!
    var folderImage = NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericFolderIcon)))
    var itemImage = NSWorkspace.sharedWorkspace().iconForFileType(NSFileTypeForHFSTypeCode(OSType(kGenericDocumentIcon)))

    var testData = TestData()
    var draggedNode:AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderImage.size = NSSize(width: 16, height: 16)
        itemImage.size = NSSize(width: 16, height: 16)

        // Register for the dropped object types we can accept.
        theOutline.registerForDraggedTypes([REORDER_PASTEBOARD_TYPE])
        
        // Disable dragging items from our view to other applications.
        theOutline.setDraggingSourceOperationMask(NSDragOperation.None, forLocal: false)
        
        // Enable dragging items within and into our view.
        theOutline.setDraggingSourceOperationMask(NSDragOperation.Every, forLocal: true)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func undo(sender: AnyObject) {
        testData = TestData()
        theOutline.reloadData()
    }
}

