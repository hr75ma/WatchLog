//
//  PreviewContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 19.05.25.
//

import Foundation
import SwiftData

struct PreviewData {

  let modelContainer: ModelContainer
  init() {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    do {
      modelContainer = try ModelContainer(
        for: WatchLogBookYear.self, WatchLogBookMonth.self, WatchLogBookDay.self,
        WatchLogBookEntry.self, configurations: config)
    } catch {
      fatalError("Could not initialize ModelContainer")
    }
  }

  func addExampleData() {

      Task { @MainActor in
          
          var currentDate:Date = Date()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
          var futureDate: Date = Date()
          
          for year in 0...1 {
          futureDate = Calendar.current.date(byAdding: .year, value: year, to: currentDate)!
          let yearEntry = WatchLogBookYear(LogDate: futureDate)
          modelContainer.mainContext.insert(yearEntry)
              
              for month in 0...2 {
                  //print(month)
                  
                  futureDate = Calendar.current.date(byAdding: .month, value: month, to: currentDate)!
                  //print(futureDate)
                  let monthEntry = WatchLogBookMonth(LogDate: futureDate)
                  modelContainer.mainContext.insert(monthEntry)
                  yearEntry.Months?.append(monthEntry)
                  
                  for day in 0...1 {
                      futureDate = Calendar.current.date(byAdding: .day, value: day, to: currentDate)!
                      let dayEntry = WatchLogBookDay(LogDate: futureDate)
                      modelContainer.mainContext.insert(dayEntry)
                      monthEntry.Days?.append(dayEntry)
                      
                      for entry in 1...4 {
                          let entryObject = WatchLogBookEntry(LogEntry: WatchLogEntry())
                          modelContainer.mainContext.insert(entryObject)
                          dayEntry.LogEntries?.append(entryObject)
                          
                      }
                  }
              }
          }
      }
  }
}
