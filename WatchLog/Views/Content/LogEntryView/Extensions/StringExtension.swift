//
//  StringExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 18.05.25.
//

import SwiftUI



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
