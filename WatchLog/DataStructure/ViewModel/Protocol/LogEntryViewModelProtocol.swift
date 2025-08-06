//
//  LogEntryViewModelProtocol.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.07.25.
//

import Foundation
import SwiftData
import SwiftUI

enum DeleteTypes: CaseIterable, Codable {
    // case logEntry
    case day
    case month
    case year
    case undefined

    static let deleteType: DeleteTypes = .undefined
}

@MainActor
protocol LogEntryViewModelProtocol {
    var errorMessage: String? {get set}
    var WatchLogBooks: [WatchLogBook] {get set}
    
    
    func calculateShownAndDeleteLogEntry(logEntryID: UUID, logDayID: UUID) async -> LogEntryUUIDContainer
    
    func instanciateLogBook() async -> Bool
    
    //nur fürs testen
    func deleteLogBook() async -> Void
    
    func isDeletedEntryInDisplayedDay(logEntryID: UUID, logDayID: UUID) async -> Bool
    func isLogBookEntryExisting(logEntryID uuid: UUID) async -> Bool
    
    func fetchLogBookDay(logDayID: UUID) async -> WatchLogBookDay?
    func fetchLogBookEntry(logEntryID: UUID) async -> WatchLogBookEntry?
    func fetchLogEntryMod(logEntryID: UUID) async -> WatchLogEntry
    func fetchLogBookDay(from: Date) async -> WatchLogBookDay?
    func fetchLogBook() async -> Void
    
    func deleteLogEntry(logEntryID: UUID) async -> Void
    func deleteLogDay(watchLogBookDay: WatchLogBookDay) async -> Void
    func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) async -> Void
    func deleteLogYear(watchLogBookYear: WatchLogBookYear) async -> Void
    
    func saveLogEntry(watchLogEntry: WatchLogEntry, setOfNonClosedLogBookEntries: inout Set<UUID>?) async -> Void
    func saveLogEntry(watchLogEntry: WatchLogEntry) async -> Void
    
    func delete<T>(deleteType: DeleteTypes, toDeleteItem: T, displayedUUID: UUID, logEntryUUIDContainer: LogEntryUUIDContainer)  async -> LogEntryUUIDContainer
    
    func setOfNonClosedLogBookEntries() async -> Set<UUID>
    
    
    
    //Mock Data
    func generateLogBookEntry() -> Void
    func generateAutomaticMockDatas() -> Void
}
