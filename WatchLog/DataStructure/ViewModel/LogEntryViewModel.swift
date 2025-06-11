//
//  ViewModel.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//
import SwiftUI
import Combine

@MainActor
class LogEntryViewModel: ObservableObject {
    
    @Published var watchLogEntry: WatchLogEntry = WatchLogEntry()
    @Published var errorMessage: String? = nil
    @Published var LogBookEntryYears: [WatchLogBookYear] = []
    @Published var LogBookEntries: [WatchLogBookEntry] = []
    @Published var WatchLogBooks: [WatchLogBook] = []
    
    
    private let databaseService: DatabaseServiceProtocol
    
    init(dataBaseService: DatabaseServiceProtocol) {
        self.databaseService = dataBaseService
        
        Task {
            await self.instanciateLogBook()
        }
        
        generateLogBookEntry()
    }
    
    
    func generateLogBookEntry () {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let entries = ["01.01.2023 06:10:10", "20.01.2023 16:10:10","05.03.2023 03:10:10","10.03.2023 06:10:10","17.05.2023 08:11:10","21.05.2023 02:10:10","07.09.2023 13:10:12","23.09.2023 20:10:10","31.12.2023 22:10:10","01.01.2024 06:10:10", "02.01.2024 16:10:10", "01.02.2024 04:10:10", "01.02.2024 15:10:10", "01.03.2024 18:10:10", "01.03.2024 13:10:10", "02.03.2024 11:10:10", "09.04.2024 06:10:10", "10.04.2024 03:10:10", "01.05.2024 14:10:10", "02.05.2024 19:10:10","01.01.2025 06:10:10", "02.01.2025 16:10:10", "01.02.2025 04:10:10", "01.02.2025 15:10:10", "01.03.2025 18:10:10", "01.03.2025 13:10:10", "02.03.2025 11:10:10", "09.04.2025 06:10:10", "10.04.2025 03:10:10", "01.05.2025 14:10:10", "02.05.2025 19:10:10"]
        
        Task {
            
            for dat in entries {
                
                let entryObject = WatchLogEntry()
                entryObject.EntryTime = dateFormatter.date(from: dat)!
                entryObject.isLocked = true
                await saveLogEntry(LogEntry: entryObject)
                
            }
        }

        
        
    }
    
    
    func instanciateLogBook() async {
        let result = await databaseService.instanciateLogBook()
        switch result {
        case .success():
            errorMessage = ""
            
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_instanciate_logBook", comment: "Displayed when build a instance of WatchLogBook fails"), error.localizedDescription)
        }
    }
    
    
    func fetchDaysOfLogEntry(logEntry: WatchLogBookEntry)  async -> [WatchLogBookEntry] {
        let result =  await databaseService.fetchDaysFromLogBookEntry(logEntry: logEntry)
        switch result {
        case .success(let logBookEntries):
            return logBookEntries
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return []
        
    }
    
    
    func fetchLogEntry(LogEntryUUID: UUID)  async {
        let result =  await databaseService.fetchLogBookEntry(with: LogEntryUUID)
        switch result {
        case .success(let logBookEntry):
            self.watchLogEntry = logBookEntry
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        
    }
    
    func exisitsLogEntry(uuid: UUID) async -> Bool {
        let result = await databaseService.existsWatchLogBookEntry(uuid: uuid)
        switch result {
        case .success(let exisistLogLEntry):
            return exisistLogLEntry
        case .failure(let error):
            return false
        }
        
    }
    
    func deleteLogEntry(LogEntry: WatchLogEntry) async {
        let result = await databaseService.removeWatchLogBookEntry(LogEntry: LogEntry)
        switch result {
        case .success():
            errorMessage = ""
            
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }
    
    func deleteLogDay(watchLogBookDay: WatchLogBookDay) async {
        let result = await databaseService.removeWatchLogBookDay(watchLogBookDay: watchLogBookDay)
        switch result {
        case .success():
            errorMessage = ""
            
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookDay", comment: "Displayed when saving logBookDay fails"), error.localizedDescription)
        }
    }
    
    func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) async {
        let result = await databaseService.removeWatchLogBookMonth(watchLogBookMonth: watchLogBookMonth)
        switch result {
        case .success():
            errorMessage = ""
            
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookMonth", comment: "Displayed when saving logBookMonth fails"), error.localizedDescription)
        }
    }
    
    func deleteLogYear(watchLogBookYear: WatchLogBookYear) async {
        let result = await databaseService.removeWatchLogBookYear(watchLogBookYear: watchLogBookYear)
        switch result {
        case .success():
            errorMessage = ""
            
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookYear", comment: "Displayed when saving logBookYear fails"), error.localizedDescription)
        }
    }
    
    func saveLogEntry(LogEntry: WatchLogEntry) async {
        let result = await databaseService.saveWatchLogBookEntry(LogEntry: LogEntry)
        switch result {
        case .success():
            errorMessage = ""
            case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_saving_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }
    
    func fetchLogBookYear() async {
        let result = await databaseService.fetchLogBookYears()
        switch result {
        case .success(let logBookYear):
            self.LogBookEntryYears = logBookYear
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetch_LogBookYear", comment: "Displayed when fetch LogbookYear fails"), error.localizedDescription)
        }
    }
    
    func fetchLogBook() async {
        let result = await databaseService.fetchLogBook()
        switch result {
        case .success(let logBook):
            self.WatchLogBooks = logBook
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetch_LogBook", comment: "Displayed when fetch Logbook fails"), error.localizedDescription)
        }
    }
    
    func fetchLogBookEntries() async {
        let result = await databaseService.fetchLogBookEntries()
        switch result {
        case .success(let logBookEntries):
            self.LogBookEntries = logBookEntries
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetch_LogBookYear", comment: "Displayed when fetch LogbookYear fails"), error.localizedDescription)
        }
    }
    
    
    
}
