//
//  ViewModel.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//
import Combine
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
final class LogEntryViewModel: ObservableObject {
    @Published var watchLogEntry: WatchLogEntry = WatchLogEntry()
    @Published var errorMessage: String? = nil
    @Published var LogBookEntryYears: [WatchLogBookYear] = []
    @Published var LogBookEntries: [WatchLogBookEntry] = []
    @Published var WatchLogBooks: [WatchLogBook] = []

    private let databaseService: DatabaseServiceProtocol

    init(dataBaseService: DatabaseServiceProtocol) {
        databaseService = dataBaseService

        Task {
            await self.instanciateLogBook()
        }

        // generateLogBookEntry()
        generateAutomaticMockDatas()
    }

    func generateLogBookEntry() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"

        let entries = ["01.01.2023 15:10:10", "01.01.2023 19:10:10", "01.01.2023 20:10:10", "20.01.2023 16:10:10", "05.03.2023 03:10:10", "10.03.2023 06:10:10", "17.05.2023 08:11:10", "21.05.2023 02:10:10", "07.09.2023 13:10:12", "23.09.2023 20:10:10", "31.12.2023 22:10:10", "01.01.2024 06:10:10", "02.01.2024 16:10:10", "01.02.2024 04:10:10", "01.02.2024 15:10:10", "01.03.2024 18:10:10", "01.03.2024 13:10:10", "02.03.2024 11:10:10", "09.04.2024 06:10:10", "10.04.2024 03:10:10", "01.05.2024 14:10:10", "02.05.2024 19:10:10", "01.01.2025 06:10:10", "01.01.2025 08:10:10", "01.01.2025 10:10:10", "02.01.2025 16:10:10", "01.02.2025 04:10:10", "01.02.2025 15:10:10", "01.03.2025 18:10:10", "01.03.2025 13:10:10", "02.03.2025 11:10:10", "09.04.2025 06:10:10", "10.04.2025 03:10:10", "01.05.2025 14:10:10", "02.05.2025 19:10:10", "16.07.2025 10:10:10", "16.07.2025 14:10:10"]

