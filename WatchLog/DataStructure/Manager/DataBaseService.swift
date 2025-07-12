//
//  DataBaseService.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
protocol DatabaseServiceProtocol {
    func saveWatchLogBookEntry(LogEntry: WatchLogEntry) async -> Result<Void, Error>

    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogEntry, Error>
    func fetchLogBookEntryMod(with EntryUUID: UUID) async -> Result<WatchLogBookEntry, Error>

    func fetchLogBookYears() async -> Result<[WatchLogBookYear], Error>
    func fetchLogBookEntries() async -> Result<[WatchLogBookEntry], Error>

    func fetchLogBook() async -> Result<[WatchLogBook], any Error>
    func fetchDaysFromLogBookEntry(logEntry: WatchLogBookEntry) async -> Result<[WatchLogBookEntry], Error>

    func removeWatchLogBookEntry(LogEntry: WatchLogEntry) async -> Result<Void, Error>
    func removeWatchLogBookDay(watchLogBookDay: WatchLogBookDay) async -> Result<Void, Error>
    func removeWatchLogBookMonth(watchLogBookMonth: WatchLogBookMonth) async -> Result<Void, Error>
    func removeWatchLogBookYear(watchLogBookYear: WatchLogBookYear) async -> Result<Void, Error>

    func existsWatchLogBookEntry(uuid: UUID) async -> Result<Bool, Error>

    func instanciateLogBook() async -> Result<Void, Error>
    
    func fetchLogEntriesFromDay(from: UUID) -> Result<[WatchLogBookEntry], Error>
}

@Observable
class DatabaseService: DatabaseServiceProtocol {
    @ObservationIgnored
    private let dataSource: DataBaseManagerProtocol

    @MainActor
    init(dataSource: DataBaseManagerProtocol = DataBaseManager.shared) {
        self.dataSource = dataSource
    }

    func existsWatchLogBookEntry(uuid: UUID) async -> Result<Bool, Error> {
        let fetchResult = dataSource.fetchLogBookEntry(with: uuid)
        switch fetchResult {
        case let .success(entry):
            if entry.isEmpty {
                return .success(false)
            }
            return .success(true)
        case let .failure(error):
            return .failure(error)
        }
    }

    func instanciateLogBook() async -> Result<Void, Error> {
        let logBookResult = dataSource.instanciateLogBook()
        switch logBookResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchDaysFromLogBookEntry(logEntry: WatchLogBookEntry) async -> Result<[WatchLogBookEntry], Error> {
        let fetchResult = dataSource.fetchDaysFromLogBookEntry(logEntry: logEntry)
        switch fetchResult {
        case let .success(result):
            return .success(result)
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookEntry(LogEntry: WatchLogEntry) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookEntry(with: LogEntry.uuid)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookDay(watchLogBookDay: WatchLogBookDay) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookDay(with: watchLogBookDay.uuid)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookMonth(watchLogBookMonth: WatchLogBookMonth) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookMonth(with: watchLogBookMonth.uuid)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookYear(watchLogBookYear: WatchLogBookYear) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookYear(with: watchLogBookYear.uuid)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func saveWatchLogBookEntry(LogEntry: WatchLogEntry) async -> Result<Void, Error> {
        let saveResult = dataSource.saveLogBookEntry(LogEntry: LogEntry)
        switch saveResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogEntry, Error> {
        var watchLogEntry: WatchLogEntry = WatchLogEntry(uudi: EntryUUID)
        let fetchResult = dataSource.fetchLogBookEntry(with: EntryUUID)
        switch fetchResult {
        case let .success(entry):
            if !entry.isEmpty {
                watchLogEntry = .init(watchLookBookEntry: entry.first!)
            }
            return .success(watchLogEntry)
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchLogBookEntryMod(with EntryUUID: UUID) async -> Result<WatchLogBookEntry, Error> {
        var watchLogBookEntry: WatchLogBookEntry = WatchLogBookEntry(uuid: EntryUUID)
        let fetchResult = dataSource.fetchLogBookEntry(with: EntryUUID)
        switch fetchResult {
        case let .success(entry):
            if !entry.isEmpty {
                watchLogBookEntry = entry.first!
            }
            return .success(watchLogBookEntry)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func fetchLogEntriesFromDay(from: UUID) -> Result<[WatchLogBookEntry], Error> {
        var logBookEntries: [WatchLogBookEntry] = []
        let fetchResult = dataSource.fetchLogEntriesFromDay(from: from)
        switch fetchResult {
        case let .success(entries):
            logBookEntries = entries
            return .success(logBookEntries)
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchLogBookYears() async -> Result<[WatchLogBookYear], any Error> {
        let fetchResult = dataSource.fetchYears()
        switch fetchResult {
        case let .success(entries):
            return .success(entries)
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchLogBook() async -> Result<[WatchLogBook], any Error> {
        let fetchResult = dataSource.fetchLogBook()
        switch fetchResult {
        case let .success(entries):
            return .success(entries)
        case let .failure(error):
            return .failure(error)
        }
    }

    func fetchLogBookEntries() async -> Result<[WatchLogBookEntry], any Error> {
        let fetchResult = dataSource.fetchEntries()
        switch fetchResult {
        case let .success(entries):
            return .success(entries)
        case let .failure(error):
            return .failure(error)
        }
    }
}
