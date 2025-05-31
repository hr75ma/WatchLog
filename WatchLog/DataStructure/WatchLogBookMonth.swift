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
    var ParentUUID: UUID?
    
    @Relationship(deleteRule: .cascade) var Days: [WatchLogBookDay] = []
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Date) {
        self.LogDate = LogDate
        self.uuid = UUID()
    }

}
