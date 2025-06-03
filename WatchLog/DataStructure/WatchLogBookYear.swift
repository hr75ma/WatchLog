//
//  WatchLogBookYear.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftUI
import SwiftData

@Model
class WatchLogBookYear: Identifiable, Hashable {
    #Unique<WatchLogBookYear>([\.uuid, \.LogDate])
    var LogDate: Date
    @Attribute(.unique) var uuid: UUID
    
    
    @Relationship(deleteRule: .cascade) var watchLogBookMonths: [WatchLogBookMonth]? = []
    
    @Relationship(deleteRule: .nullify, inverse: \WatchLogBook.watchLogBookYears) var watchLogBook: WatchLogBook
    
    
    init(LogDate: Date, logBook: WatchLogBook) {
        self.LogDate = LogDate
        self.uuid = UUID()
        self.watchLogBook = logBook
    }
    
    init() {
        self.LogDate = .now
        self.uuid = UUID()
        self.watchLogBook = WatchLogBook()
    }
}
