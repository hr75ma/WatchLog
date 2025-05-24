//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftData
import SwiftUI

#Preview{
  let previewData = PreviewData()
  previewData.addExampleData()
  return ContentView()
    .modelContainer(previewData.modelContainer)

}

let GroupLabelFont: String = "Roboto-MediumItalic"

struct ContentView: View {

  @Environment(\.modelContext) private var modelContext
  //@Environment(DataBaseController.self) private var databaseController

  @State private var columnVisibility =
    NavigationSplitViewVisibility.detailOnly

  @State private var test: Int = 0

  @State var StandardDate: Date = Date()

  @Query(sort: \WatchLogBookYear.LogDate, order: .forward) var ListYears: [WatchLogBookYear]

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {
      List {

        ForEach(ListYears) { years in
          DisclosureGroup(getDateYear(date: years.LogDate)) {
            ForEach(sortedMonth(years.Months!)) { child in
              DisclosureGroup(getDateMonth(date: child.LogDate)) {
                ForEach(sortedDay(child.Days!)) { child2 in
                  DisclosureGroup(getDateWeekDay(date: child2.LogDate)) {
                    ForEach(sortedEntries(child2.LogEntries!)) { child3 in
                      HStack {
                        //Text("\(child3.LogDate.formatted(date : .omitted, time : .standard))")
                        Text(getDateTime(date: child3.LogDate))
                          .font(Font.custom(GroupLabelFont, size: 25))
                        Spacer()
                      }
                      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                  }
                  .disclosureGroupStyle(DisclosureStyleDay())
                }
              }
              .disclosureGroupStyle(DisclosureStyleMonth())
            }
          }
          .disclosureGroupStyle(DisclosureStyleYear())
        }

      }
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      .background(Color.black.edgesIgnoringSafeArea(.all))

    }
      detail: {

        @State var uuid: UUID = UUID()
        ContentViewTest(exisitingLogBookEntryUUID: $uuid)
        .containerRelativeFrame(
          [.horizontal, .vertical],
          alignment: .topLeading
        )
        .padding()
    }
  }

  

  private func sortedEntries(_ LogEntry: [WatchLogBookEntry]) -> [WatchLogBookEntry] {
    return LogEntry.sorted(using: [
      SortDescriptor(\.LogDate, order: .forward)
    ])

  }

  private func sortedDay(_ LogEntry: [WatchLogBookDay]) -> [WatchLogBookDay] {
    return LogEntry.sorted(using: [
      SortDescriptor(\.LogDate, order: .forward)
    ])

  }

  private func sortedMonth(_ LogEntry: [WatchLogBookMonth]) -> [WatchLogBookMonth] {
    return LogEntry.sorted(using: [
      SortDescriptor(\.LogDate, order: .forward)
    ])

  }

  fileprivate func getDateYear(date: Date) -> String {
    return String(Calendar.current.component(.year, from: date))
  }
    
    fileprivate func getDateMonth(date: Date) -> String {
      return  date.formatted(.dateTime.month(.wide))
    }

  fileprivate func getDateWeekDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd. - EEEE"  // OR "dd-MM-yyyy"

    return dateFormatter.string(from: date)
  }
    
fileprivate func getDateTime(date: Date) -> String {
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "HH:mm:ss"
        //return dateFormatter.string(from: date)
    let dateStyle = Date.FormatStyle.dateTime
    return date.formatted(dateStyle.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits))
    }

}


