//
//  DataBaseManager.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.05.25.
//

import SwiftUI
import SwiftData

protocol DataBaseManagerProtocol {
    
    func saveLogBookEntry(LogEntry: WatchLogEntry) -> Result<Void, Error>
    func fetchLogBookEntry(with EntryUUID: UUID) -> Result<[WatchLogBookEntry], Error>
    func fetchYears() -> Result<[WatchLogBookYear], Error>
    func fetchEntries() -> Result<[WatchLogBookEntry], Error>
    func removeLogBookEntry(with EntryUUID: UUID)  -> Result<Void, Error>
}
extension DataBaseManager: DataBaseManagerProtocol { }

enum DataBaseError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
}

final class DataBaseManager {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = DataBaseManager()
    
        @MainActor
        private init() {
            do {
                self.modelContainer = try ModelContainer(for: WatchLogBookYear.self)
                self.modelContext = modelContainer.mainContext
            } catch {
                fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
            }
        }
    
    
    private func fetchLogBookYear(with EntryUUID: UUID) -> [WatchLogBookYear] {
  
      let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>(
        predicate: #Predicate{ $0.uuid == EntryUUID })
      do {
        let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
        return fetchedEntries!
      }
    }
  
    private func fetchLogBookMonth(with EntryUUID: UUID) -> [WatchLogBookMonth] {
  
      let fetchDiscriptor = FetchDescriptor<WatchLogBookMonth>(
        predicate: #Predicate{ $0.uuid == EntryUUID })
      do {
        let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
        return fetchedEntries!
      }
    }
  
    private func fetchLogBookDay(with EntryUUID: UUID) -> [WatchLogBookDay] {
  
      let fetchDiscriptor = FetchDescriptor<WatchLogBookDay>(
        predicate: #Predicate{ $0.uuid == EntryUUID })
      do {
        let fetchedEntries = try? modelContext.fetch(fetchDiscriptor)
        return fetchedEntries!
      }
    }
    
    
    func removeLogBookEntry(with EntryUUID: UUID) -> Result<Void, Error> {

      var logEntry = WatchLogBookEntry()
      var logDay = WatchLogBookDay()
      var logMonth = WatchLogBookMonth()
      var logYear = WatchLogBookYear()

      let fetchResult = fetchLogBookEntry(with: EntryUUID)
      switch fetchResult {
      case .success(let entry):
        if !entry.isEmpty {
  
          logEntry = entry.first!
  
          //day of logentry
          let fetchDayResult = fetchLogBookDay(with: logEntry.ParentUUID!)
          logDay = fetchDayResult.first!
          logDay.LogEntries!.removeAll {
              
              print("-------------------------->\($0.uuid)")
              print("-------------------------->\(logEntry.uuid)")
              
              return $0.uuid == logEntry.uuid }
  
          //remove entry
          modelContext.delete(logEntry)
            try? modelContext.save()
  
          //check if day has zero entries --> can be deleted
          if logDay.LogEntries!.isEmpty {
  
            let fetchMonthResult = fetchLogBookMonth(with: logDay.ParentUUID!)
            logMonth = fetchMonthResult.first!
            logMonth.Days!.removeAll {
                
                print("-------------------------->\($0.uuid)")
                print("-------------------------->\(logDay.uuid)")
                
                return $0.uuid == logDay.uuid }
  
            //delete empty day
            modelContext.delete(logDay)
              try? modelContext.save()
  
            //check if month has zero entries --> can be deleted
            if logMonth.Days!.isEmpty {
  
              let fetchYearResult = fetchLogBookYear(with: logMonth.ParentUUID!)
              logYear = fetchYearResult.first!
                logYear.Months!.removeAll {
                    
                    print("-------------------------->\($0.uuid)")
                    print("-------------------------->\(logMonth.uuid)")
                    
                   return $0.uuid == logMonth.uuid }
  
              //delete empty month
              modelContext.delete(logMonth)
                try? modelContext.save()
  
              //check if year has zero entries --> can be deleted
              if logYear.Months!.isEmpty {
                modelContext.delete(logYear)
              }
  
            }
  
          }
          try? modelContext.save()
        }
        return .success(())
      case .failure(let error):
        return .failure(error)
      }
        return .success(())
    }
    
    
    func fetchLogBookEntry(with EntryUUID: UUID) -> Result<[WatchLogBookEntry], Error> {

        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>(predicate: #Predicate{$0.uuid == EntryUUID})
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
    
    func fetchEntries() -> Result<[WatchLogBookEntry], any Error> {
        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>()
        do {
            let fetchedEntries = try modelContext.fetch(fetchDiscriptor)
            return .success(fetchedEntries)
        } catch {
            return .failure(error)
        }
    }
    
    
    
    func saveLogBookEntry(LogEntry: WatchLogEntry) -> Result <Void, Error> {
        
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
        
        
        
        
        let LogEntryUUID:UUID = LogEntry.uuid
        var logEntry: WatchLogBookEntry?
        let fetchDiscriptor = FetchDescriptor<WatchLogBookEntry>(predicate: #Predicate{$0.uuid == LogEntryUUID})
        do {
            logEntry = try modelContext.fetch(fetchDiscriptor).first
        } catch {
            print("fetch WatchLogBookEntry failed")
        }
        
        if logEntry != nil {
            logEntry!.update(LogEntry: LogEntry)
            try? modelContext.save()
        } else
        {
            let entryTime = LogEntry.EntryTime
            
            var DateComponent = DateComponents()
            DateComponent.year = Calendar.current.component(.year, from: entryTime)-1
            DateComponent.month = 12
            DateComponent.day = 31
            DateComponent.hour = 23
            DateComponent.minute = 59
            DateComponent.second = 59
            DateComponent.nanosecond = 59
            let predecessorDate = Calendar.current.date(from: DateComponent)
                                  
            DateComponent.year = Calendar.current.component(.year, from: entryTime)+1
            DateComponent.month = 01
            DateComponent.day = 01
            DateComponent.hour = 00
            DateComponent.minute = 00
            DateComponent.second = 00
            DateComponent.nanosecond = 00
            let successorDate = Calendar.current.date(from: DateComponent)
                                  
            
            
            DateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: FillerDate!)
            DateComponent.year = Calendar.current.component(.year, from: entryTime)
            FillerDate = Calendar.current.date(from: DateComponent)
            

            var logYearEntry: WatchLogBookYear?
            let fetchDiscriptor = FetchDescriptor<WatchLogBookYear>(predicate: #Predicate{$0.LogDate > predecessorDate! && $0.LogDate < successorDate!})
            
            do {
                logYearEntry = try modelContext.fetch(fetchDiscriptor).first
            } catch {
                print("fetch WatchLogBookYaer failed")
            }
            
            
            if logYearEntry == nil {
                logYearEntry = WatchLogBookYear(LogDate: FillerDate!)
                modelContext.insert(logYearEntry!)
                try? modelContext.save()
            }
            
            
            
            
            
            let MonthFromDate = Calendar.current.component(.month, from: entryTime)
            DateComponent.month = MonthFromDate
            FillerDate = Calendar.current.date(from: DateComponent)
            
            
            if logYearEntry!.Months!.isEmpty {
                
                logMonthEntry = WatchLogBookMonth(LogDate: FillerDate!)
                logMonthEntry!.ParentUUID = logYearEntry!.uuid
                modelContext.insert(logMonthEntry!)
                logYearEntry!.Months = [logMonthEntry!]
                try? modelContext.save()
            } else {
                let filteredMonthArray = logYearEntry!.Months!.filter { Calendar.current.isDate($0.LogDate, equalTo: FillerDate!, toGranularity: .month) }
                if filteredMonthArray.isEmpty {
                    logMonthEntry = WatchLogBookMonth(LogDate: FillerDate!)
                    modelContext.insert(logMonthEntry!)
                    logYearEntry!.Months!.append(logMonthEntry!)
                    try? modelContext.save()
                } else {
                    logMonthEntry = filteredMonthArray[0]
                }
                    
            }
            
            
            let DayFromDate = Calendar.current.component(.day, from: entryTime)
            DateComponent.day = DayFromDate
            FillerDate = Calendar.current.date(from: DateComponent)
            
            
            
            
            
            if logMonthEntry!.Days!.isEmpty {
                
                logDayEntry = WatchLogBookDay(LogDate: FillerDate!)
                logDayEntry!.ParentUUID = logMonthEntry!.uuid
                modelContext.insert(logDayEntry!)
                logMonthEntry!.Days = [logDayEntry!]
                try? modelContext.save()
            } else {
                let filteredDayArray = logMonthEntry!.Days!.filter { Calendar.current.isDate($0.LogDate, equalTo: FillerDate!, toGranularity: .day) }
                if filteredDayArray.isEmpty {
                    logDayEntry = WatchLogBookDay(LogDate: FillerDate!)
                    logMonthEntry!.Days!.append(logDayEntry!)
                    try? modelContext.save()
                } else {
                    logDayEntry = filteredDayArray[0]
                }
            }
            
            let log = WatchLogBookEntry(LogEntry: LogEntry)
            log.ParentUUID = logDayEntry!.uuid
            modelContext.insert(log)
            logDayEntry!.LogEntries!.append(log)
            try? modelContext.save()
        }
        
        return .success(())
    }
    
    
    
}
