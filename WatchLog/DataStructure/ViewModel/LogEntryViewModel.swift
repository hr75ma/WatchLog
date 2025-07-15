//
//  ViewModel.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//
import Combine
import SwiftUI

enum DeleteTypes: CaseIterable, Codable {
    case logEntry
    case day
    case month
    case year

    static let deleteType: DeleteTypes = .logEntry
}

@MainActor
final class LogEntryViewModel: ObservableObject {
    @Published var watchLogEntry: WatchLogEntry = WatchLogEntry()
    @Published var errorMessage: String? = nil
    @Published var LogBookEntryYears: [WatchLogBookYear] = []
    @Published var LogBookEntries: [WatchLogBookEntry] = []
    @Published var WatchLogBooks: [WatchLogBook] = []
    @Published var remoteSignalContainer: RemoteContainerLogEntryViewModel = RemoteContainerLogEntryViewModel()
    
    private let databaseService: DatabaseServiceProtocol
    
    init(dataBaseService: DatabaseServiceProtocol) {
        databaseService = dataBaseService
        remoteSignalContainer = RemoteContainerLogEntryViewModel()
        
        Task {
            await self.instanciateLogBook()
        }
        
        generateLogBookEntry()
    }
    
    func generateLogBookEntry() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let entries = ["01.01.2023 06:10:10", "20.01.2023 16:10:10", "05.03.2023 03:10:10", "10.03.2023 06:10:10", "17.05.2023 08:11:10", "21.05.2023 02:10:10", "07.09.2023 13:10:12", "23.09.2023 20:10:10", "31.12.2023 22:10:10", "01.01.2024 06:10:10", "02.01.2024 16:10:10", "01.02.2024 04:10:10", "01.02.2024 15:10:10", "01.03.2024 18:10:10", "01.03.2024 13:10:10", "02.03.2024 11:10:10", "09.04.2024 06:10:10", "10.04.2024 03:10:10", "01.05.2024 14:10:10", "02.05.2024 19:10:10", "01.01.2025 06:10:10", "01.01.2025 08:10:10", "01.01.2025 10:10:10", "02.01.2025 16:10:10", "01.02.2025 04:10:10", "01.02.2025 15:10:10", "01.03.2025 18:10:10", "01.03.2025 13:10:10", "02.03.2025 11:10:10", "09.04.2025 06:10:10", "10.04.2025 03:10:10", "01.05.2025 14:10:10", "02.05.2025 19:10:10", "13.07.2025 10:10:10", "13.07.2025 14:10:10"]
        
        // let entries = ["01.01.2023 06:10:10", "20.01.2023 16:10:10", "20.01.2023 18:10:10"]
        
        Task {
            for dat in entries {
                let entryObject = WatchLogEntry()
                entryObject.EntryTime = dateFormatter.date(from: dat)!
                entryObject.isLocked = true
                await saveLogEntry(LogEntry: entryObject)
            }
        }
    }
    
    func fetchLogEntriesFromDay(from: UUID) async -> [WatchLogBookEntry] {
        let result = await databaseService.fetchLogEntriesFromDay(from: from)
        switch result {
        case let .success(logBookEntries):
            return logBookEntries
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return []
    }
    
    func fetchLogEntryDay(from: UUID) async -> WatchLogBookDay? {
        let result = await databaseService.fetchLogDay(from: from)
        switch result {
        case let .success(logBookDay):
            return logBookDay
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return nil
    }
    
    func fetchLogEntryDayMod(from: UUID) async -> WatchLogBookDay {
        let result = await databaseService.fetchLogDay(from: from)
        switch result {
        case let .success(logBookDay):
             if logBookDay == nil
                    { return WatchLogBookDay()}
            else { return logBookDay! }
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return WatchLogBookDay()
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
        
        func fetchDaysOfLogEntry(logEntry: WatchLogBookEntry) async -> [WatchLogBookEntry] {
            let result = await databaseService.fetchDaysFromLogBookEntry(logEntry: logEntry)
            switch result {
            case let .success(logBookEntries):
                return logBookEntries
            case let .failure(error):
                errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            }
            return []
        }
        
//        func fetchLogEntry(LogEntryUUID: UUID) async {
//            let result = await databaseService.fetchLogBookEntry(with: LogEntryUUID)
//            switch result {
//            case let .success(logBookEntry):
//                watchLogEntry = logBookEntry
//            case let .failure(error):
//                errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
//            }
//        }
        
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
    
    func fetchLogBookDayOrEmptyDay(from: Date) async -> WatchLogBookDay? {
        let result = await databaseService.fetchDayFromDate(from: from)
        switch result {
        case let .success(logBookDay):
            if logBookDay != nil {
                return logBookDay
            } else {
                return WatchLogBookDay()
            }
            
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            return nil
        }
    }
        
        
        func deleteLogEntry(LogEntry: WatchLogEntry) async {
            let result = await databaseService.removeWatchLogBookEntry(LogEntry: LogEntry)
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
        
        func fetchLogBookYear() async {
            let result = await databaseService.fetchLogBookYears()
            switch result {
            case let .success(logBookYear):
                LogBookEntryYears = logBookYear
            case let .failure(error):
                errorMessage = String(format: NSLocalizedString("error_fetch_LogBookYear", comment: "Displayed when fetch LogbookYear fails"), error.localizedDescription)
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
        
        func fetchLogBookEntries() async {
            let result = await databaseService.fetchLogBookEntries()
            switch result {
            case let .success(logBookEntries):
                LogBookEntries = logBookEntries
            case let .failure(error):
                errorMessage = String(format: NSLocalizedString("error_fetch_LogBookYear", comment: "Displayed when fetch LogbookYear fails"), error.localizedDescription)
            }
        }
    }

