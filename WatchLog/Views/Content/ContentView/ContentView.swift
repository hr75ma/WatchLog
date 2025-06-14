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


  var pre: PreviewData = PreviewData()
  pre.setPreviewDate(viewModel: viewModel)

  return ContentView()
    .environmentObject(viewModel)
    .environment(\.appStyles, StylesLogEntry())
    .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
    //.environment(\.locale, .init(identifier: "us"))
}

struct ContentView: View {
  @State private var columnVisibility = NavigationSplitViewVisibility.automatic

  @EnvironmentObject var viewModel: LogEntryViewModel

  @Environment(\.appStyles) var appStyles
  @Environment(\.displayedLogEntryUUID) var displayedLogEntryUUID

  @State private var logBookEntry: WatchLogBookEntry = WatchLogBookEntry()
  @State private var isNewEntry: Bool = false

  @State var alertNew = false
  @State var showSettingSheet = false

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
            .font(Font.custom(appStyles.NavigationTreeFont, size: appStyles.NavigationTreeFontSize))
            .refreshable(action: {
                Task {
                    await viewModel.fetchLogBook()
                }
            })
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
                    toolBarItemNewButton
                    
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
                ToolbarItem(placement: .primaryAction) {
                    toolBarItemSettings
                    
                }
            }
            .sheet(isPresented: $showSettingSheet) {
                SettingView()
            }
            
            .task {
                await viewModel.fetchLogBook()
                
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            //.background(Color.black.edgesIgnoringSafeArea(.all))
            
        } detail: {
            
            LogBookEntryView(logBookEntry: logBookEntry)
        }
        
    }

  fileprivate func generateNewLogEntryAfterExistingDeleted(exisistingUuid: UUID) {

    Task {
        let isCurrentUuuidExisting = await viewModel.isLogBookEntryExisting(from: exisistingUuid)
      if !isCurrentUuuidExisting {
        addNewLogEntry()
      }
    }
  }

  private func deleteLogEntry(watchLogBookEntry: WatchLogBookEntry) {
      Task {
        await viewModel.deleteLogEntry(
            LogEntry: WatchLogEntry(watchLookBookEntry: watchLogBookEntry))
          generateNewLogEntryAfterExistingDeleted(exisistingUuid: displayedLogEntryUUID.id)
    }
  }

  private func deleteLogDay(watchLogBookDay: WatchLogBookDay) {
      Task {
        await viewModel.deleteLogDay(watchLogBookDay: watchLogBookDay)
        generateNewLogEntryAfterExistingDeleted(exisistingUuid: displayedLogEntryUUID.id)
    }
  }

  private func deleteLogMonth(watchLogBookMonth: WatchLogBookMonth) {
      Task {
        await viewModel.deleteLogMonth(watchLogBookMonth: watchLogBookMonth)
        generateNewLogEntryAfterExistingDeleted(exisistingUuid: displayedLogEntryUUID.id)
    }
  }

  private func deleteLogYear(watchLogBookYear: WatchLogBookYear) {
      Task {
        await viewModel.deleteLogYear(watchLogBookYear: watchLogBookYear)
        generateNewLogEntryAfterExistingDeleted(exisistingUuid: displayedLogEntryUUID.id)
    }
  }

  private func addNewLogEntry() {
    isNewEntry = true
    logBookEntry = WatchLogBookEntry(uuid: UUID())

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

  private var toolBarItemNewButton: some View {

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

  private var toolBarItemSettings: some View {

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

  func buildLogBookNavigationTree(book: WatchLogBook) -> some View {

    ForEach(book.logYearsSorted) { year in
      DisclorsureGroupYear(year: year)
    }
    .onDelete(perform: { indexSet in
      indexSet.sorted(by: >).forEach { (i) in
        let LogEntry = book.logYearsSorted[i]
        deleteLogYear(watchLogBookYear: LogEntry)

      }
    })

  }

  func DisclorsureGroupYear(year: WatchLogBookYear) -> some View {
    DisclosureGroup(getDateYear(date: year.LogDate)) {
      ForEach(year.logMonthSorted) { month in
        DisclosureGroupLogMonth(month: month)

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

            logBookEntry = entry
          }) {
              VStack(alignment: .leading){
                  Text(getDateTime(date: entry.LogDate))
                  Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
                      .TextLabel(font: appStyles.NavigationTreeSubFont, fontSize: appStyles.NavigationTreeSubFontSize, fontColor: appStyles.NavigationTreeSubFontColor)
              }
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
