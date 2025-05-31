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
  let textFieldStyleLogEntry = GeneralStylesLogEntry()

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)
  let previewData = PreviewData()
  previewData.addExampleData()
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
  @State private var isNewEntry: Bool = false

  @State var StandardDate: Date = Date()
  @State var uuid: UUID = UUID()
  @State var selected = WatchLogBookEntry()
  @State var listOfEntry: [WatchLogBookYear] = []

  @State var isLinkActive = false

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {

      Text(Date.now, format: .dateTime.hour().minute().second())
      Text(testEntry.uuid.uuidString)
        List(viewModel.WatchLogBooks, id: \.uuid) { book in
            
            ForEach(book.Years!) { y in
                DisclosureGroup(getDateYear(date: y.LogDate)) {
                    ForEach(sortedMonth(y.Months!)) { m in
                        DisclosureGroup(getDateMonth(date: m.LogDate)) {
                            ForEach(sortedDay(m.Days!)) { d in
                                DisclosureGroup(getDateWeekDay(date: d.LogDate)) {
                                    ForEach(sortedEntries(d.LogEntries!)) { e in
                                        HStack {

                                            Button(action: {
                                                
                                                print("view item")
                                                testEntry = e
                                                print(testEntry.uuid.uuidString)
                                            }) {
                                                Text(getDateTime(date: e.LogDate))
                                                    .font(Font.custom(GroupLabelFont, size: 25))
                                                }
                                          Spacer()
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                }
          }
           
        }
        .refreshable(action: {
            Task {
                print("--------->refresh Tree")
                await viewModel.fetchLogBookYear()
            }
        })
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: addItem) {

            Text("+")
              .font(Font.custom(GroupLabelFont, size: 25))
          }

        }
      }
      .task {
        print("--------->build Tree")
        print("--------->\(testEntry.uuid.uuidString)")
        await viewModel.fetchLogBook()
        //listOfEntry = viewModel.LogBookEntryYears
      }
      .onChange(
        of: listOfEntry.count,
        { oldValue, newValue in

          print("--------->onchange tree")

          Task {
            await viewModel.fetchLogBookYear()
          }
        }
      )

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

    
    private func sortedYear(_ LogEntry: [WatchLogBookYear]) -> [WatchLogBookYear] {
      return LogEntry.sorted(using: [
        SortDescriptor(\.LogDate, order: .forward)
      ])

    }
    
  private func sortedMonth(_ LogEntry: [WatchLogBookMonth]) -> [WatchLogBookMonth] {
    return LogEntry.sorted(using: [
      SortDescriptor(\.LogDate, order: .forward)
    ])

  }

    fileprivate func getDateBook(String: String) -> String {
      return "test"
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
