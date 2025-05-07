//
//  Item.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
