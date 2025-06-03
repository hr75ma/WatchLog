//
//  WatchLogBookMonth.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftUI
import SwiftData

@Model
class WatchLogBookMonth: Identifiable, Hashable {
    #Unique<WatchLogBookMonth>([\.uuid, \.LogDate])
    
    var LogDate: Date
    @Attribute(.unique) var uuid: UUID
    
    
    @Relationship(deleteRule: .cascade) var watchLogBookDays: [WatchLogBookDay]? = []
    
    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookYear.watchLogBookMonths) var watchLogBookYear: WatchLogBookYear
    
    
    init(LogDate: Date, year: WatchLogBookYear) {
        self.LogDate = LogDate
        self.uuid = UUID()
        self.watchLogBookYear = year

    }
    
    init() {
        self.uuid = UUID()
        self.LogDate = Date()
        self.watchLogBookYear = WatchLogBookYear()
    }
}
