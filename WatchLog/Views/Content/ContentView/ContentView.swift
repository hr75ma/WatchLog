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

  //---------->DataBaseManager speicher db

  // let textFieldStyleLogEntry = GeneralStylesLogEntry()

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)
  var currentLogEntryUUID: UUIDContainer = UUIDContainer()

  var pre: PreviewData = PreviewData()
  pre.setPreviewDate(viewModel: viewModel)

  return ContentView()
    .environmentObject(viewModel)
    .environmentObject(currentLogEntryUUID)
    .environment(\.appStyles, StylesLogEntry())

}

let GroupLabelFont: String = "Roboto-MediumItalic"

struct ContentView: View {
  @State private var columnVisibility = NavigationSplitViewVisibility.automatic

  @EnvironmentObject var viewModel: LogEntryViewModel
  @EnvironmentObject var currentUUID: UUIDContainer

  @Environment(\.appStyles) var appStyles

  @State private var testInt: Int = 0
  @State private var testEntry: WatchLogBookEntry = WatchLogBookEntry()
  @State private var isNewEntry: Bool = false

  @State var StandardDate: Date = Date()
  @State var uuid: UUID = UUID()
  @State var selected = WatchLogBookEntry()
  @State var listOfEntry: [WatchLogBookYear] = []

  @State var isLinkActive = false
  @State var alertNew = false
  @State var showSettingSheet = false

