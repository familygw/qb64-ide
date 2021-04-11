//
//  DocumentExtensions.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 07/12/2020.
//
import Cocoa
import Foundation

extension Document: NSWindowDelegate, NSTextViewDelegate, NSTextStorageDelegate {
  
  // MARK: - Window Delegates
  func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
    if (splitView.subviews[0].frame.width > 1) {
      sideBarWidth = splitView.subviews[0].frame.width
    }
    
    return frameSize
  }
  
  func windowDidResize(_ notification: Notification) {
    if (splitView.subviews[0].frame.width > 1) {
      splitView.setPosition(sideBarWidth, ofDividerAt: 0)
    }
  }
  
  // MARK: - TextStorage & TextView Delegates
  func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
    if (replacementString == "\n") {
      self.isApplyingStyles = true
      
      self.applyStyles(textView, affectedCharRange)
      
      self.isApplyingStyles = false
    }
    
    return true //- always true, so the text is printed in textview
  }
  
  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    let arr:[Selector] = [#selector(NSStandardKeyBindingResponding.moveUp(_:)), #selector(NSStandardKeyBindingResponding.moveDown(_:))]
    
    if arr.firstIndex(of: commandSelector) != nil {
      self.applyStyles(textView, NSRange(location: 0, length: textView.string.count))
    }
    
    return false //- always false, so the cursor can change in text content
  }
  
  func applyStyles(_ textView:NSTextView, _ range: NSRange) {
    
    var extended = NSUnionRange(range, NSString(string: mainEditor.string).lineRange(for: NSMakeRange(range.location, 0)))
    extended = NSUnionRange(range, NSString(string: mainEditor.string).lineRange(for: NSMakeRange(NSMaxRange(range), 0)))
    
    for setting in self.syntaxs.settings {
      //-
      let regex = try! NSRegularExpression.init(pattern: setting.exp, options: [.anchorsMatchLines, .caseInsensitive])
      regex.enumerateMatches(in: textView.string, options: [], range: extended) { (match, flags, stop) in
        //-
        //- Define text attributes
        let matchColor = [NSAttributedString.Key.foregroundColor : NSColor(hexString: setting.color)!]
        //-
        //- Identify where in document the match was found (index, length)
        let matchRange = match!.range(at: 1)
        applyStyles(textView.textStorage!, matchColor, matchRange, setting.upper)
        //-
        //- Now go and lookup for all other coincidences
        let maxRange = matchRange.location + matchRange.length
        if ((maxRange + 1) < textView.textStorage!.length) {
          applyStyles(textView.textStorage!, matchColor, NSMakeRange(maxRange, 0), setting.upper)
        }
      }
      //-
    }
    
    self.contents.contentString = textView.textStorage!.string
    self.updateChangeCount(.changeDone) //- tell document/window that there is changes!
  }
  
  func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    
    if ((editedMask.rawValue < 3) && !self.isApplyingStyles) {
      self.applyStyles(mainEditor, editedRange)
    }
    
  }
  
  private func applyStyles(_ textStorage: NSTextStorage, _ attrs: [NSAttributedString.Key : Any], _ range: NSRange, _ upper: Bool = false) {
    textStorage.addAttributes(attrs, range: range)
    if (upper) {
      textStorage.replaceCharacters(in: range, with: (textStorage.string as NSString).substring(with: range).uppercased() )
    }
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
    
    mainEditor.textStorage!.delegate = self
    
    let lines = String(contents.contentString.components(separatedBy: "\n").count) as NSString
    let size = lines.size(withAttributes: [NSAttributedString.Key.font: mainEditor.font!])
    mainEditor.lnv_setUpLineNumberView(size.width + 11)
    
    mainEditor.string = contents.contentString
  }
  
}
