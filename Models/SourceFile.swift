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
  
  private func actAsFolder() -> Void {
    self.icon = NSImage(named: "Folder")
    self.isFolder = true
  }
  
  private func actAsFile() -> Void {
    self.icon = NSImage(named: "Document")
    self.isFolder = false
  }
  
  class func buildNode(_ url: URL) -> SourceFile {
    let node = SourceFile(url.path)
    if (url.hasDirectoryPath) { node.actAsFolder() }
    else { node.actAsFile() }
    
    return node
  }
  
  class func fetchChilds(_ url: SourceFile) -> [SourceFile] {
    var childs: [SourceFile] = []
    var sortedElements: [URL] = []
    
    if (url.isFolder) {
      do {
        //-
        //- Will obtain all content, then will separe folders from files (two lists)
        //- sort them and comine in one (files)
        let content: [URL] = try FileManager.default.contentsOfDirectory(at: URL.init(fileURLWithPath: url.path, isDirectory: true), includingPropertiesForKeys: nil)
        var folders: [URL] = content.filter({$0.hasDirectoryPath});
        var files: [URL] = content.filter({ !$0.hasDirectoryPath && ($0.pathExtension.compare("bas", options: .caseInsensitive, range: nil, locale: nil) == .orderedSame) });
        
        folders.sort(by: {(_ a: URL, _ b: URL) in return ((a.path as NSString).lastPathComponent.lowercased() < (b.path as NSString).lastPathComponent.lowercased()) })
        files.sort(by: {(_ a: URL, _ b: URL) in return ((a.path as NSString).lastPathComponent.lowercased() < (b.path as NSString).lastPathComponent.lowercased()) })
        
        sortedElements.append(contentsOf: folders)
        sortedElements.append(contentsOf: files)
      } catch { }
      //-
      //- Iterate childs and build the correct node
      for elm in sortedElements { childs.append(SourceFile.buildNode(elm)) }
    }
    return childs;
    
  }
}
