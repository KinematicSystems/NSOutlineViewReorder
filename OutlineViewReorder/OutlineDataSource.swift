//
//  OutlineDataSource.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//


import Cocoa
let PASTEBOARD_TYPE = "com.kinematicsystems.outline.item"

extension ViewController: NSOutlineViewDataSource, NSPasteboardItemDataProvider {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        
        if item == nil
        {
            return testData.items.count
        }
        else if let folderItem = item as? FolderItem
        {
            return folderItem.items.count
        }
        
        return 0
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil
        {
            return testData.items[index]
        }
        else if let folderItem = item as? FolderItem
        {
            return folderItem.items[index]
        }
        
        return "BAD ITEM"
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return (item is FolderItem)
    }
    
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn: NSTableColumn?, byItem:AnyObject?) -> AnyObject? {
        if let item = byItem as? BaseItem
        {
            return item.name
        }
        
        return "???????"
    }
    
    // MARK: Drag & Drop
    func outlineView(outlineView: NSOutlineView, pasteboardWriterForItem item: AnyObject) -> NSPasteboardWriting? {
        let pbItem:NSPasteboardItem = NSPasteboardItem()
        pbItem.setDataProvider(self, forTypes: [PASTEBOARD_TYPE])
        return pbItem
    }
    
    func outlineView(outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAtPoint screenPoint: NSPoint, forItems draggedItems: [AnyObject]) {
        draggedNode = draggedItems[0]
        session.draggingPasteboard.setData(NSData(), forType: PASTEBOARD_TYPE)
    }
    
    func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: AnyObject?, proposedChildIndex index: Int) -> NSDragOperation {
        var retVal:NSDragOperation = NSDragOperation.None
        var itemName = "nilItem"
        
        let baseItem = item as? BaseItem
        
        if baseItem != nil
        {
            itemName = baseItem!.name
        }

        // proposedItem is the item we are dropping on not the item we are dragging
        // - If dragging a set target item must be nil
        if (item !== draggedNode && index != NSOutlineViewDropOnItemIndex)
        {
            if let _ = draggedNode as? FolderItem
            {
                if (item == nil)
                {
                    retVal = NSDragOperation.Generic
                }
            }
            else if let _ = draggedNode as? TestItem
            {
                retVal = NSDragOperation.Generic
            }
        }
        
        debugPrint("validateDrop targetItem:\(itemName) childIndex:\(index) returning: \(retVal != NSDragOperation.None)")
        return retVal
    }
    
    func outlineView(outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: AnyObject?, childIndex index: Int) -> Bool {
        var retVal:Bool = false
        if !(draggedNode is BaseItem)
        {
            return false
        }
        
        let srcItem = draggedNode as! BaseItem
        let destItem:FolderItem? = item as? FolderItem
        let parentItem:FolderItem? = outlineView.parentForItem(srcItem) as? FolderItem
        let oldIndex = outlineView.childIndexForItem(srcItem)
        var toIndex = index
        
        debugPrint("move src:\(srcItem.name) dest:\(destItem?.name) destIndex:\(index) oldIndex:\(oldIndex) srcParent:\(parentItem?.name) toIndex:\(toIndex) toParent:\(destItem?.name) childIndex:\(index)", terminator: "")
        
        if (toIndex == NSOutlineViewDropOnItemIndex)
        {
            toIndex = 0
        }
        else if toIndex > oldIndex
        {
            toIndex -= 1
        }
        
        if srcItem is FolderItem && destItem != nil
        {
            retVal = false
        }
        else if oldIndex != toIndex || parentItem !== destItem
        {
            testData.moveItemAtIndex(oldIndex, inParent: parentItem, toIndex: toIndex, inParent: destItem)
            outlineView.moveItemAtIndex(oldIndex, inParent: parentItem, toIndex: toIndex, inParent: destItem)
            retVal = true
        }
        
        debugPrint(" returning:\(retVal)")
        if retVal
        {
            testData.dump()
        }
        return retVal
    }
    
    func outlineView(outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
        //debugPrint("Drag session ended")
        self.draggedNode = nil
    }
    
    // MARK: NSPasteboardItemDataProvider
    func pasteboard(pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String)
    {
        let s = "Outline Pasteboard Item"
        item.setString(s, forType: type)
    }
    
}
