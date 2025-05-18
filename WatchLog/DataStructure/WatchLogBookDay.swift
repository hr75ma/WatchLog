//
//  WatchLogBookDay.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//

import SwiftUI
import SwiftData

@Model
class WatchLogBookDay: Identifiable {

    #Unique<WatchLogBookDay>([\.uuid, \.LogDate])
    var LogDate: Int
    
    
    
    @Relationship(deleteRule: .cascade) var Children: [WatchLogBookEntry]? = nil
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Int) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }

}
