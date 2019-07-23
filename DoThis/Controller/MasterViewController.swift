//
//  MasterViewController.swift
//  DoThis
//
//  Created by Cole M on 7/23/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func saveOnEnter(_ sender: NSTextField) {
        addButton.performClick(self)
    }
    
    @IBAction func addButtonClicked(_ sender: NSButton) {
        if let context  = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let item = DoThisItem(context: context)
            item.name = textField.stringValue
            item.completed = false
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            textField.stringValue = ""
        }
          NotificationCenter.default.post(name: RELOAD_DATA, object: nil)
    }
}

