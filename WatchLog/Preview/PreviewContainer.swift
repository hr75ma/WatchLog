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

//    Task { @MainActor in
//
//      for y in 2025...2026 {
//
//        let year = WatchLogBookYear(LogDate: y)
//        modelContainer.mainContext.insert(year)
//        for m in 1...3{
//          let month = WatchLogBookMonth(LogDate: m)
//          modelContainer.mainContext.insert(month)
//          year.Children?.append(month)
//          for d in 1...3 {
//            let day = WatchLogBookDay(LogDate: d)
//            modelContainer.mainContext.insert(day)
//            month.Children?.append(day)
//            for entry in 1...4 {
//              let entryObject = WatchLogBookEntry(LogEntry: WatchLogEntry())
//              modelContainer.mainContext.insert(entryObject)
//              day.Children?.append(entryObject)
//            }
//          }
//        }
//      }
//    }

  }
}
