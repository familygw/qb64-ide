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
    
    //let folder: URL = try! FileManager.default.url(for: .userDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
    let folder: URL = URL(string: "file:///Users/\(NSUserName())/Projects/qb64/")!
    
    self.rootFolder = [SourceFile.buildNode(folder)]
    self.sourceListView?.reloadData()
  }
  
  // MARK: - DataSource
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    if (item == nil) {
      // item == nil
      // We're being asked for the number of top level elements (kAddToBag, ...)
      return self.rootFolder.count
    }
    // item != nil
    // We're being asked for the number of children of an item
    if let leaf = (item as? SourceFile) {
      if (leaf.isFolder) {
        leaf.childs = SourceFile.fetchChilds(leaf);
      }
      
      return leaf.childs.count
    }
    
    return 0
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if (item == nil) {
      // item == nil
      // We're being asked for n-th (index) top level element
      return rootFolder[index] as Any
    }
    // item != nil
    // We're being asked for n-th (index) child of an item
    return (item as! SourceFile).childs[index]
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    // Item is expandable only if it has children
    return (item as? SourceFile)!.isFolder
  }
  
  func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    if let leaf = (item as? SourceFile) {
      if (!leaf.isFolder) {
        //-
        //- Not a folder, then fetch content and override 
        do {
          let url = URL(string: "file://\(leaf.path)")
          let doc = (NSApplication.shared.orderedDocuments.first as? Document)
          if (doc != nil) {
            doc!.fileURL = url
            doc!.contents.contentString = try String(contentsOf: url!, encoding: .utf8)
            doc!.mainEditor.string = doc!.contents.contentString
            doc!.updateChangeCount(.changeCleared)
          }
        } catch {
          NSAlert.showAlert(title: "Open File", message: error.localizedDescription, style: .warning)
        }

      }
    }
    return true
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
