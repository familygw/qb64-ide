//
//  Document.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 06/12/2020.
//

import Cocoa
import SwiftHEXColors

class Document: NSDocument, NSWindowDelegate {
  
  // MARK: - Private vars
  private var contents: Content = Content("DEFINT A-Z\n")
  private var sideBarWidth: CGFloat = 250
  private var isRunning: Bool = false
  private var sideBarVisible: Bool = true
  private var rootFolder: BaseElement?;
  
  //- MARK: - Outlets
  @IBOutlet weak var mainEditor: NSTextView!
  @IBOutlet weak var splitView: NSSplitView!
  @IBOutlet weak var toolbar: NSToolbar!
  
  //- MARK: -
  override init() {
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
    
    self.displayName.append(".bas")
    self.displayName = self.displayName.uppercased()
    
    rootFolder = SourceFolder("/Users/familygw/Projects/QB64IDE");
    rootFolder?.childs?.append(SourceFile("/Users/familygw/Projects/QB64IDE/file1.bas"))
    rootFolder?.childs?.append(SourceFile("/Users/familygw/Projects/QB64IDE/file2.bas"))
    rootFolder?.childs?.append(SourceFile("/Users/familygw/Projects/QB64IDE/file3.bas"))
    
    self.initiateEditor()
  }
  
  override func makeWindowControllers() {
    super.makeWindowControllers()
  }
  
  override func data(ofType typeName: String) throws -> Data {
    return contents.data()!
  }
  
  override func read(from data: Data, ofType typeName: String) throws {
    contents.read(data)
  }
  
  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    sideBarWidth = splitView.subviews[0].frame.width
    
    return frameSize
  }
  
  func windowDidResize(_ notification: Notification) {
    splitView.setPosition(sideBarWidth, ofDividerAt: 0)
  }
  
  // MARK: - Actions
  @IBAction func btnRunClick(_ sender: Any) {
  }
  
  @IBAction func btnStopClick(_ sender: Any) {
  }
  
  @IBAction func toggleSidebar(_ sender: Any) {
    if (sideBarVisible) {
      sideBarWidth = splitView.subviews[0].frame.width
      animatePanelChange(toPosition: 0, ofDividerAt: 0, to: false)
      sideBarVisible = false
    } else {
      animatePanelChange(toPosition: sideBarWidth, ofDividerAt: 0, to: false)
      sideBarVisible = true
    }
  }
  
  private func animatePanelChange(toPosition position: CGFloat, ofDividerAt dividerIndex: Int, to visible: Bool) {
    NSAnimationContext.runAnimationGroup { context in
      context.allowsImplicitAnimation = true
      context.duration = 0.3
      
      splitView.setPosition(position, ofDividerAt: dividerIndex)
      splitView.layoutSubtreeIfNeeded()
    }
  }
  
  private func initiateEditor() {
    //-
    //- Setup editor preferences
    mainEditor.font = NSFont(name: "ModernDOS9x16", size: 16)
    mainEditor.textColor = NSColor(hexString: "#ffffff")
    mainEditor.backgroundColor = NSColor(hexString: "#0000aa")!
    mainEditor.isAutomaticQuoteSubstitutionEnabled = false
    mainEditor.textStorage?.delegate = self
    
    let lines = String(contents.contentString.components(separatedBy: "\n").count) as NSString
    let size = lines.size(withAttributes: [NSAttributedString.Key.font: mainEditor.font!])
    mainEditor.lnv_setUpLineNumberView(size.width + 11)
    
    mainEditor.string = contents.contentString
  }
  
}
