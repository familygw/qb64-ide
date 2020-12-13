//
//  SourceListViewController.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 08/12/2020.
//
import Cocoa
import Foundation

class SourceListViewController: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
  
  var rootFolder: [SourceFile?];
  @IBOutlet weak var sourceListView:NSOutlineView?
  
  override init() {
    self.rootFolder = [];
  }
  
  @objc func loadDirectories(_ sender: Any?) {
    // TODO: handle a better way to gent the folder content (lazy load?)
    let folder = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    self.rootFolder = [SourceFile.buildNode(folder)]
    self.sourceListView?.reloadData()
  }
  
  // MARK: - DataSource
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if item == nil {
      // item == nil
      // We're being asked for the number of top level elements (kAddToBag, ...)
      return self.rootFolder.count
    }
    
    // Develop time (debug) - check that the item is really Item
    assert(item is SourceFile);
    
    // item != nil
    // We're being asked for the number of children of an item
    return (item as! SourceFile).childs.count
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if item == nil {
      // item == nil
      // We're being asked for n-th (index) top level element
      return rootFolder[index] as Any
    }
    
    // Develop time (debug) - check that the item is really Item
    assert(item is SourceFile);
    
    // item != nil
    // We're being asked for n-th (index) child of an item
    return (item as! SourceFile).childs[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    // Item is expandable only if it has children
    return (item as? SourceFile)?.childs.count ?? 0 > 0
  }
  
  // MARK: - Delegates
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as? NSTableCellView
    cellView?.textField?.stringValue = (item as! SourceFile).name
    cellView?.imageView?.image = (item as! SourceFile).icon
    cellView?.imageView?.image?.backgroundColor = NSColor(hexString: "#fff")!

    return cellView
  }
  
}
