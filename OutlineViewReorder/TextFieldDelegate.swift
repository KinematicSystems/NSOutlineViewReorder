//
//  TextFieldDelegate.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/6/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Cocoa

extension ViewController: NSTextFieldDelegate {
    override func controlTextDidEndEditing(obj: NSNotification) {
        //printDebug("text edit end \(obj.debugDescription)");
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
