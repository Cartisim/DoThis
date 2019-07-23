//
//  DoThisViewController.swift
//  DoThis
//
//  Created by Cole M on 7/23/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa


let RELOAD_DATA = Notification.Name("reloadTableView")

class DoThisViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    static let shared = DoThisViewController()
    var doThisItem: [DoThisItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.doubleAction = #selector(doubleClicked)
        let menu = NSMenu()
        menu.addItem(withTitle: "delete", action: #selector(deleteItem), keyEquivalent: "")
        tableView.menu = menu
         getItems()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: RELOAD_DATA, object: nil)
    }
    
    @objc func reloadData(_notif: Notification) {
        DispatchQueue.main.async {
            print("test")
            self.getItems()
            self.tableView.reloadData()
        }
    }
    
    @objc func doubleClicked() {
        if let indexPath = tableView?.selectedRow {
            if doThisItem[indexPath].completed {
                doThisItem[indexPath].completed = false
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                getItems()
                tableView.reloadData()
            } else {
                doThisItem[indexPath].completed = true
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                getItems()
                tableView.reloadData()
            }
        }
    }
    
    @objc func deleteItem() {
      if let indexPath = tableView?.selectedRow {
            let items = doThisItem[indexPath]
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(items)
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                getItems()
                tableView.reloadData()
            }
        }
    }
    
    func getItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do{
                doThisItem = try context.fetch(DoThisItem.fetchRequest())
            } catch {
                print("error")
            }
        }
    }
}

extension DoThisViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return doThisItem.count
    }
}

extension DoThisViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "itemCell"), owner: nil) as? NSTableCellView
        if let nameLabel = cell?.viewWithTag(0) as? NSTextField {
            nameLabel.stringValue = doThisItem[row].name ?? "Add items"
        }
        if let completedLabel = cell?.viewWithTag(1) as? NSTextField {
            if doThisItem[row].completed {
                completedLabel.stringValue = "✓"
            } else {
                completedLabel.stringValue = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
}
