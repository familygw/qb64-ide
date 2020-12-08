//
//  SourceListViewController.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 08/12/2020.
//
import Cocoa
import Foundation

class SourceListViewController: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
  
  var rootFolder: [BaseElement?];
  @IBOutlet weak var sourceListView:NSOutlineView?
  
  override init() {
    let rootFolder = SourceFolder("/Users/familygw/Projects/QB64 IDE");
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file1.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file2.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file3.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file4.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file5.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file6.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file7.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file8.bas"))
    rootFolder.childs.append(SourceFile("/Users/familygw/Projects/QB64 IDE/file9.bas"))
    
    self.rootFolder = [rootFolder]
    
    self.sourceListView?.expandItem(nil, expandChildren: true)
    
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
    assert(item is BaseElement);
    
    // item != nil
    // We're being asked for the number of children of an item
    return (item as! BaseElement).childs.count
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if item == nil {
      // item == nil
      // We're being asked for n-th (index) top level element
      return rootFolder[index] as Any
    }
    
    // Develop time (debug) - check that the item is really Item
    assert(item is BaseElement);
    
    // item != nil
    // We're being asked for n-th (index) child of an item
    return (item as! BaseElement).childs[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    // Item is expandable only if it has children
    return (item as? BaseElement)?.childs.count ?? 0 > 0
  }
  
  // MARK: - Delegates
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    let cellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as? NSTableCellView
    cellView?.textField?.stringValue = (item as! BaseElement).name
    cellView?.imageView?.image = (item as! BaseElement).icon

    return cellView
  }
  
}
