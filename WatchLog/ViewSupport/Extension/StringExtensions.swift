//
//  StringExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 18.05.25.
//

import SwiftUI

extension String {
  var isNumber: Bool {
    return self.range(
      of: "^[0-9]*$",  // 1
      options: .regularExpression) != nil
  }
}

extension String {
  var isDate: Bool {
    return self.range(
      of: "^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$",  // 1
      options: .regularExpression) != nil
  }
}

extension String {
  func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
    guard
      let index = firstIndex(where: {
        !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet)
      })
    else {
      return self
    }

    return String(self[index...])
  }
}
