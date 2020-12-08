//
//  DocumentExtensions.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 07/12/2020.
//
import Cocoa
import Foundation

extension Document: NSTextStorageDelegate, NSWindowDelegate {
  
  // MARK: - Window Delegates
  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    sideBarWidth = splitView.subviews[0].frame.width
    
    return frameSize
  }
  
  func windowDidResize(_ notification: Notification) {
    splitView.setPosition(sideBarWidth, ofDividerAt: 0)
  }
  
  // MARK: - TextStorage Delegates
  func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    if delta != 0 && editedMask.rawValue > 1 {
      guard let filepath = Bundle.main.path(forResource: "BasicSyntax", ofType: "json") else { return }
      guard let contents = try? String(contentsOfFile: filepath).data(using: .utf8) else { return }
      guard let syntax = try? JSONDecoder().decode(CodeSyntax.self, from: contents) else { return }
      
      var extended = NSUnionRange(editedRange, NSString(string: mainEditor.string).lineRange(for: NSMakeRange(editedRange.location, 0)))
      extended = NSUnionRange(editedRange, NSString(string: mainEditor.string).lineRange(for: NSMakeRange(NSMaxRange(editedRange), 0)))
      
      for setting in syntax.settings {
        //-
        let regex = try! NSRegularExpression.init(pattern: setting.exp, options: [.anchorsMatchLines, .caseInsensitive])
        regex.enumerateMatches(in: textStorage.string, options: [], range: extended) { (match, flags, stop) in
          //-
          //- Define text attributes
          let matchColor = [NSAttributedString.Key.foregroundColor : NSColor(hexString: setting.color)!]
          //-
          //- Identify where in document the match was found (index, length)
          let matchRange = match!.range(at: 1)
          applyStyles(textStorage, matchColor, matchRange, setting.upper)
          //-
          //- Now go and lookup for all other coincidences
          let maxRange = matchRange.location + matchRange.length
          if ((maxRange + 1) < textStorage.length) {
            applyStyles(textStorage, matchColor, NSMakeRange(maxRange, 0), setting.upper)
          }
        }
        //-
      }
    }
  }
  
  private func applyStyles(_ textStorage: NSTextStorage, _ attrs: [NSAttributedString.Key : Any], _ range: NSRange, _ upper: Bool = false) {
    textStorage.addAttributes(attrs, range: range)
    if (upper) {
      textStorage.replaceCharacters(in: range, with: (textStorage.string as NSString).substring(with: range).uppercased() )
    }
  }
  
  // MARK: - Actions
  @IBAction func btnRunClick(_ sender: Any) {
    NSApp.sendAction(#selector(AppDelegate.runApp(_:)), to: nil, from: self)
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
  
  func initiateEditor() {
    //-
    //- Setup editor preferences
    mainEditor.font = NSFont(name: "ModernDOS9x16", size: 16)
    mainEditor.textColor = NSColor(hexString: "#ffffff")
    mainEditor.backgroundColor = NSColor(hexString: "#0000aa")!
    
    mainEditor.isAutomaticDataDetectionEnabled = false
    mainEditor.isAutomaticLinkDetectionEnabled = false
    mainEditor.isAutomaticTextCompletionEnabled = false
    mainEditor.isAutomaticTextReplacementEnabled = false
    mainEditor.isAutomaticDashSubstitutionEnabled = false
    mainEditor.isAutomaticQuoteSubstitutionEnabled = false
    mainEditor.isAutomaticSpellingCorrectionEnabled = false
    
    mainEditor.textStorage?.delegate = self
    
    let lines = String(contents.contentString.components(separatedBy: "\n").count) as NSString
    let size = lines.size(withAttributes: [NSAttributedString.Key.font: mainEditor.font!])
    mainEditor.lnv_setUpLineNumberView(size.width + 11)
    
    mainEditor.string = contents.contentString
  }
  
}
