//
//  Document.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 06/12/2020.
//

import Cocoa
import SwiftHEXColors

class Document: NSDocument {
  
  // MARK: - Protected vars
  var sideBarWidth: CGFloat = 250
  var sideBarVisible: Bool = true
  var isApplyingStyles: Bool = false
  var contents: Content = Content("DEFINT A-Z\n")
  var syntaxs: CodeSyntax
  
  // MARK: - Private vars
  private var isRunning: Bool = false
  
  //- MARK: - Outlets
  @IBOutlet weak var mainEditor: NSTextView!
  @IBOutlet weak var splitView: NSSplitView!
  @IBOutlet weak var toolbar: NSToolbar!
  @IBOutlet var sourceListViewController: SourceListViewController!
  
  //- MARK: -
  override init() {
    let filepath = Bundle.main.path(forResource: "BasicSyntax", ofType: "json")
    let contents = try! String(contentsOfFile: filepath!).data(using: .utf8)
    
    self.syntaxs = try! JSONDecoder().decode(CodeSyntax.self, from: contents!)

    super.init()
  }
  
  override class var autosavesInPlace: Bool {
    return true
  }
  
  override var windowNibName: NSNib.Name? {
    // Returns the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
    return NSNib.Name("Document")
  }
  
  override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
    toolbar.displayMode = NSToolbar.DisplayMode.iconOnly
    
    if (!self.displayName.lowercased().hasSuffix(".bas")) {
      self.displayName.append(".bas")
    }
    self.displayName = self.displayName.uppercased()
    
    self.initiateEditor()
    NSApp.sendAction(#selector(SourceListViewController.loadDirectories(_:)), to: self.sourceListViewController, from: self)
  }
  
  /** method called when information is going to be saved  */
  override func data(ofType typeName: String) throws -> Data {
    return contents.data()!
  }
  
  /** method called when information is to being loaded */
  override func read(from data: Data, ofType typeName: String) throws {
    contents.read(data)
  }
  
}
