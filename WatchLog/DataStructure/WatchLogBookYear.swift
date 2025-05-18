//
//  WatchLogBookYear.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//

import SwiftUI
import SwiftData

@Model
class WatchLogBookYear: Identifiable {
    #Unique<WatchLogBookYear>([\.uuid, \.LogDate])
    var LogDate: Date
    
    
    @Relationship(deleteRule: .cascade) var LogDateMonth: [WatchLogBookMonth]?
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Date) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }
}
