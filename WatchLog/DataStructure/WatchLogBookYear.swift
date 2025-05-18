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
    var LogDate: Int
    
    
    @Relationship(deleteRule: .cascade) var Children: [WatchLogBookMonth]? = nil
    //@Attribute(.unique) var uuid: UUID
    var uuid: UUID
    
    init(LogDate: Int) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }
}
