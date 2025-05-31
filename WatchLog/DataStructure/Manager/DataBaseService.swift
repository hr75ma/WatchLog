//
//  DataBaseService.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//

import SwiftData
import Combine
import SwiftUI
import Foundation

@MainActor
protocol DatabaseServiceProtocol {
    func saveWatchLogBookEntry (LogEntry: WatchLogEntry) async -> Result<Void, Error>
    func fetchLogBookEntry(with EntryUUID: UUID)  -> Result<WatchLogEntry, Error>
    func fetchLogBookYears() async -> Result<[WatchLogBookYear], Error>
    func fetchLogBookEntries() async -> Result<[WatchLogBookEntry], Error>
    func removeWatchLogBookEntry (LogEntry: WatchLogEntry) async -> Result<Void, Error>
    func fetchLogBook() async -> Result<[WatchLogBook], any Error>
}

@Observable
class DatabaseService: DatabaseServiceProtocol {
    
    @ObservationIgnored
    private let dataSource: DataBaseManagerProtocol
    
    @MainActor
    init(dataSource: DataBaseManagerProtocol = DataBaseManager.shared) {
        self.dataSource = dataSource
    }
    
    func removeWatchLogBookEntry (LogEntry: WatchLogEntry) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookEntry(with: LogEntry.uuid)
        switch deleteResult {
            case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    
    func saveWatchLogBookEntry (LogEntry: WatchLogEntry) async -> Result<Void, Error> {
        let saveResult =  dataSource.saveLogBookEntry(LogEntry: LogEntry)
        switch saveResult {
            case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchLogBookEntry(with EntryUUID: UUID)  -> Result<WatchLogEntry, Error> {
        var WatchLogEntry: WatchLogEntry = WatchLogEntry(uudi: EntryUUID)
        let fetchResult = dataSource.fetchLogBookEntry(with: EntryUUID)
        switch fetchResult {
        case .success(let entry):
            if !entry.isEmpty {
                WatchLogEntry = .init(WatchLookBookEntry: entry.first!)
            }
            return .success(WatchLogEntry)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchLogBookYears() async -> Result<[WatchLogBookYear], any Error> {
        let fetchResult = dataSource.fetchYears()
        switch fetchResult {
        case .success(let entries):
            return .success(entries)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchLogBook() async -> Result<[WatchLogBook], any Error> {
        let fetchResult = dataSource.fetchLogBook()
        switch fetchResult {
        case .success(let entries):
            return .success(entries)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    func fetchLogBookEntries() async -> Result<[WatchLogBookEntry], any Error> {
        let fetchResult = dataSource.fetchEntries()
        switch fetchResult {
        case .success(let entries):
            return .success(entries)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
