//
//  Content.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 07/12/2020.
//
import Cocoa
import Foundation

class Content: NSObject {
  @objc dynamic var contentString = ""
  
  public init(_ contentString: String) {
    self.contentString = contentString
  }
  
}

extension Content {
  
  func read(_ data: Data) {
    contentString = String(bytes: data, encoding: .utf8)!
  }
  
  func data() -> Data? {
    return contentString.data(using: .utf8)
  }
  
}
