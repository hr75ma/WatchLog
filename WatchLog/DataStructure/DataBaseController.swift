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
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd-MM-YYYY HH:mm:ss"
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = TimeZone(abbreviation: "UTC") // Example: New York timezone
        
        
        var LogYearEntry: WatchLogBookYear?
        var LogMonthEntry: WatchLogBookMonth?
        var LogDayEntry: WatchLogBookDay?
        
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
        print("FillerDate: \(formatter.string(from: FillerDate!))")
        
        
        var ListEntries: [WatchLogBookEntry] = []
        var ListYearEntries: [WatchLogBookYear] = []
        
        let LogEntryUUID:UUID = LogEntry.uuid
        
        
        let discriptor = FetchDescriptor<WatchLogBookEntry>(predicate: #Predicate{$0.uuid == LogEntryUUID})
        
        do {
            ListEntries = try modelContext.fetch(discriptor)
        } catch {
            print("failed")
        }
        
        
        if ListEntries.isEmpty {
            
            let EntryDate = LogEntry.EntryTime
            
            var DateComponent = DateComponents()
            DateComponent.year = Calendar.current.component(.year, from: EntryDate)-1
            DateComponent.month = 12
            DateComponent.day = 31
            DateComponent.hour = 23
            DateComponent.minute = 59
            DateComponent.second = 59
            DateComponent.nanosecond = 59
            let predecessorDate = Calendar.current.date(from: DateComponent)
            print("predecessorDate: \(formatter.string(from: predecessorDate!))")
                                  
            DateComponent.year = Calendar.current.component(.year, from: EntryDate)+1
            DateComponent.month = 01
            DateComponent.day = 01
            DateComponent.hour = 00
            DateComponent.minute = 00
            DateComponent.second = 00
            DateComponent.nanosecond = 00
            let successorDate = Calendar.current.date(from: DateComponent)
            print("successorDate: \(formatter.string(from: successorDate!))")
                                  
            
            //@Query(filter: #Predicate<WatchLogBookYear> {$0.LogDate > predecessorDate! && $0.LogDate < successorDate!}) var ListYearEntries: [WatchLogBookYear]
            
            
            let discriptor = FetchDescriptor<WatchLogBookYear>(predicate: #Predicate{$0.LogDate > predecessorDate! && $0.LogDate < successorDate!})
            
            do {
                ListYearEntries = try modelContext.fetch(discriptor)
            } catch {
                print("failed")
            }
            
            
            DateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: FillerDate!)
            DateComponent.year = Calendar.current.component(.year, from: EntryDate)
            FillerDate = Calendar.current.date(from: DateComponent)
            print("FillerDate Year: \(formatter.string(from: FillerDate!))")
            if ListYearEntries.isEmpty {
                LogYearEntry = WatchLogBookYear(LogDate: FillerDate!)
                modelContext.insert(LogYearEntry!)
                try? modelContext.save()
            } else {
                LogYearEntry = ListYearEntries[0]
            }
            
            
            
            
            
            let MonthFromDate = Calendar.current.component(.month, from: EntryDate)
            DateComponent.month = MonthFromDate
            FillerDate = Calendar.current.date(from: DateComponent)
            print("FillerDate Month: \(formatter.string(from: FillerDate!))")
            
            
            if LogYearEntry?.Children == nil || (LogYearEntry?.Children!.isEmpty)! {
                
                LogMonthEntry = WatchLogBookMonth(LogDate: FillerDate!)
                modelContext.insert(LogMonthEntry!)
                try? modelContext.save()
                LogYearEntry?.Children = [LogMonthEntry!]
                try? modelContext.save()
            } else {
                let filteredMonthArray = LogYearEntry!.Children!.filter { Calendar.current.isDate($0.LogDate, equalTo: FillerDate!, toGranularity: .month) }
                if filteredMonthArray.isEmpty {
                    LogMonthEntry = WatchLogBookMonth(LogDate: FillerDate!)
                    modelContext.insert(LogMonthEntry!)
                    try? modelContext.save()
                    LogYearEntry?.Children?.append(LogMonthEntry!)
                    try? modelContext.save()
                } else {
                    LogMonthEntry = filteredMonthArray[0]
                }
            }
            
            let DayFromDate = Calendar.current.component(.day, from: EntryDate)
            DateComponent.day = DayFromDate
            FillerDate = Calendar.current.date(from: DateComponent)
            print("FillerDate Day: \(formatter.string(from: FillerDate!))")
            
            if LogMonthEntry?.Children == nil || (LogMonthEntry?.Children!.isEmpty)! {
                
                LogDayEntry = WatchLogBookDay(LogDate: FillerDate!)
                LogMonthEntry?.Children = [LogDayEntry!]
                modelContext.insert(LogDayEntry!)
                try? modelContext.save()
                LogMonthEntry?.Children = [LogDayEntry!]
                try? modelContext.save()
            } else {
                let filteredDayArray = LogMonthEntry!.Children!.filter { Calendar.current.isDate($0.LogDate, equalTo: FillerDate!, toGranularity: .day) }
                if filteredDayArray.isEmpty {
                    LogDayEntry = WatchLogBookDay(LogDate: FillerDate!)
                    modelContext.insert(LogDayEntry!)
                    try? modelContext.save()
                    LogMonthEntry?.Children?.append(LogDayEntry!)
                    try? modelContext.save()
                } else {
                    LogDayEntry = filteredDayArray[0]
                }
            }
            
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
