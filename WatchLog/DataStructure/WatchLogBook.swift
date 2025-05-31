//
//  WatchLog.swift
//  WatchLog
//
//  Created by Marcus Hörning on 31.05.25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class WatchLogBook: Identifiable, Hashable {
    #Unique<WatchLogBook>([\.uuid])
    var ParentUUID: UUID?
    
    @Relationship(deleteRule: .deny) var Years: [WatchLogBookYear]?
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Date) {
        self.uuid = UUID()
    }
    
    init() {
        self.uuid = UUID()
    }
}
