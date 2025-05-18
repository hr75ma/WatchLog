////
////  DataBaseController.swift
////  WatchLog
////
////  Created by Marcus Hörning on 17.05.25.
////
//
import SwiftUI
import SwiftData

public class DataBaseController {
        
    let modelContext: ModelContext
    
    enum SaveLogEntryResult {
        case succes
        case failure(Error)
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
      }
    
    func saveLogEntry(LogEntry: WatchLogEntry) -> SaveLogEntryResult {
        
        var LogYearEntry: WatchLogBookYear?
        var LogMonthEntry: WatchLogBookMonth?
        var LogDayEntry: WatchLogBookDay?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var DateComponent = DateComponents()
        DateComponent.year = 1975
        DateComponent.month = 8
        DateComponent.year = 2
        DateComponent.hour = 1
        DateComponent.minute = 0
        DateComponent.second = 0
        
        var ListEntries: [WatchLogBookEntry] = []
        var ListYearEntries: [WatchLogBookYear] = []
        
        let LogEntryUUID:UUID = LogEntry.uuid
        
        
        let discriptor = FetchDescriptor<WatchLogBookEntry>(predicate: #Predicate{$0.uuid == LogEntryUUID})
        
        do {
            ListEntries = try modelContext.fetch(discriptor)
        } catch {
            print("failed")
        }
        
       //@Query(filter: #Predicate<WatchLogBookEntry> {$0.uuid == LogEntry.uuid}) var ListEntries: [WatchLogBookEntry]
        
        if ListEntries.isEmpty {
            
            
            let Date = LogEntry.EntryTime
            let YearFromDate = Calendar.current.component(.year, from: Date)
            
            let discriptor = FetchDescriptor<WatchLogBookYear>(predicate: #Predicate{$0.LogDate == YearFromDate})
            
            do {
                ListYearEntries = try modelContext.fetch(discriptor)
            } catch {
                print("failed")
            }
            
            
            //@Query(filter: #Predicate<WatchLogBookYear> {Calendar.current.component(.year, from: $0.LogDate) == Calendar.current.component(.year, from: Date)}) var ListYearEntries: [WatchLogBookYear]
            
            if ListYearEntries.isEmpty {
                
                DateComponent.year = Calendar.current.component(.year, from: Date)
                LogYearEntry = WatchLogBookYear(LogDate: YearFromDate)
                modelContext.insert(LogYearEntry!)
                try? modelContext.save()
            } else {
                LogYearEntry = ListYearEntries[0]
            }
            
            let MonthFromDate = Calendar.current.component(.month, from: Date)
            if LogYearEntry?.Children == nil || (LogYearEntry?.Children!.isEmpty)! {
                
                LogMonthEntry = WatchLogBookMonth(LogDate: MonthFromDate)
                modelContext.insert(LogMonthEntry!)
                try? modelContext.save()
                LogYearEntry?.Children = [LogMonthEntry!]
                try? modelContext.save()
            } else {
                var filteredMonthArray = LogYearEntry!.Children!.filter { $0.LogDate == MonthFromDate }
                if filteredMonthArray.isEmpty {
                    LogMonthEntry = WatchLogBookMonth(LogDate: MonthFromDate)
                    modelContext.insert(LogMonthEntry!)
                    try? modelContext.save()
                    LogYearEntry?.Children?.append(LogMonthEntry!)
                    try? modelContext.save()
                } else {
                    LogMonthEntry = filteredMonthArray[0]
                }
            }
            
            let DayFromDate = Calendar.current.component(.day, from: Date)
            if LogMonthEntry?.Children == nil || (LogMonthEntry?.Children!.isEmpty)! {
                
                LogDayEntry = WatchLogBookDay(LogDate: DayFromDate)
                LogMonthEntry?.Children = [LogDayEntry!]
                modelContext.insert(LogDayEntry!)
                try? modelContext.save()
                LogMonthEntry?.Children = [LogDayEntry!]
            } else {
                var filteredDayArray = LogMonthEntry!.Children!.filter { $0.LogDate == DayFromDate }
                if filteredDayArray.isEmpty {
                    LogDayEntry = WatchLogBookDay(LogDate: DayFromDate)
                    modelContext.insert(LogDayEntry!)
                    try? modelContext.save()
                    LogMonthEntry?.Children?.append(LogDayEntry!)
                } else {
                    LogDayEntry = filteredDayArray[0]
                }
            }
            
//            if LogDayEntry?.WatchLogBookEntry == nil {
//                LogDayEntry?.WatchLogBookEntry = []
//            }
//
            let Log = WatchLogBookEntry(LogEntry: LogEntry)
            modelContext.insert(Log)
            try? modelContext.save()
            LogDayEntry?.Children?.append(Log)
            try? modelContext.save()
        } else {
            ListEntries[0].update(LogEntry: LogEntry)
            try? modelContext.save()
        }
        
        return SaveLogEntryResult.succes
    }
    
}
