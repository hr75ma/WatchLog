//
//  LocalizedStringKeyExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 28.07.25.
//

import Foundation
import SwiftUI


extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
}
