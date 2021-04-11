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
  
}

