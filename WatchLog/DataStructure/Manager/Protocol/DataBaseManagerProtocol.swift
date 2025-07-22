//
//  DataBaseManagerProtocol.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.07.25.
//

import Foundation
import SwiftUI
import SwiftData

enum DataBaseError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
}

protocol DataBaseManagerProtocol {
    
    func fetchLogBook() -> Result<[WatchLogBook], Error>
    func fetchYears() -> Result<[WatchLogBookYear], Error>
    func fetchLogBookDay(logDayID: UUID) -> Result<WatchLogBookDay?, Error>
    func fetchLogBookDayFromDate(from: Date) -> Result<WatchLogBookDay?, Error>
    func fetchLogBookEntry(logEntryID: UUID) -> Result<[WatchLogBookEntry], Error>
    
    
    func removeLogBookEntry(logEntryID: UUID) -> Result<Void, Error>
    func removeLogBookDay(logDayID: UUID) -> Result<Void, Error>
    func removeLogBookMonth(logMonthID: UUID) -> Result<Void, Error>
    func removeLogBookYear(logYearID: UUID) -> Result<Void, Error>
    
    func saveLogBookEntry(watchLogEntry: WatchLogEntry) -> Result<Void, Error>

    func instanciateLogBook() -> Result<WatchLogBook, Error>
}

extension DataBaseManager: DataBaseManagerProtocol {}
