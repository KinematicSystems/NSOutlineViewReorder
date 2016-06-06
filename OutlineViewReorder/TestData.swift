//
//  TestData.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Foundation

class BaseItem {
    var name:String = ""
    
    func dump()
    {
        print(name)
    }
}

class TestItem: BaseItem {
    override func dump()
    {
        print("Item: ", terminator:"")
        super.dump()
    }
}

class FolderItem: BaseItem {
    var items:[TestItem] = []
    
    override func dump()
    {
        print("Folder: ", terminator:"")
        super.dump()

        for item in items
        {
            print("  ", terminator:"")
            item.dump()
        }
    }
}

class TestData
{
    var items:[BaseItem] = []
    
    init() {
        for i in 1...5
        {
            let item = TestItem()
            item.name = "RootItem.\(i)"
            items.append(item)
        }

        for i in 1...5
        {
            let folder = FolderItem()
            folder.name = "Folder.\(i)"
            for j in 1...3
            {
                let item = TestItem()
                item.name = folder.name + ".Child.\(j)"
                folder.items.append(item)
            }

            items.append(folder)
        }
        let folder = FolderItem()
        folder.name = "Empty"
        items.append(folder)
    }

    // Moves the items in a way that is compatible with NSOutlineView's method of the same name
    func moveItemAtIndex(fromIndex: Int, inParent oldParent: FolderItem?, toIndex: Int, inParent newParent: FolderItem?)
    {
        var removedItem:BaseItem
        if oldParent == nil
        {
            removedItem = self.items.removeAtIndex(fromIndex)
        }
        else
        {
            removedItem = oldParent!.items.removeAtIndex(fromIndex)
        }
        
        if newParent == nil
        {
            self.items.insert(removedItem, atIndex: toIndex)
        }
        else
        {
            newParent!.items.insert(removedItem as! TestItem, atIndex: toIndex)
        }
        
    }
   
    func dump() {
        for item in items
        {
            item.dump()
        }
    }
}