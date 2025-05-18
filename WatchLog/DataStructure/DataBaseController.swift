//
//  DataBaseController.swift
//  WatchLog
//
//  Created by Marcus Hörning on 17.05.25.
//

import SwiftUI
import SwiftData

public class DataBaseController {
        
    enum SaveLogEntryResult {
        case succes
        case failure(Error)
    }
    
    @Environment(\.modelContext) var modelContext
    
    private let dateString = "1975.08.02"
    
    
    
    
    func saveLogEntry(LogEntry: WatchLogEntry) -> SaveLogEntryResult {
        
        var LogYearEntry: WatchLogBookYear?
        var LogMonthEntry: WatchLogBookMonth?
        var LogDayEntry: WatchLogBookDay?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        var StandardDate = dateFormatter.date(from: dateString)
        
        var DateComponent = DateComponents()
        DateComponent.year = 1975
        DateComponent.month = 8
        DateComponent.year = 2
        DateComponent.hour = 1
        DateComponent.minute = 0
        DateComponent.second = 0
        
//        var ListEntries: [WatchLogBookEntry]
//        let discriptor = FetchDescriptor<WatchLogBookEntry>(predicate: #Predicate{$0.uuid == LogEntry.uuid})
//        
//        do {
//            ListEntries = try modelContext.fetch(discriptor)
//        } catch {
//            print("failed")
//        }
        
       @Query(filter: #Predicate<WatchLogBookEntry> {$0.uuid == LogEntry.uuid}) var ListEntries: [WatchLogBookEntry]
        
        if ListEntries.isEmpty {
            
            let Date = LogEntry.EntryTime
            @Query(filter: #Predicate<WatchLogBookYear> {Calendar.current.component(.year, from: $0.LogDate) == Calendar.current.component(.year, from: Date)}) var ListYearEntries: [WatchLogBookYear]
            
            if ListYearEntries.isEmpty {
                
                DateComponent.year = Calendar.current.component(.year, from: Date)
                LogYearEntry = WatchLogBookYear(LogDate: Calendar.current.date(from: DateComponent)!)
                modelContext.insert(LogYearEntry!)
                try? modelContext.save()
            } else {
                LogYearEntry = ListYearEntries[0]
            }
            
            DateComponent.month = Calendar.current.component(.month, from: Date)
            if LogYearEntry?.LogDateMonth == nil {
                
                LogMonthEntry = WatchLogBookMonth(LogDate: Calendar.current.date(from: DateComponent)!)
                modelContext.insert(LogMonthEntry!)
                try? modelContext.save()
                LogYearEntry?.LogDateMonth = [LogMonthEntry!]
            } else {
                var filteredMonthArray = LogYearEntry!.LogDateMonth!.filter { Calendar.current.component(.month, from: $0.LogDate) == Calendar.current.component(.month, from: Date) }
                if filteredMonthArray.isEmpty {
                    LogMonthEntry = WatchLogBookMonth(LogDate: Calendar.current.date(from: DateComponent)!)
                    modelContext.insert(LogMonthEntry!)
                    try? modelContext.save()
                    LogYearEntry?.LogDateMonth = [LogMonthEntry!]
                } else {
                    LogMonthEntry = filteredMonthArray[0]
                }
            }
            
            DateComponent.day = Calendar.current.component(.day, from: Date)
            if LogMonthEntry?.LogDateDay == nil {
                
                LogDayEntry = WatchLogBookDay(LogDate: Calendar.current.date(from: DateComponent)!)
                LogMonthEntry?.LogDateDay = [LogDayEntry!]
                modelContext.insert(LogDayEntry!)
                try? modelContext.save()
                LogMonthEntry?.LogDateDay = [LogDayEntry!]
            } else {
                var filteredDayArray = LogMonthEntry!.LogDateDay!.filter { Calendar.current.component(.day, from: $0.LogDate) == Calendar.current.component(.day, from: Date) }
                if filteredDayArray.isEmpty {
                    LogDayEntry = WatchLogBookDay(LogDate: Calendar.current.date(from: DateComponent)!)
                    modelContext.insert(LogDayEntry!)
                    try? modelContext.save()
                    LogMonthEntry?.LogDateDay = [LogDayEntry!]
                } else {
                    LogDayEntry = filteredDayArray[0]
                }
            }
            
            if LogDayEntry?.WatchLogBookEntry == nil {
                LogDayEntry?.WatchLogBookEntry = []
            }
            LogDayEntry?.WatchLogBookEntry?.append(WatchLogBookEntry(LogEntry: LogEntry))
            try? modelContext.save()
        } else {
            ListEntries[0].update(LogEntry: LogEntry)
            try? modelContext.save()
        }
        
        return SaveLogEntryResult.succes
    }
    
}
