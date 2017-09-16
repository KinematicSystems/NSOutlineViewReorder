//
//  OutlineDelegate.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Cocoa

extension ViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell = outlineView.make(withIdentifier: "OutlineColItem", owner: self) as! OutlineItemView
        
        cell.textField!.delegate = self
        
        if let folderItem = item as? FolderItem
        {
            cell.textField!.stringValue = folderItem.name
            cell.imageView!.image = folderImage
        }
        else if let aItem = item as? TestItem
        {
            cell.textField!.stringValue = aItem.name
            cell.imageView!.image = itemImage
        }
        
        return cell
    }

//    func outlineView(outlineView: NSOutlineView, shouldExpandItem item: AnyObject) -> Bool {
//        return (draggedNode == nil)
//    }
}

