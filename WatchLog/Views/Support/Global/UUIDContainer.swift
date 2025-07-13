//
//  UUIDContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import Foundation
import SwiftUI

@Observable
class LogEntryUUIDContainer: Equatable, Identifiable {
    public var id: UUID
    public var logEntryUUID: UUID
    public var logEntryBookDay: WatchLogBookDay
    
    init(id: UUID) {
        self.id = id
        logEntryUUID = UUID()
        logEntryBookDay = .init()
    }

    init() {
        id = UUID()
        logEntryUUID = UUID()
        logEntryBookDay = .init()
    }
    
    init(logEntryUUID: UUID, logBookDay: WatchLogBookDay) {
        self.id = UUID()
        self.logEntryUUID = logEntryUUID
        self.logEntryBookDay = logBookDay
    }
    
    static func == (lhs: LogEntryUUIDContainer, rhs: LogEntryUUIDContainer) -> Bool {
        return lhs.logEntryUUID == rhs.logEntryUUID && lhs.logEntryBookDay.uuid == rhs.logEntryBookDay.uuid
    }
}
