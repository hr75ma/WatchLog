//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import Foundation
import SwiftData
import SwiftUI

#Preview{
    let textFieldStyleLogEntry = TextFieldStyleLogEntry()
  let previewData = PreviewData()
  previewData.addExampleData()
  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)
  return ContentView()
    .environmentObject(viewModel)
    .environmentObject(textFieldStyleLogEntry)

}

let GroupLabelFont: String = "Roboto-MediumItalic"

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
  @EnvironmentObject var viewModel: LogEntryViewModel

  @State private var testInt: Int = 0
    @State private var testEntry: WatchLogBookEntry = WatchLogBookEntry()
    @State private var isNewEntry:Bool = false

  @State var StandardDate: Date = Date()
  @State var uuid: UUID = UUID()
  @State var selected = WatchLogBookEntry()
  @State var listOfEntry = [WatchLogBookEntry()]
    
    
    @State var isLinkActive = false
  // @Environment(\.modelContext) private var modelContext

  //@Query(sort: \WatchLogBookYear.LogDate, order: .forward) var ListYears: [WatchLogBookYear]
    @Query(sort: \WatchLogBookEntry.LogDate, order: .forward) var ListEntries: [WatchLogBookEntry]

  var body: some View {

    //      let databaseService = DatabaseService()
    //      let viewModel = LogEntryViewModel(dataBaseService: databaseService)

    NavigationSplitView(columnVisibility: $columnVisibility) {
    
//        List(ListEntries) { entries in
//            NavigationLink {
//                                      ContentTest(exisitingLogBookEntry: entries)
//                                    } label: {
//                                      Text(getDateTime(date: entries.LogDate))
//                                        .font(Font.custom(GroupLabelFont, size: 25))
//                                    }
//            
//            
//            
//        }
        
        
      List {
        ForEach(viewModel.LogBookEntryYears) { years in
          DisclosureGroup(getDateYear(date: years.LogDate)) {
            ForEach(sortedMonth(years.Months!)) { child in
              DisclosureGroup(getDateMonth(date: child.LogDate)) {
                ForEach(sortedDay(child.Days!)) { child2 in
                  DisclosureGroup(getDateWeekDay(date: child2.LogDate)) {
                    ForEach(sortedEntries(child2.LogEntries!)) { child3 in

                      HStack {

                          Button(action: {
                              
                              print("view item")
                              testEntry = child3
                              print(testEntry.uuid.uuidString)
                          }) {
                              Text(getDateTime(date: child3.LogDate))
                                  .font(Font.custom(GroupLabelFont, size: 25))
                              }
                        Spacer()
                      }
                      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                  }
//                                    .disclosureGroupStyle(DisclosureStyleDay())
                }
              }
                            //.disclosureGroupStyle(DisclosureStyleMonth())
            }
          }
                    //.disclosureGroupStyle(DisclosureStyleYear())
        }

      }
      .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
              Button(action: addItem) {
            
                   Text("+")
                          .font(Font.custom(GroupLabelFont, size: 25))
                  }
              
          }
      }
      .task {
       await viewModel.fetchLogBookYear()
      }
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      .background(Color.black.edgesIgnoringSafeArea(.all))

    } detail: {

        LogBookEntryView(exisitingLogBookEntry: testEntry)
    }
  }
    
    private func addItem() {
        print("add item")
        //testInt = testInt + 1
        isNewEntry = true
        testEntry = WatchLogBookEntry(uuid: UUID())
        print(testEntry.uuid.uuidString)
        
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
    return date.formatted(.dateTime.month(.wide))
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
    return date.formatted(
      dateStyle.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits))
  }

}
