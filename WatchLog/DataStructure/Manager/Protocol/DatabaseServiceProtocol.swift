//
//  DatabaseServiceProtocol.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.07.25.
//
import Combine
import Foundation
import SwiftData
import SwiftUI


@MainActor
protocol DatabaseServiceProtocol {
    func existsWatchLogBookEntry(logEntryID: UUID) async -> Result<Bool, Error>

    func instanciateLogBook() async -> Result<Bool, Error>
    
    //nur fürs testen
    func deleteLogBook() async -> Void

    func fetchLogBookEntry(logEntryID: UUID) async -> Result<WatchLogBookEntry?, Error>

    func fetchLogBookYears() async -> Result<[WatchLogBookYear], Error>
    func fetchLogBook() async -> Result<[WatchLogBook], any Error>

    func fetchLogDay(logDayID: UUID) async -> Result<WatchLogBookDay?, any Error>
    func fetchDayFromDate(from: Date) async -> Result<WatchLogBookDay?, Error>
    
    func saveWatchLogBookEntry(watchLogEntry: WatchLogEntry) async -> Result<Void, Error>

    func removeWatchLogBookEntry(logEntryID: UUID) async -> Result<Void, Error>
    func removeWatchLogBookDay(logDayID: UUID) async -> Result<Void, Error>
    func removeWatchLogBookMonth(logMonthID: UUID) async -> Result<Void, Error>
    func removeWatchLogBookYear(logYearID: UUID) async -> Result<Void, Error>
    
    func fetchNonClosedLogEntries() async -> Result<Set<UUID>, Error>

   
}
