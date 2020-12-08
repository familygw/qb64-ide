//
//  DocumentExtensions.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 07/12/2020.
//
import Cocoa
import Foundation

extension Document: NSTextStorageDelegate {
  
  func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    //textEditor.process(editedRange)
    //print("Delta \(delta) - Mask: \(editedMask.rawValue)")
    if delta != 0 && editedMask.rawValue > 1 {
      //print("Has changed, colorizing...")
      
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

}
