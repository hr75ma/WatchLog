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
    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogEntry, Error>
    func fetchLogBookYears() async -> Result<[WatchLogBookYear], Error>
}

@Observable
class DatabaseService: DatabaseServiceProtocol {
    
    @ObservationIgnored
    private let dataSource: DataBaseManagerProtocol
    
    @MainActor
    init(dataSource: DataBaseManagerProtocol = DataBaseManager.shared) {
        self.dataSource = dataSource
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
    
    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogEntry, Error> {
        var WatchLogEntry: WatchLogEntry = WatchLogEntry()
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
    
}
