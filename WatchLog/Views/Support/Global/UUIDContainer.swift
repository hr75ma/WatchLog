//
//  UUIDContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import Foundation
import SwiftUI

@Observable
class LogEntryUUIDContainer: Equatable, Identifiable, Codable {
    public var id: UUID
    public var logDayUUID: UUID
    public var logEntryUUID: UUID
    
    init(id: UUID) {
        self.id = id
        logDayUUID = UUID()
        logEntryUUID = UUID()
    }

    init() {
        id = UUID()
        logDayUUID = UUID()
        logEntryUUID = UUID()
    }
    
    init(logEntryUUID: UUID, logDayUUID: UUID) {
        self.id = UUID()
        self.logEntryUUID = logEntryUUID
        self.logDayUUID = logDayUUID
    }
    
    static func == (lhs: LogEntryUUIDContainer, rhs: LogEntryUUIDContainer) -> Bool {
        return lhs.logEntryUUID == rhs.logEntryUUID && lhs.logDayUUID == rhs.logDayUUID
    }
}
