//
//  ViewModel.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//
import Combine
import SwiftUI


@MainActor
final class LogEntryViewModel: LogEntryViewModelProtocol, ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var WatchLogBooks: [WatchLogBook] = []
    @Published var nonClosedEventContainer: NonClosedEventContainer = .init()

    private let databaseService: DatabaseServiceProtocol

    init(dataBaseService: DatabaseServiceProtocol) {
        databaseService = dataBaseService

        Task {
//            await self.instanciateLogBook()
           let isNewLogBook = await self.instanciateLogBook()
            if isNewLogBook {
                generateLogBookEntry()
            }
            
            await initialSetOfNonClosedLogBookEntries()
        }

        //generateLogBookEntry()
        //generateAutomaticMockDatas()
    }

    func generateLogBookEntry() -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"

        let entries = ["01.01.2023 15:10:10", "01.01.2023 19:10:10", "01.01.2023 20:10:10", "20.01.2023 16:10:10", "05.03.2023 03:10:10", "10.03.2023 06:10:10", "10.03.2023 08:10:10", "10.03.2023 10:10:10", "10.03.2023 12:10:10", "17.05.2023 08:11:10", "21.05.2023 02:10:10", "07.09.2023 13:10:12", "23.09.2023 20:10:10", "31.12.2023 22:10:10", "01.01.2024 06:10:10", "02.01.2024 16:10:10", "01.02.2024 04:10:10", "01.02.2024 15:10:10", "01.03.2024 18:10:10", "01.03.2024 13:10:10", "02.03.2024 11:10:10", "09.04.2024 06:10:10", "10.04.2024 03:10:10", "01.05.2024 14:10:10", "02.05.2024 19:10:10", "01.01.2025 06:10:10", "01.01.2025 08:10:10", "01.01.2025 10:10:10", "02.01.2025 16:10:10", "01.02.2025 04:10:10", "01.02.2025 15:10:10", "01.03.2025 18:10:10", "01.03.2025 13:10:10", "02.03.2025 11:10:10", "09.04.2025 06:10:10", "10.04.2025 03:10:10", "01.05.2025 14:10:10", "02.05.2025 19:10:10", "16.07.2025 10:10:10", "16.07.2025 14:10:10", "25.07.2025 08:10:10", "01.01.2026 10:10:10", "02.01.2026 16:10:10"]

        Task {
            for dat in entries {
                let entryObject = WatchLogEntry()
                entryObject.logDate = dateFormatter.date(from: dat)!
                entryObject.isLocked = true
                await saveLogEntry(watchLogEntry: entryObject)
            }
        }
    }

    func generateAutomaticMockDatas() -> Void {
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
            for year in 2025 ... 2025 {
                dateComponent.year = year
                for month in 1 ... 1 {
                    dateComponent.month = month
                    for day in 1 ... 2{
                        dateComponent.day = day
                        for hour in 11 ... 12 {
                            dateComponent.hour = hour
                            for minute in 10 ... 11 {
                                dateComponent.minute = minute
                                for second in 10 ... 11 {
                                    dateComponent.second = second
                                    fillerDate = Calendar.current.date(from: dateComponent)
                                    logEntry = WatchLogEntry()
                                    logEntry!.logDate = fillerDate!
                                    logEntry!.isLocked = true
                                    await saveLogEntry(watchLogEntry: logEntry!)
                                    print("\(year)-\(month)-\(day) \(hour):\(minute):\(second)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func updateNonClosedEventContainer(isWatchLogBookEntryEventClosed: Bool, watchLogEntryID: UUID) {
        if isWatchLogBookEntryEventClosed {
            nonClosedEventContainer.nonClosedEvents.remove(watchLogEntryID)
            
        } else {
            nonClosedEventContainer.nonClosedEvents.insert(watchLogEntryID)
        }
    }
    
    public func initialSetOfNonClosedLogBookEntries() async -> Void {
        let result = await databaseService.fetchNonClosedLogEntries()
        switch result {
        case let .success(nonClosedLogBookEntry):
            nonClosedEventContainer.nonClosedEvents = nonClosedLogBookEntry
            print("nonClosedEventContainer \(nonClosedEventContainer.nonClosedEvents.count)")
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
    }
    
    public func delete<T>(deleteType: DeleteTypes, toDeleteItem: T, displayedUUID: UUID, logEntryUUIDContainer: LogEntryUUIDContainer)  async -> LogEntryUUIDContainer {
        var tempContainer = logEntryUUIDContainer
        
        Task {
            switch deleteType {
            case .day:
                await self.deleteLogDay(watchLogBookDay: toDeleteItem as! WatchLogBookDay)
            case .month:
                
                await self.deleteLogMonth(watchLogBookMonth: toDeleteItem as! WatchLogBookMonth)
                
            case .year:
                
                await self.deleteLogYear(watchLogBookYear: toDeleteItem as! WatchLogBookYear)
                
            default:
                break
            }
            tempContainer = await testOnDeleteDisplayedEntry(displayedUUID: displayedUUID, logEntryUUIDContainer: logEntryUUIDContainer)
            await self.initialSetOfNonClosedLogBookEntries()
        }
        return tempContainer
    }
    
    private func testOnDeleteDisplayedEntry(displayedUUID: UUID, logEntryUUIDContainer: LogEntryUUIDContainer) async -> LogEntryUUIDContainer {
        
            let isExisting = await self.isLogBookEntryExisting(logEntryID: displayedUUID)
            if !isExisting {
                // manageWhatIsShowing()
                return .init(logEntryUUID: UUID(), logBookDay: WatchLogBookDay())
            }
            return logEntryUUIDContainer
    }
    
    

    // eintrag löschen und anzuzeigende UUID zurückgeben
    func calculateShownAndDeleteLogEntry(logEntryID: UUID, logDayID: UUID) async -> LogEntryUUIDContainer {
        var toDisplayEntryUUID: UUID = UUID()
        var day: WatchLogBookDay?

        day = await fetchLogBookDay(logDayID: logDayID)

        if day != nil {
            if day!.watchLogBookEntries!.count > 2 {
                var index = day!.logEntriesSorted.firstIndex(where: { $0.id == logEntryID })
                index = index == 0 ? 1 : index! - 1
                toDisplayEntryUUID = day!.logEntriesSorted[index!].id
            } else {
                toDisplayEntryUUID = day!.watchLogBookEntries!.count == 1 ? day!.watchLogBookEntries![0].id : day!.logEntriesSorted[1].id
            }
            await deleteLogEntry(logEntryID: logEntryID)
        }
        return LogEntryUUIDContainer(logEntryUUID: toDisplayEntryUUID, logBookDay: day!)
    }

    func isDeletedEntryInDisplayedDay(logEntryID: UUID, logDayID: UUID) async -> Bool {
        var day: WatchLogBookDay?

        day = await fetchLogBookDay(logDayID: logDayID)
        if day != nil {
            if day!.watchLogBookEntries!.contains(where: { $0.id == logEntryID }) {
                return true
            }
        }
        return false
    }

    func fetchLogBookDay(logDayID: UUID) async -> WatchLogBookDay? {
        let result = await databaseService.fetchLogDay(logDayID: logDayID)
        switch result {
        case let .success(logBookDay):
            return logBookDay
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
        }
        return nil
    }

    func instanciateLogBook() async -> Bool {
        let result = await databaseService.instanciateLogBook()
        switch result {
        case let .success(isNewLogBook):
            return isNewLogBook
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_instanciate_logBook", comment: "Displayed when build a instance of WatchLogBook fails"), error.localizedDescription)
        }
        return false
    }
    
    func deleteLogBook() async -> Void {
        await databaseService.deleteLogBook()
    }

    func fetchLogBookEntry(logEntryID: UUID) async -> WatchLogBookEntry? {
        let result = await databaseService.fetchLogBookEntry(logEntryID: logEntryID)
        switch result {
        case let .success(logBookEntry):
            return logBookEntry
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
            return nil
        }
    }

    func fetchLogEntryMod(logEntryID: UUID) async -> WatchLogEntry {
        var watchLogEntry: WatchLogEntry = WatchLogEntry(uudi: logEntryID)
        let result = await databaseService.fetchLogBookEntry(logEntryID: logEntryID)
        
        switch result {
            case let .success(entry):
            if entry != nil {
                watchLogEntry = .init(watchLookBookEntry: entry!)
             }
                return watchLogEntry
            case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetching_logBookEntry", comment: "Displayed when fetching logBookEntry fails"), error.localizedDescription)
                        
                return WatchLogEntry()
        }
    }
    
    
    
    
    
    
    
    
    
    
    

    func isLogBookEntryExisting(logEntryID uuid: UUID) async -> Bool {
        let result = await databaseService.existsWatchLogBookEntry(logEntryID: uuid)
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

    func deleteLogEntry(logEntryID: UUID) async -> Void {
        let result = await databaseService.removeWatchLogBookEntry(logEntryID: logEntryID)
        switch result {
        case .success():
            errorMessage = ""
            updateNonClosedEventContainer(isWatchLogBookEntryEventClosed: true, watchLogEntryID: logEntryID)
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }

    func deleteLogDay(watchLogBookDay: WatchLogBookDay) async -> Void {
        let result = await databaseService.removeWatchLogBookDay(logDayID: watchLogBookDay.id)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookDay", comment: "Displayed when saving logBookDay fails"), error.localizedDescription)
        }
    }

    func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) async -> Void {
        let result = await databaseService.removeWatchLogBookMonth(logMonthID: watchLogBookMonth.id)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookMonth", comment: "Displayed when saving logBookMonth fails"), error.localizedDescription)
        }
    }

    func deleteLogYear(watchLogBookYear: WatchLogBookYear) async -> Void {
        let result = await databaseService.removeWatchLogBookYear(logYearID: watchLogBookYear.id)
        switch result {
        case .success():
            errorMessage = ""

        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_delete_logBookYear", comment: "Displayed when saving logBookYear fails"), error.localizedDescription)
        }
    }

    func saveLogEntry(watchLogEntry: WatchLogEntry) async -> Void {
        let result = await databaseService.saveWatchLogBookEntry(watchLogEntry: watchLogEntry)
        switch result {
        case .success():
            errorMessage = ""
            updateNonClosedEventContainer(isWatchLogBookEntryEventClosed: watchLogEntry.isClosed, watchLogEntryID: watchLogEntry.id)
        // LogEntry.isNewEntryLog = false
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_saving_logBookEntry", comment: "Displayed when saving logBookEntry fails"), error.localizedDescription)
        }
    }

    func fetchLogBook() async -> Void {
        let result = await databaseService.fetchLogBook()
        switch result {
        case let .success(logBook):
            WatchLogBooks = logBook
        case let .failure(error):
            errorMessage = String(format: NSLocalizedString("error_fetch_LogBook", comment: "Displayed when fetch Logbook fails"), error.localizedDescription)
        }
    }
}
