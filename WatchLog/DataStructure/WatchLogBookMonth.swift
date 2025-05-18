//
//  WatchLogBookMonth.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//

import SwiftUI
import SwiftData

@Model
class WatchLogBookMonth: Identifiable {
    #Unique<WatchLogBookMonth>([\.uuid, \.LogDate])
    var LogDate: Int
    
    
    @Relationship(deleteRule: .cascade) var LogDateDay: [WatchLogBookDay]? = nil
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Int) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }

}
