//
//  OutlineDataSource.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//


import Cocoa
let REORDER_PASTEBOARD_TYPE = "com.kinematicsystems.outline.item"

extension ViewController: NSOutlineViewDataSource, NSPasteboardItemDataProvider {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
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
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
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
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item is FolderItem)
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor objectValueForTableColumn: NSTableColumn?, byItem:Any?) -> Any? {
        if let item = byItem as? BaseItem
        {
            return item.name
        }
        
        return "???????"
    }
    
    // MARK: Drag & Drop
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pbItem:NSPasteboardItem = NSPasteboardItem()
        pbItem.setDataProvider(self, forTypes: [REORDER_PASTEBOARD_TYPE])
        return pbItem
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        draggedNode = draggedItems[0] as AnyObject?
        session.draggingPasteboard.setData(Data(), forType: REORDER_PASTEBOARD_TYPE)
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        var retVal:NSDragOperation = NSDragOperation()
        var itemName = "nilItem"
        
        let baseItem = item as? BaseItem
        
        if baseItem != nil
        {
            itemName = baseItem!.name
        }

        // proposedItem is the item we are dropping on not the item we are dragging
        // - If dragging a set target item must be nil
        if (item as AnyObject? !== draggedNode && index != NSOutlineViewDropOnItemIndex)
        {
            if let _ = draggedNode as? FolderItem
            {
                if (item == nil)
                {
                    retVal = NSDragOperation.generic
                }
            }
            else if let _ = draggedNode as? TestItem
            {
                retVal = NSDragOperation.generic
            }
        }
        
        debugPrint("validateDrop targetItem:\(itemName) childIndex:\(index) returning: \(retVal != NSDragOperation())")
        return retVal
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        var retVal:Bool = false
        if !(draggedNode is BaseItem)
        {
            return false
        }
        
        let srcItem = draggedNode as! BaseItem
        let destItem:FolderItem? = item as? FolderItem
        let parentItem:FolderItem? = outlineView.parent(forItem: srcItem) as? FolderItem
        let oldIndex = outlineView.childIndex(forItem: srcItem)
        var toIndex = index
        
        debugPrint("move src:\(srcItem.name) dest:\(destItem?.name) destIndex:\(index) oldIndex:\(oldIndex) srcParent:\(parentItem?.name) toIndex:\(toIndex) toParent:\(destItem?.name) childIndex:\(index)", terminator: "")
        
        if (toIndex == NSOutlineViewDropOnItemIndex) // This should never happen, prevented in validateDrop
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
            outlineView.moveItem(at: oldIndex, inParent: parentItem, to: toIndex, inParent: destItem)
            retVal = true
        }
        
        debugPrint(" returning:\(retVal)")
        if retVal
        {
            testData.dump()
        }
        return retVal
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        //debugPrint("Drag session ended")
        self.draggedNode = nil
    }
    
    // MARK: NSPasteboardItemDataProvider
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String)
    {
        let s = "Outline Pasteboard Item"
        item.setString(s, forType: type)
    }
    
}
