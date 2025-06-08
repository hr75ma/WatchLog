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

  let textFieldStyleLogEntry = GeneralStylesLogEntry()

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    var currentLogEntryUUID:UUIDContainer = UUIDContainer()

  var pre: PreviewData = PreviewData()
  pre.setPreviewDate(viewModel: viewModel)

  return ContentView()
    .environmentObject(viewModel)
    .environmentObject(textFieldStyleLogEntry)
    .environmentObject(currentLogEntryUUID)

}

let GroupLabelFont: String = "Roboto-MediumItalic"

struct ContentView: View {
  @State private var columnVisibility = NavigationSplitViewVisibility.automatic
  @EnvironmentObject var viewModel: LogEntryViewModel
  @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    @EnvironmentObject var currentUUID: UUIDContainer

  @State private var testInt: Int = 0
  @State private var testEntry: WatchLogBookEntry = WatchLogBookEntry()
    @State private var logsOfDay: [WatchLogBookEntry] = []
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

            Text(testEntry.uuid.uuidString)
        Text("currentuuid: \(currentUUID.uuid.uuidString)")
      List(viewModel.WatchLogBooks, id: \.uuid) { book in

          ForEach(book.logYearsSorted) { year in
          DisclosureGroup(getDateYear(date: year.LogDate)) {
              ForEach(year.logMonthSorted) { month in
              DisclosureGroup(getDateMonth(date: month.LogDate)) {
                  ForEach(month.logDaysSorted) { days in
                  DisclosureGroup(getDateWeekDay(date: days.LogDate)) {
                      ForEach(days.logEntriesSorted) { entry in
                      HStack {

                        Button(action: {

                          testEntry = entry
                            logsOfDay = days.logEntriesSorted
                         // print(testEntry.uuid.uuidString)
                        }) {
                          Text(getDateTime(date: entry.LogDate))
                        }

                        //Spacer()
                      }
                    }
                    .onDelete(perform: { indexSet in
                      indexSet.sorted(by: >).forEach { (i) in
                        let LogEntry = days.watchLogBookEntries![i]
                        deleteLogEntry(watchLogBookEntry: LogEntry)

                      }
                    })
                  }

                }
                .onDelete(perform: { indexSet in
                  indexSet.sorted(by: >).forEach { (i) in
                    let LogEntry = month.watchLogBookDays![i]
                    deleteLogDay(watchLogBookDay: LogEntry)

                  }
                })
              }

            }
            .onDelete(perform: { indexSet in
              indexSet.sorted(by: >).forEach { (i) in
                let LogEntry = year.watchLogBookMonths![i]
                deleteLogMonth(watchLogBookMonth: LogEntry)

              }
            })
          }
        }
        .onDelete(perform: { indexSet in
          indexSet.sorted(by: >).forEach { (i) in
            let LogEntry = sortedYear(book.watchLogBookYears!)[i]
            deleteLogYear(watchLogBookYear: LogEntry)

          }
        })

      }
      .listStyle(.insetGrouped)
      .foregroundStyle(GeneralStyles.NavigationTreeFontColor)
      .fontWeight(.medium)
      .font(
        Font.custom(GeneralStyles.NavigationTreeFont, size: GeneralStyles.NavigationTreeFontSize)
      )
      .refreshable(action: {
        Task {
          await  viewModel.fetchLogBook()
        }
          //print("current uuid: \(currentUUID.uuid.uuidString)")
      })
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            alertNew.toggle()
          }) {

            Image(systemName: GeneralStyles.NavigationTreeAddEntryImage)
              //.ToolbarImageStyle(GeneralStyles)
              .symbolRenderingMode(.palette)
              .foregroundStyle(
                GeneralStyles.NavigationTreeAddEntryImagePrimaryColor,
                GeneralStyles.NavigationTreeAddEntryImageSecondaryColor
              )
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
              .symbolEffect(.scale)
          }

        }
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            showSettingSheet = true
          }) {

            Image(systemName: GeneralStyles.NavigationTreeSettingImage)
              //.ToolbarImageStyle(GeneralStyles)
              .symbolRenderingMode(.palette)
              .foregroundStyle(
                GeneralStyles.NavigationTreeSettingImagePrimaryColor,
                GeneralStyles.NavigationTreeAddEntryImageSecondaryColor
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
        of: listOfEntry.count, { oldValue, newValue in
          Task {
            await  viewModel.fetchLogBook()
              //listOfEntry = viewModel.LogBookEntryYears
          }
            print("-------> contentview ListofEntry")
        }
      )
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      .background(Color.black.edgesIgnoringSafeArea(.all))

    } detail: {

      //LogBookEntryView(exisitingLogBookEntry: testEntry)
        TabViewForLogView(logBookEntry: testEntry, logEntriesOfDay: $logsOfDay)
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
      Task {
          logsOfDay = await viewModel.fetchDaysOfLogEntry(logEntry: testEntry)
          logsOfDay.append(testEntry)
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
