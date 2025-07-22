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
@Observable
class DatabaseService: DatabaseServiceProtocol {
    @ObservationIgnored
    private let dataSource: DataBaseManagerProtocol

    @MainActor
    init(dataSource: DataBaseManagerProtocol = DataBaseManager.shared) {
        self.dataSource = dataSource
    }

    func existsWatchLogBookEntry(logEntryID: UUID) async -> Result<Bool, Error> {
        let fetchResult = dataSource.fetchLogBookEntry(logEntryID: logEntryID)
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

    
    func fetchDayFromDate(from: Date) async -> Result<WatchLogBookDay?, Error> {
        let fetchResult = dataSource.fetchLogBookDayFromDate(from: from)
        switch fetchResult {
        case let .success(result):
            return .success(result)
        case let .failure(error):
            return .failure(error)
        }
    }

    
    func removeWatchLogBookEntry(logEntryID: UUID) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookEntry(logEntryID: logEntryID)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookDay(watchLogBookDay: WatchLogBookDay) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookDay(logDayID: watchLogBookDay.id)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookMonth(watchLogBookMonth: WatchLogBookMonth) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookMonth(logMonthID: watchLogBookMonth.id)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func removeWatchLogBookYear(watchLogBookYear: WatchLogBookYear) async -> Result<Void, Error> {
        let deleteResult = dataSource.removeLogBookYear(logYearID: watchLogBookYear.id)
        switch deleteResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }

    func saveWatchLogBookEntry(watchLogEntry: WatchLogEntry) async -> Result<Void, Error> {
        let saveResult = dataSource.saveLogBookEntry(watchLogEntry: watchLogEntry)
        switch saveResult {
        case .success:
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func fetchLogBookEntry(logEntryID: UUID) async -> Result<WatchLogBookEntry?, Error> {
        let fetchResult = dataSource.fetchLogBookEntry(logEntryID: logEntryID)
        switch fetchResult {
        case let .success(entry):
            if !entry.isEmpty {
                return .success(entry.first!)
            }
            return .success(nil)
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
    
    func fetchLogDay(logDayID: UUID) async -> Result<WatchLogBookDay?, any Error> {
        let fetchResult = dataSource.fetchLogBookDay(logDayID: logDayID)
        switch fetchResult {
        case let .success(entry):
            if entry != nil {
                return .success(entry!)
            }
            return .success(nil)
        case let .failure(error):
            return .failure(error)
        }
    }
}