  @State var selectedEntry: WatchLogBookEntry = WatchLogBookEntry()

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {

//      Text(testEntry.uuid.uuidString)
//      Text("currentuuid: \(currentUUID.uuid.uuidString)")
        
      List(viewModel.WatchLogBooks, id: \.uuid) { book in

        buildLogBookNavigationTree(book: book)

      }
      .listStyle(.insetGrouped)
      .foregroundStyle(appStyles.NavigationTreeFontColor)
      .fontWeight(.medium)
      .font(
        Font.custom(appStyles.NavigationTreeFont, size: appStyles.NavigationTreeFontSize)
      )
      .refreshable(action: {
        Task {
          await viewModel.fetchLogBook()
        }
        //print("current uuid: \(currentUUID.uuid.uuidString)")
      })
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            alertNew.toggle()
          }) {

            Image(systemName: appStyles.NavigationTreeAddEntryImage)
              //.ToolbarImageStyle(appStyles)
              .symbolRenderingMode(.palette)
              .foregroundStyle(
                appStyles.NavigationTreeAddEntryImagePrimaryColor,
                appStyles.NavigationTreeAddEntryImageSecondaryColor
              )
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
              .symbolEffect(.scale)
          }

        }
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            showSettingSheet = true
          }) {

            Image(systemName: appStyles.NavigationTreeSettingImage)
              //.ToolbarImageStyle(appStyles)
              .symbolRenderingMode(.palette)
              .foregroundStyle(
                appStyles.NavigationTreeSettingImagePrimaryColor,
                appStyles.NavigationTreeAddEntryImageSecondaryColor
              )
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
              .symbolEffect(.scale)
          }

        }
      }
      .sheet(isPresented: $showSettingSheet) {
        SettingView()
      }

      .task {
        await viewModel.fetchLogBook()

      }
      .onChange(
        of: listOfEntry.count,
        { oldValue, newValue in
          Task {
            await viewModel.fetchLogBook()
            //listOfEntry = viewModel.LogBookEntryYears
          }
          print("-------> contentview ListofEntry")
        }
      )
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      .background(Color.black.edgesIgnoringSafeArea(.all))

    } detail: {

      LogBookEntryView(exisitingLogBookEntry: testEntry)
      // TabViewForLogView(logBookEntry: testEntry, logEntriesOfDay: $logsOfDay)
    }
    .alert("Neues Log erstellen?", isPresented: $alertNew) {
      Button(
        "Erstellen", role: .destructive,
        action: {
          addNewLogEntry()
        })
      Button(
        "Abbrechen", role: .cancel,
        action: {

        })
    }
  }

  fileprivate func generateNewLogEntryAfterExistingDeleted(exisitingUuid: UUID) {

    Task {
      let isCurrentUuuidExisting = await viewModel.exisitsLogEntry(uuid: exisitingUuid)
      if !isCurrentUuuidExisting {
        addNewLogEntry()
      }
    }
  }

  private func deleteLogEntry(watchLogBookEntry: WatchLogBookEntry) {
    withAnimation {

      Task {
        await viewModel.deleteLogEntry(
          LogEntry: WatchLogEntry(WatchLookBookEntry: watchLogBookEntry))
        generateNewLogEntryAfterExistingDeleted(exisitingUuid: currentUUID.uuid)

      }

    }
  }

  private func deleteLogDay(watchLogBookDay: WatchLogBookDay) {
    withAnimation {

      Task {
        await viewModel.deleteLogDay(watchLogBookDay: watchLogBookDay)
        generateNewLogEntryAfterExistingDeleted(exisitingUuid: currentUUID.uuid)
      }

    }
  }

  private func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) {
    withAnimation {

      Task {
        await viewModel.deleteLogMonth(watchLogBookMonth: watchLogBookMonth)
        generateNewLogEntryAfterExistingDeleted(exisitingUuid: currentUUID.uuid)
      }

    }
  }

  private func deleteLogYear(watchLogBookYear: WatchLogBookYear) {
    withAnimation {

      Task {
        await viewModel.deleteLogYear(watchLogBookYear: watchLogBookYear)
        generateNewLogEntryAfterExistingDeleted(exisitingUuid: currentUUID.uuid)
      }

    }
  }

  private func addNewLogEntry() {
    print("add item")

    isNewEntry = true
    testEntry = WatchLogBookEntry(uuid: UUID())
    //      Task {
    //          logsOfDay = await viewModel.fetchDaysOfLogEntry(logEntry: testEntry)
    //          logsOfDay.append(testEntry)
    //      }

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
      SortDescriptor(\.LogDate, order: .reverse)
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

extension ContentView {
    
    func buildLogBookNavigationTree(book: WatchLogBook) -> some View {
        
        ForEach(book.logYearsSorted) { year in
            DisclorsureGroupYear(year: year)
        }
        .onDelete(perform: { indexSet in
          indexSet.sorted(by: >).forEach { (i) in
            let LogEntry = sortedYear(book.watchLogBookYears!)[i]
            deleteLogYear(watchLogBookYear: LogEntry)

          }
        })
        
    }
    
    func DisclorsureGroupYear(year: WatchLogBookYear) -> some View {
        DisclosureGroup(getDateYear(date: year.LogDate)) {
          ForEach(year.logMonthSorted) { month in
              DisclosureGroupLogMonth(month:  month)

          }
          .onDelete(perform: { indexSet in
            indexSet.sorted(by: >).forEach { (i) in
              let LogEntry = year.watchLogBookMonths![i]
              deleteLogMonth(watchLogBookMonth: LogEntry)

            }
          })
        }
    }
    
    
    func DisclosureGroupLogMonth(month: WatchLogBookMonth) -> some View {
        DisclosureGroup(getDateMonth(date: month.LogDate)) {
          ForEach(month.logDaysSorted) { day in
              DisclosureGroupLogEntries(day: day)

          }
          .onDelete(perform: { indexSet in
            indexSet.sorted(by: >).forEach { (i) in
              let LogEntry = month.watchLogBookDays![i]
              deleteLogDay(watchLogBookDay: LogEntry)

            }
          })
        }
    }
    
     func DisclosureGroupLogEntries(day: WatchLogBookDay) -> some View {
        
        DisclosureGroup(getDateWeekDay(date: day.LogDate)) {
          ForEach(day.logEntriesSorted) { entry in
            HStack {

              Button(action: {

                testEntry = entry
              }) {
                Text(getDateTime(date: entry.LogDate))
              }

            }
          }
          .onDelete(perform: { indexSet in
            indexSet.sorted(by: >).forEach { (i) in
              let LogEntry = day.watchLogBookEntries![i]
              deleteLogEntry(watchLogBookEntry: LogEntry)
            }
          })
        }
    }
    
}

