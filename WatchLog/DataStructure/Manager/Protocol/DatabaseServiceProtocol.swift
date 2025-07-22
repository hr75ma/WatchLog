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
    func saveWatchLogBookEntry(watchLogEntry: WatchLogEntry) async -> Result<Void, Error>

    func fetchLogBookEntry(logEntryID: UUID) async -> Result<WatchLogEntry, Error>
    func fetchLogBookEntryMod(logEntryID: UUID) async -> Result<WatchLogBookEntry, Error>
    func fetchLogBookEntryWithNil(logEntryID: UUID) async -> Result<WatchLogBookEntry?, Error>

    func fetchLogBookYears() async -> Result<[WatchLogBookYear], Error>
    func fetchLogBookEntries() async -> Result<[WatchLogBookEntry], Error>
    func fetchLogBook() async -> Result<[WatchLogBook], any Error>

    func fetchLogDay(logDayID: UUID) async -> Result<WatchLogBookDay?, any Error>
    func fetchDayFromDate(from: Date) async -> Result<WatchLogBookDay?, Error>

    func removeWatchLogBookEntry(watchLogEntry: WatchLogEntry) async -> Result<Void, Error>
    func removeWatchLogBookEntry(logEntryID: UUID) async -> Result<Void, Error>
    func removeWatchLogBookDay(watchLogBookDay: WatchLogBookDay) async -> Result<Void, Error>
    func removeWatchLogBookMonth(watchLogBookMonth: WatchLogBookMonth) async -> Result<Void, Error>
    func removeWatchLogBookYear(watchLogBookYear: WatchLogBookYear) async -> Result<Void, Error>

    func existsWatchLogBookEntry(logEntryID: UUID) async -> Result<Bool, Error>

    func instanciateLogBook() async -> Result<Void, Error>
}
