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


protocol DatabaseServiceProtocol:ObservableObject {
    func saveWatchLogBookEntry (LogEntry: WatchLogEntry) async -> Result<Void, Error>
    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogBookEntry, Error>
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
    
    func fetchLogBookEntry(with EntryUUID: UUID) async -> Result<WatchLogBookEntry, any Error> {
        let fetchResult = dataSource.fetchLogBookEntry(with: EntryUUID)
        switch fetchResult {
            case .success(let entry):
            return .success(entry)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
