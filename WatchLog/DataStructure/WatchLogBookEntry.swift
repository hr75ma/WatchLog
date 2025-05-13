//
//  WatchLogBookYEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//

import SwiftUI
import SwiftData

@Model
class WatchLogBookEntry: Identifiable {
    @Published var LogDate: Date
    @Attribute(.unique) var uuid: UUID
    
    
    init(LogDate: Date) {
        self.LogDate = LogDate
    }

}
