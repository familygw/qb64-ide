//
//  MainMenuController.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 08/12/2020.
//
import Cocoa
import Foundation

class MainMenuController : NSViewController, NSMenuDelegate {
  
  @IBAction func mnuRunApp(_ sender: Any) {
    print("RUN APP CALLED MENU")
    NSApplication.shared.sendAction(#selector(AppController.willRunApp(_:)), to: AppController.self, from: self)
  }
  
}
