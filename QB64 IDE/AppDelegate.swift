//
//  AppDelegate.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 06/12/2020.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  func applicationShouldTerminate(_ sender: NSApplication)-> NSApplication.TerminateReply {
    return .terminateNow
  }
  
  @objc func willRunApp(_ sender: Any) {
    if let doc = NSApp.orderedDocuments.first as? Document {
      doc.save(withDelegate: self, didSave: #selector(AppDelegate.didRunApp(_:_:)), contextInfo: nil)
    }
  }
  
  @objc func didRunApp(_ sender: Any, _ didSave: Bool) {
    if (!didSave) {
      NSAlert.showAlert(title: "Error", message: "You must save the file before try to run the program.", style: .warning, asSheet: true)
    } else {
      print("RUN APP!!! \(didSave)")
    }
  }
  
}

