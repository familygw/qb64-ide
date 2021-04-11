//
//  ProgressHUDController.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 10/04/2021.
//

import Cocoa
import Foundation

class ProgressHUDController : NSWindowController, NSWindowDelegate {
  
  @IBOutlet weak var progressBar: NSProgressIndicator!
  @IBOutlet weak var lblMessage: NSTextField!
  
  override func windowDidLoad() {
    window?.level = .modalPanel
    window?.styleMask = .utilityWindow

    progressBar.minValue = 0
    progressBar.maxValue = 100
    progressBar.doubleValue = 0.0
  }

  func updateProgress(_ value: Double) -> Void {
    progressBar.doubleValue = value
  }

}
