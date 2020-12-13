//
//  File.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 12/12/2020.
//

import Cocoa
import Foundation

extension NSAlert {
  
  static func showAlert(title: String?, message: String?, style: Style = .informational, asSheet: Bool = false) -> Void {
    let alert = NSAlert()
    
    if let title = title {
      alert.messageText = title
    }
    
    if let message = message {
      alert.informativeText = message
    }
    alert.alertStyle = style
    
    alert.addButton(withTitle: "OK")

    if (asSheet) {
      alert.beginSheetModal(for: (NSApplication.shared.orderedDocuments.first?.windowForSheet)!, completionHandler: nil)
    } else {
      alert.runModal()
    }
  }
  
}
