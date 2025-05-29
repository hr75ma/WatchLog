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
    
    
    private let databaseService: DatabaseServiceProtocol
    
    init(dataBaseService: DatabaseServiceProtocol) {
        self.databaseService = dataBaseService
    }
    
    func fetchLogEntry(LogEntryUUID: UUID)  {
        let result =  databaseService.fetchLogBookEntry(with: LogEntryUUID)
        switch result {
        case .success(let logBookEntry):
            self.watchLogEntry = logBookEntry
        case .failure(let error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
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
    
    func saveLogEntry(LogEntry: WatchLogEntry) async {
        let result = await databaseService.saveWatchLogBookEntry(LogEntry: LogEntry)
        switch result {
        case .success():
            errorMessage = ""
            self.watchLogEntry.isLocked = true
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
