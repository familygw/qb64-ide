//
//  CompilerController.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 10/04/2021.
//

import Cocoa
import Foundation

public class AppController: NSObject {

  private static var lastAppTask: Process?

  @IBAction func willRunApp(_ sender: Any) {
    if let doc = NSApp.orderedDocuments.first as? Document {
      doc.save(withDelegate: self, didSave: #selector(AppController.didRunApp(_:_:)), contextInfo: nil)
    }
  }

  @IBAction func stopRunningApp(_ sender: Any) {
    AppController.lastAppTask?.terminate()
  }
  
  @objc func didRunApp(_ doc: Document, _ wasSaved: Bool) {
    print("DID RUN APP CALLED!!!")
    
    if (!wasSaved) {
      NSAlert.showAlert(title: "Error", message: "You must save the file before try to run the program.", style: .warning, asSheet: true)
    } else {
      
      let bndl = Bundle.main
      let execUrl = bndl.url(forResource: "qb64", withExtension: nil)
      
      guard execUrl != nil else {
        print("Cannot find QB64 executable!!")
        return
      }
      
      let progressHUD = ProgressHUDController(windowNibName: "ProgressHUD")
      progressHUD.showWindow(self)
      
      let outputFile = doc.fileURL!.deletingPathExtension()
      
      let pipe = Pipe()
      let qb64tsk = Process()
      qb64tsk.executableURL = execUrl
      qb64tsk.arguments = ["-x", "\(doc.fileURL!.path)", "-o", outputFile.path]
      qb64tsk.standardOutput = pipe
      
      do {
        try qb64tsk.run()
      } catch {
        print("Error running QB64: \(error)")
      }
      
      let handle = pipe.fileHandleForReading
      handle.waitForDataInBackgroundAndNotify()
      
      handle.readabilityHandler = { pipe in
        guard let currentOutput = String(data: pipe.availableData, encoding: .utf8) else {
          print("Error decoding data: \(pipe.availableData)")
          return
        }
        
        guard !currentOutput.isEmpty else {
          return
        }
        
        let regex = try! NSRegularExpression(pattern: "(\\[.*\\].([0-9]{1,3})%)")
        guard case let matches = regex.matches(in: currentOutput, options: [], range: NSRange(location: 0, length: currentOutput.count)), matches.count > 0 else {
          //print("NO MATCHES! Text was: \(currentOutput)")
          return
        }
        
        let groupRange = matches[0].range(at: 2)
        
        if let substringRange = Range(groupRange, in: currentOutput) {
          let percent = String(currentOutput[substringRange])
          
          DispatchQueue.main.sync {
            progressHUD.updateProgress(Double(percent)!)
          }
        }
        
      }
      
      qb64tsk.waitUntilExit()
      
      progressHUD.close()
      
      print("About to run executable now! \(outputFile.path)")
      
      AppController.lastAppTask?.terminate()
      AppController.lastAppTask = Process()
      AppController.lastAppTask!.executableURL = outputFile
      do {
        try AppController.lastAppTask!.run()
      } catch {
        print("Error running Output: \(error)")
      }
    }
  }

}
