//
//  SourceFile.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 06/12/2020.
//

import Cocoa

class SourceFile: NSObject {
  let name: String
  let path: String
  var icon: NSImage?
  var isFolder: Bool
  var childs: [SourceFile] = []
  
  init(_ fileName: String) {
    self.name = (fileName as NSString).lastPathComponent
    self.path = fileName
    self.isFolder = true

    super.init()
    self.actAsFolder()
  }
  
  func actAsFolder() -> Void {
    self.icon = NSImage(systemSymbolName: "folder.fill", accessibilityDescription: nil)
    self.isFolder = true
  }
  
  func actAsFile() -> Void {
    self.icon = NSImage(systemSymbolName: "doc.fill", accessibilityDescription: nil)
    self.isFolder = false
  }
  
  class func buildNode(_ url: URL) -> SourceFile {
    let node = SourceFile(url.path)
    if (url.hasDirectoryPath) {
      var files = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
      files.sort(by: {(_ a: URL, _ b: URL) in return (a.hasDirectoryPath || b.hasDirectoryPath) })

      for file in files {
        node.childs.append(SourceFile.buildNode(file))
      }
      
      node.actAsFolder()
    } else {
      node.actAsFile()
    }
    return node
    
  }
}
