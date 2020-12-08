//
//  SourceFile.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 06/12/2020.
//

import Cocoa

class BaseElement: NSObject {
  let name: String
  let path: String
  var icon: NSImage?
  var childs: [BaseElement]?
  
  init(_ fileName: String) {
    self.name = (fileName as NSString).lastPathComponent
    self.path = fileName
  }
}

class SourceFile: BaseElement {
  override init(_ fileName: String) {
    super.init(fileName);

    self.icon = NSImage.init(named: "File")
  }
}

class SourceFolder: BaseElement {
  override init(_ fileName: String) {
    super.init(fileName);

    self.icon = NSImage.init(named: "Folder")
  }
}
