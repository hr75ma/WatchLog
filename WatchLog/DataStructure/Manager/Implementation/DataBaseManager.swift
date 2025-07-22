//
//  DataBaseManager.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//

import SwiftData
import SwiftUI

final class DataBaseManager {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = DataBaseManager()

    @MainActor
    private init() {
        do {
            // preview
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            
            modelContainer = try ModelContainer(for: WatchLogBook.self, WatchLogBookYear.self, WatchLogBookMonth.self, WatchLogBookDay.self, WatchLogBookEntry.self, configurations: config)
            
            // self.modelContainer = try ModelContainer(for: WatchLogBook.self)
            modelContext = modelContainer.mainContext
            modelContext.autosaveEnabled = false
            
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }

    private func fetchLogBookYear(with EntryUUID: UUID) -> [WatchLogBookYear] {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>(
            predicate: #Predicate { $0.id == EntryUUID })
        do {
            let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
            return fetchedEntries!
        }
    }

    private func fetchLogBookMonth(with EntryUUID: UUID) -> [WatchLogBookMonth] {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookMonth>(
            predicate: #Predicate { $0.id == EntryUUID })
        do {
            let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
            return fetchedEntries!
        }
    }

    private func fetchLogBookDay(with EntryUUID: UUID) -> [WatchLogBookDay] {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookDay>(
            predicate: #Predicate { $0.id == EntryUUID })
        do {
            let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
            return fetchedEntries!
        }
    }

    private func fetchLogBook(with EntryUUID: UUID) -> [WatchLogBook] {
        let fetchDiscriptor = FetchDescriptor<WatchLogBook>(
            predicate: #Predicate { $0.id == EntryUUID })
        do {
            let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
            return fetchedEntries!
        }
    }

    func instanciateLogBook() -> Result<WatchLogBook, Error> {
        var logWatchBook: WatchLogBook?
        let fetchLogBookDiscriptor = FetchDescriptor<WatchLogBook>()

        do {
            logWatchBook = try modelContext.fetch(fetchLogBookDiscriptor).first
        } catch {
            print("fetch WatchLogBook failed")
        }

        if logWatchBook == nil {
            logWatchBook = WatchLogBook()
            modelContext.insert(logWatchBook!)
            try? modelContext.save()
        }
        return .success(logWatchBook!)
    }

    // fehler abfragen einbauen
    func removeLogBookYear(logYearID: UUID) -> Result<Void, Error> {
        var logYear = WatchLogBookYear()
        var logBook = WatchLogBook()

        let fetchYearResult = fetchLogBookYear(with: logYearID)
        logYear = fetchYearResult.first!

        // remove year
        modelContext.delete(logYear)
        try? modelContext.save()

        return .success(())
    }

    //    //fehler abfragen einbauen
    func removeLogBookMonth(logMonthID: UUID) -> Result<Void, Error> {
        var logMonth = WatchLogBookMonth()
        var logYear = WatchLogBookYear()

        let fetchMonthResult = fetchLogBookMonth(with: logMonthID)
        logMonth = fetchMonthResult.first!

        // remove month
        modelContext.delete(logMonth)
        try? modelContext.save()

        // check if year has zero entries --> can be deleted
        let fetchYearResult = fetchLogBookYear(with: logMonth.watchLogBookYear!.id)
        logYear = fetchYearResult.first!
        if logYear.watchLogBookMonths!.isEmpty {
            modelContext.delete(logYear)
            try? modelContext.save()
        }

        try? modelContext.save()
        return .success(())
    }

    //    //fehler abfragen einbauen
    func removeLogBookDay(logDayID: UUID) -> Result<Void, Error> {
        var logDay = WatchLogBookDay()
        var logMonth = WatchLogBookMonth()
        var logYear = WatchLogBookYear()

        let fetchDayResult = fetchLogBookDay(with: logDayID)
        logDay = fetchDayResult.first!

        // remove day
        modelContext.delete(logDay)
        try? modelContext.save()

        // check if month has zero entries --> can be deleted
        let fetchMonthResult = fetchLogBookMonth(with: logDay.watchLogBookMonth!.id)
        logMonth = fetchMonthResult.first!
        if logMonth.watchLogBookDays!.isEmpty {
            modelContext.delete(logMonth)
            try? modelContext.save()

            // check if year has zero entries --> can be deleted
            let fetchYearResult = fetchLogBookYear(with: logMonth.watchLogBookYear!.id)
            logYear = fetchYearResult.first!
            if logYear.watchLogBookMonths!.isEmpty {
                modelContext.delete(logYear)
                try? modelContext.save()
            }
        }
        try? modelContext.save()
        return .success(())
    }

    //
    func removeLogBookEntry(logEntryID EntryUUID: UUID) -> Result<Void, Error> {
        var logEntry = WatchLogBookEntry()
        var logDay = WatchLogBookDay()
        var logMonth = WatchLogBookMonth()
        var logYear = WatchLogBookYear()

        let fetchResult = fetchLogBookEntry(logEntryID: EntryUUID)
        switch fetchResult {
        case let .success(entry):
            if !entry.isEmpty {
                logEntry = entry.first!
                // remove entry
                modelContext.delete(logEntry)
                try? modelContext.save()

                // check if day has zero entries --> can be deleted
                let fetchDayResult = fetchLogBookDay(with: logEntry.watchLogBookDay!.id)
                logDay = fetchDayResult.first!
                if logDay.watchLogBookEntries!.isEmpty {
                    modelContext.delete(logDay)
                    try? modelContext.save()

                    // check if month has zero entries --> can be deleted
                    let fetchMonthResult = fetchLogBookMonth(with: logDay.watchLogBookMonth!.id)
                    logMonth = fetchMonthResult.first!
                    if logMonth.watchLogBookDays!.isEmpty {
                        modelContext.delete(logMonth)
                        try? modelContext.save()

                        // check if year has zero entries --> can be deleted
                        let fetchYearResult = fetchLogBookYear(with: logMonth.watchLogBookYear!.id)
                        logYear = fetchYearResult.first!
                        if logYear.watchLogBookMonths!.isEmpty {
                            modelContext.delete(logYear)
                            try? modelContext.save()
                        }
                    }
                }
                try? modelContext.save()
            }
            return .success(())
        case let .failure(error):
            return .failure(error)
        }
        return .success(())
    }

    func fetchLogBookEntry(logEntryID: UUID) -> Result<[WatchLogBookEntry], Error> {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>(
            predicate: #Predicate { $0.id == logEntryID })
        do {
            let fetchedEntry = try modelContext.fetch(fetchDiscriptor)
            return .success(fetchedEntry)
        } catch {
            return .failure(error)
        }
    }

    func fetchYears() -> Result<[WatchLogBookYear], any Error> {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>()
        do {
            let fetchedYears = try modelContext.fetch(fetchDiscriptor)
            return .success(fetchedYears)
        } catch {
            return .failure(error)
        }
    }

    func fetchLogBook() -> Result<[WatchLogBook], Error> {
        let fetchDiscriptor = FetchDescriptor<WatchLogBook>()
        do {
            let fetchedLogBook = try modelContext.fetch(fetchDiscriptor)
            return .success(fetchedLogBook)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchLogBookDay(logDayID: UUID) -> Result<WatchLogBookDay?, Error> {
        var logDay: WatchLogBookDay?
        let fetchDiscriptor = FetchDescriptor<WatchLogBookDay>(
            predicate: #Predicate { $0.id == logDayID })
        do {
            logDay = try modelContext.fetch(fetchDiscriptor).first
        } catch {
            print("fetch WatchLogBookDay failed")
        }
        return .success(logDay)
    }

    func fetchEntries() -> Result<[WatchLogBookEntry], any Error> {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>()
        do {
            let fetchedEntries = try modelContext.fetch(fetchDiscriptor)
            return .success(fetchedEntries)
        } catch {
            return .failure(error)
        }
    }
    
    
    func fetchLogBookDayFromDate(from: Date) -> Result<WatchLogBookDay?, Error> {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        var DateComponent = Calendar.current.dateComponents(
            [.year, .month, .day, ], from: from)
        DateComponent.hour = 10
        DateComponent.minute = 0
        DateComponent.second = 0
        DateComponent.nanosecond = 0
        var FillerDate = Calendar.current.date(from: DateComponent)
//
//
//        var FillerDate = Calendar.current.date(from: DateComponent)
//        
//        var tempDateComponent = Calendar.current.dateComponents(
//            [.year, .month, .day, ], from: from)
//        tempDateComponent.hour = 23
//        tempDateComponent.minute = 59
//        tempDateComponent.second = 59
//        tempDateComponent.nanosecond = 59
//        let predecessorDate = Calendar.current.date(from: tempDateComponent)
//
//        tempDateComponent = Calendar.current.dateComponents(
//            [.year, .month, .day, ], from: from)
//        tempDateComponent.hour = 00
//        tempDateComponent.minute = 00
//        tempDateComponent.second = 00
//        tempDateComponent.nanosecond = 00
//        let successorDate = Calendar.current.date(from: tempDateComponent)
//        
        
        var logDayEntry: WatchLogBookDay?
//        let fetchDiscriptor = FetchDescriptor<WatchLogBookDay>(
//            predicate: #Predicate { $0.LogDate > predecessorDate! && $0.LogDate < successorDate! })
        let fetchDiscriptor = FetchDescriptor<WatchLogBookDay>(
            predicate: #Predicate { $0.logDate == FillerDate! })

        do {
            logDayEntry = try modelContext.fetch(fetchDiscriptor).first
        } catch {
            print("fetch WatchLogDay failed")
        }
        return .success(logDayEntry)
    }

    func fetchDaysFromLogBookEntry(logEntry: WatchLogBookEntry) -> Result<[WatchLogBookEntry], Error> {
        var daysLogEntries: [WatchLogBookEntry] = []

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        var DateComponent = DateComponents()
        DateComponent.year = 1975
        DateComponent.month = 8
        DateComponent.day = 2
        DateComponent.hour = 10
        DateComponent.minute = 0
        DateComponent.second = 0
        DateComponent.nanosecond = 0
        var FillerDate = Calendar.current.date(from: DateComponent)

        var logMonthEntry: WatchLogBookMonth?
        var logDayEntry: WatchLogBookDay?

        dateFormatter.string(from: Date())

        var tempDateComponent = DateComponents()
        tempDateComponent.year = Calendar.current.component(.year, from: logEntry.logDate) - 1
        tempDateComponent.month = 12
        tempDateComponent.day = 31
        tempDateComponent.hour = 23
        tempDateComponent.minute = 59
        tempDateComponent.second = 59
        tempDateComponent.nanosecond = 59
        let predecessorDate = Calendar.current.date(from: tempDateComponent)

        tempDateComponent.year = Calendar.current.component(.year, from: logEntry.logDate) + 1
        tempDateComponent.month = 01
        tempDateComponent.day = 01
        tempDateComponent.hour = 00
        tempDateComponent.minute = 00
        tempDateComponent.second = 00
        tempDateComponent.nanosecond = 00
        let successorDate = Calendar.current.date(from: tempDateComponent)

        DateComponent = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond], from: FillerDate!)
        DateComponent.year = Calendar.current.component(.year, from: logEntry.logDate)
        FillerDate = Calendar.current.date(from: DateComponent)

        var logYearEntry: WatchLogBookYear?
        let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>(
            predicate: #Predicate { $0.logDate > predecessorDate! && $0.logDate < successorDate! })

        do {
            logYearEntry = try modelContext.fetch(fetchDiscriptor).first
        } catch {
            print("fetch WatchLogBookYaer failed")
        }

        if logYearEntry != nil {
            let MonthFromDate = Calendar.current.component(.month, from: logEntry.logDate)
            DateComponent.month = MonthFromDate
            FillerDate = Calendar.current.date(from: DateComponent)

            if !logYearEntry!.watchLogBookMonths!.isEmpty {
                let filteredMonthArray = logYearEntry!.watchLogBookMonths!.filter {
                    Calendar.current.isDate($0.logDate, equalTo: FillerDate!, toGranularity: .month)
                }
                if !filteredMonthArray.isEmpty {
                    logMonthEntry = filteredMonthArray[0]
                }

                let DayFromDate = Calendar.current.component(.day, from: logEntry.logDate)
                DateComponent.day = DayFromDate
                FillerDate = Calendar.current.date(from: DateComponent)

                if logMonthEntry != nil && !logMonthEntry!.watchLogBookDays!.isEmpty {
                    let filteredDayArray = logMonthEntry!.watchLogBookDays!.filter {
                        Calendar.current.isDate($0.logDate, equalTo: FillerDate!, toGranularity: .day)
                    }

                    if !filteredDayArray.isEmpty {
                        logDayEntry = filteredDayArray[0]
                        daysLogEntries = logDayEntry!.logEntriesSorted
                    }
                }
            }
        }

        return .success(daysLogEntries)
    }

    func saveLogBookEntry(watchLogEntry: WatchLogEntry) -> Result<Void, Error> {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"

        var DateComponent = DateComponents()
        DateComponent.year = 1975
        DateComponent.month = 8
        DateComponent.day = 2
        DateComponent.hour = 10
        DateComponent.minute = 0
        DateComponent.second = 0
        DateComponent.nanosecond = 0
        var FillerDate = Calendar.current.date(from: DateComponent)

        var logMonthEntry: WatchLogBookMonth?
        var logDayEntry: WatchLogBookDay?

        let testdateFormatter = DateFormatter()
        testdateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.string(from: Date())

        let LogEntryUUID: UUID = watchLogEntry.id
        var logEntry: WatchLogBookEntry?
        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>(
            predicate: #Predicate { $0.id == LogEntryUUID })
        do {
            logEntry = try modelContext.fetch(fetchDiscriptor).first
        } catch {
            print("fetch WatchLogBookEntry failed")
        }

        if logEntry != nil {
            logEntry!.update(LogEntry: watchLogEntry)
            try? modelContext.save()
        } else {
            let entryTime = watchLogEntry.logDate
            // print(dateFormatter.string(from: entryTime))

            var DateComponent = DateComponents()
            DateComponent.year = Calendar.current.component(.year, from: entryTime) - 1
            DateComponent.month = 12
            DateComponent.day = 31
            DateComponent.hour = 23
            DateComponent.minute = 59
            DateComponent.second = 59
            DateComponent.nanosecond = 59
            let predecessorDate = Calendar.current.date(from: DateComponent)

            DateComponent.year = Calendar.current.component(.year, from: entryTime) + 1
            DateComponent.month = 01
            DateComponent.day = 01
            DateComponent.hour = 00
            DateComponent.minute = 00
            DateComponent.second = 00
            DateComponent.nanosecond = 00
            let successorDate = Calendar.current.date(from: DateComponent)

            DateComponent = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second, .nanosecond], from: FillerDate!)
            DateComponent.year = Calendar.current.component(.year, from: entryTime)
            FillerDate = Calendar.current.date(from: DateComponent)

            // muss noch raus in extra bei start der app als ersteinrichtung
            var logWatchBook: WatchLogBook?
            let fetchLogBookDiscriptor = FetchDescriptor<WatchLogBook>()

            do {
                logWatchBook = try modelContext.fetch(fetchLogBookDiscriptor).first
            } catch {
                print("fetch WatchLogBookYear failed")
            }

            if logWatchBook == nil {
                logWatchBook = WatchLogBook()
                modelContext.insert(logWatchBook!)
                try? modelContext.save()
            }

            var logYearEntry: WatchLogBookYear?
            let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>(
                predicate: #Predicate { $0.logDate > predecessorDate! && $0.logDate < successorDate! })

            do {
                logYearEntry = try modelContext.fetch(fetchDiscriptor).first
            } catch {
                print("fetch WatchLogBookYaer failed")
            }

            if logYearEntry == nil {
                logYearEntry = WatchLogBookYear(LogDate: FillerDate!, logBook: logWatchBook!)
                modelContext.insert(logYearEntry!)
                logWatchBook?.watchLogBookYears?.append(logYearEntry!)

                try? modelContext.save()
            }

            let MonthFromDate = Calendar.current.component(.month, from: entryTime)
            DateComponent.month = MonthFromDate
            FillerDate = Calendar.current.date(from: DateComponent)

            if logYearEntry!.watchLogBookMonths!.isEmpty {
                logMonthEntry = WatchLogBookMonth(LogDate: FillerDate!, year: logYearEntry!)
                modelContext.insert(logMonthEntry!)
                logYearEntry?.watchLogBookMonths?.append(logMonthEntry!)

                try? modelContext.save()
            } else {
                let filteredMonthArray = logYearEntry!.watchLogBookMonths!.filter {
                    Calendar.current.isDate($0.logDate, equalTo: FillerDate!, toGranularity: .month)
                }
                if filteredMonthArray.isEmpty {
                    logMonthEntry = WatchLogBookMonth(LogDate: FillerDate!, year: logYearEntry!)
                    modelContext.insert(logMonthEntry!)
                    logYearEntry?.watchLogBookMonths?.append(logMonthEntry!)

                    try? modelContext.save()
                } else {
                    logMonthEntry = filteredMonthArray[0]
                }
            }

            let DayFromDate = Calendar.current.component(.day, from: entryTime)
            DateComponent.day = DayFromDate
            FillerDate = Calendar.current.date(from: DateComponent)

            if logMonthEntry!.watchLogBookDays!.isEmpty {
                logDayEntry = WatchLogBookDay(LogDate: FillerDate!, month: logMonthEntry!)
                logMonthEntry?.watchLogBookDays?.append(logDayEntry!)
                modelContext.insert(logDayEntry!)
                try? modelContext.save()
            } else {
                let filteredDayArray = logMonthEntry!.watchLogBookDays!.filter {
                    Calendar.current.isDate($0.logDate, equalTo: FillerDate!, toGranularity: .day)
                }
                if filteredDayArray.isEmpty {
                    logDayEntry = WatchLogBookDay(LogDate: FillerDate!, month: logMonthEntry!)
                    logMonthEntry?.watchLogBookDays?.append(logDayEntry!)
                    try? modelContext.save()
                } else {
                    logDayEntry = filteredDayArray[0]
                }
            }

            let log = WatchLogBookEntry(LogEntry: watchLogEntry, day: logDayEntry!)

            modelContext.insert(log)
            // logDayEntry?.watchLogBookEntries?.append(log)
            logDayEntry?.addLogEntry(log)
            try? modelContext.save()
            //print(">>> Log saveving \(log.uuid)")
        }

        return .success(())
    }
}
