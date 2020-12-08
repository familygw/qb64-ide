//
//  Syntax.swift
//  QB64 IDE
//
//  Created by Carlos A. Leguizamón on 07/12/2020.
//

class CodeSyntax: Decodable {
  var settings: [CodeSyntaxSettings] = []
}

class CodeSyntaxSettings: Decodable {
  var exp: String
  var color: String
  var upper: Bool
}
