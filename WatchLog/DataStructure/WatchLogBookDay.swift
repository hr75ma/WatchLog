//
//  WatchLogBookDay.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftUI
import SwiftData

@Model
class WatchLogBookDay: Identifiable, Hashable {

    #Unique<WatchLogBookDay>([\.uuid, \.LogDate])
    var LogDate: Date
    
    
    
    @Attribute(.unique) var uuid: UUID
    
    @Relationship(deleteRule: .cascade) var watchLogBookEntries: [WatchLogBookEntry]? = []
    
    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookMonth.watchLogBookDays) var watchLogBookMonth: WatchLogBookMonth
    
    
    init(LogDate: Date, month: WatchLogBookMonth) {
        self.LogDate = LogDate
        self.uuid = UUID()
        self.watchLogBookMonth = month
        
    }
    
    init() {
        self.LogDate = .now
        self.uuid = UUID()
        self.watchLogBookMonth = WatchLogBookMonth()
    }

}
