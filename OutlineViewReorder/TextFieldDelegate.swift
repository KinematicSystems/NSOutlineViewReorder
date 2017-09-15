//
//  TextFieldDelegate.swift
//  OutlineViewReorder
//
//  Created by Matt Grippaldi on 6/6/16.
//  Copyright © 2016 Kinematic Systems. All rights reserved.
//

import Cocoa

extension ViewController: NSTextFieldDelegate {
    override func controlTextDidEndEditing(_ obj: Notification) {
        //printDebug("text edit end \(obj.debugDescription)");
        let textField = obj.object as! NSTextField
        let row = theOutline.row(for: textField)
        let item = theOutline.item(atRow: row)
        
        let newName:String = textField.stringValue
        
        if let theItem = item as? BaseItem
        {
            theItem.name = newName
        }
    }
}
