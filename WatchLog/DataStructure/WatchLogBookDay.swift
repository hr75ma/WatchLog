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
    var ParentUUID: UUID?
    
    
    
    @Relationship(deleteRule: .cascade) var LogEntries: [WatchLogBookEntry]?
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Date) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }

}