        Task {
            for dat in entries {
                let entryObject = WatchLogEntry()
                entryObject.logDate = dateFormatter.date(from: dat)!
                entryObject.isLocked = true
                await saveLogEntry(LogEntry: entryObject)
            }
        }
    }

    func generateAutomaticMockDatas() {
        var logEntry: WatchLogEntry?

        var dateComponent = DateComponents()
        dateComponent.year = 1975
        dateComponent.month = 8
        dateComponent.day = 2
        dateComponent.hour = 10
        dateComponent.minute = 0
        dateComponent.second = 0
        dateComponent.nanosecond = 0
        var fillerDate = Calendar.current.date(from: dateComponent)

        Task {
            for year in 2023 ... 2025 {
                dateComponent.year = year
                for month in 1 ... 2 {
                    dateComponent.month = month
                    for day in 1 ... 3 {
                        dateComponent.day = day
                        for hour in 11 ... 12 {
                            dateComponent.hour = hour
                            for minute in 10 ... 12 {
                                dateComponent.minute = minute
                                for second in 10 ... 12 {
                                    dateComponent.second = second
                                    fillerDate = Calendar.current.date(from: dateComponent)
                                    logEntry = WatchLogEntry()
                                    logEntry!.logDate = fillerDate!
                                    logEntry!.isLocked = true
                                    await saveLogEntry(LogEntry: logEntry!)
                                    print("\(year)-\(month)-\(day) \(hour):\(minute):\(second)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // eintrag löschen und anzuzeigende UUID zurückgeben
    func calculateShownAndDeleteLogEntry(logEntryUUID: UUID, logEntryDayUUI: UUID) async -> LogEntryUUIDContainer {
        var toDisplayEntryUUID: UUID = UUID()
        var day: WatchLogBookDay?

        day = await fetchLogBookDay(day: logEntryDayUUI)

        if day != nil {
            if day!.watchLogBookEntries!.count > 2 {
                var index = day!.logEntriesSorted.firstIndex(where: { $0.id == logEntryUUID })
                index = index == 0 ? 1 : index! - 1
                toDisplayEntryUUID = day!.logEntriesSorted[index!].id
            } else {
                toDisplayEntryUUID = day!.watchLogBookEntries!.count == 1 ? day!.watchLogBookEntries![0].id : day!.logEntriesSorted[1].id
            }
            await deleteLogEntry(logEntryUUID: logEntryUUID)
        }
        return LogEntryUUIDContainer(logEntryUUID: toDisplayEntryUUID, logBookDay: day!)
    }

    func isDeletedEntryInDisplayedDay(logEntryUUID: UUID, logEntryDayUUI: UUID) async -> Bool {
        var day: WatchLogBookDay?

        day = await fetchLogBookDay(day: logEntryDayUUI)
        if day != nil {
            if day!.watchLogBookEntries!.contains(where: { $0.id == logEntryUUID }) {
                return true
            }
        }
        return false
    }

    func fetchLogBookDay(day: UUID) async -> WatchLogBookDay? {
        let result = await databaseService.fetchLogDay(from: day)
        switch result {
        case let .success(logBookDay):
            return logBookDay
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return nil
    }

    func instanciateLogBook() async {
        let result = await databaseService.instanciateLogBook()
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_instanciate_logBook", comment: "Displayed when build a instance of WatchLogBook fails"), error.localizedDescription)
        }
    }

    func fetchLogBookEntry(entryID: UUID) async -> WatchLogBookEntry? {
        let result = await databaseService.fetchLogBookEntryWithNil(with: entryID)
        switch result {
        case let .success(logBookEntry):
            return logBookEntry
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            return nil
        }
    }

    func fetchLogEntryMod(LogEntryUUID: UUID) async -> WatchLogEntry {
        let result = await databaseService.fetchLogBookEntry(with: LogEntryUUID)
        switch result {
        case let .success(logBookEntry):
            return logBookEntry
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            return WatchLogEntry()
        }
    }

    func isLogBookEntryExisting(from uuid: UUID) async -> Bool {
        let result = await databaseService.existsWatchLogBookEntry(uuid: uuid)
        switch result {
        case let .success(exsistLogEntry):
            return exsistLogEntry
        case let .failure(error):
            return false
        }
    }

    func fetchLogBookDay(from: Date) async -> WatchLogBookDay? {
        let result = await databaseService.fetchDayFromDate(from: from)
        switch result {
        case let .success(logBookDay):
            return logBookDay
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            return nil
        }
    }

    func deleteLogEntry(LogEntry: WatchLogEntry) async {
        let result = await databaseService.removeWatchLogBookEntry(logEntry: LogEntry)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }

    func deleteLogEntry(logEntryUUID: UUID) async {
        let result = await databaseService.removeWatchLogBookEntry(logEntryUUID: logEntryUUID)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }

    func deleteLogDay(watchLogBookDay: WatchLogBookDay) async {
        let result = await databaseService.removeWatchLogBookDay(watchLogBookDay: watchLogBookDay)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookDay", comment: "Displayed when saving logBookDay fails"), error.localizedDescription)
        }
    }

    func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) async {
        let result = await databaseService.removeWatchLogBookMonth(watchLogBookMonth: watchLogBookMonth)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookMonth", comment: "Displayed when saving logBookMonth fails"), error.localizedDescription)
        }
    }

    func deleteLogYear(watchLogBookYear: WatchLogBookYear) async {
        let result = await databaseService.removeWatchLogBookYear(watchLogBookYear: watchLogBookYear)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookYear", comment: "Displayed when saving logBookYear fails"), error.localizedDescription)
        }
    }

    func saveLogEntry(LogEntry: WatchLogEntry) async {
        let result = await databaseService.saveWatchLogBookEntry(LogEntry: LogEntry)
        switch result {
        case .success():
            errorMessage = ""
        // LogEntry.isNewEntryLog = false
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_saving_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }

    func fetchLogBook() async {
        let result = await databaseService.fetchLogBook()
        switch result {
        case let .success(logBook):
            WatchLogBooks = logBook
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetch_LogBook", comment: "Displayed when fetch Logbook fails"), error.localizedDescription)
        }
    }
}
