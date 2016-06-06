//
//  OutlineDelegate.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/4/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Cocoa

extension ViewController: NSOutlineViewDelegate {
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cell = outlineView.makeViewWithIdentifier("OutlineColItem", owner: self) as! OutlineItemView
        
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

// MARK:- NSTextFieldDelegate
extension ViewController: NSTextFieldDelegate {
    override func controlTextDidEndEditing(obj: NSNotification) {
        //print("text edit end \(obj.debugDescription)");
        let textField = obj.object as! NSTextField
        let row = theOutline.rowForView(textField)
        let item = theOutline.itemAtRow(row)

        let newName:String = textField.stringValue
        
        if let theItem = item as? BaseItem
        {
            theItem.name = newName
        }
    }
}
