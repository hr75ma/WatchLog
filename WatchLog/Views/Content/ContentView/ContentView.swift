//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import Foundation
import SwiftData
import SwiftUI
import TipKit

#Preview{

  //---------->DataBaseManager speicher db

  // let textFieldStyleLogEntry = GeneralStylesLogEntry()

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)

  var pre: PreviewData = PreviewData()
  pre.setPreviewDate(viewModel: viewModel)

  return ContentView()
    .environmentObject(viewModel)
    .environment(BlurSetting())
    .environment(\.appStyles, StylesLogEntry.shared)
    .environment(DisplayedLogEntryID())
    .task {
      try? Tips.resetDatastore()
      try? Tips.configure([
        //.displayFrequency(.immediate)
        .datastoreLocation(.applicationDefault)
      ])
      // try? Tips.showAllTipsForTesting()

    }

}

struct ContentView: View {
  @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

  @EnvironmentObject var viewModel: LogEntryViewModel

  @Environment(\.appStyles) var appStyles
  @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
  @Environment(BlurSetting.self) var blurSetting

  // @Environment(\.dismiss) var dismiss
  //@State private var logBookEntry: WatchLogBookEntry = WatchLogBookEntry()

  @State private var logBookEntryUUID: UUID = UUID()

  @State var alertNew: Bool = false
  @State var showSettingSheet: Bool = false

  @State var showProgression: Bool = false

  let newLogEntryTip = NavigationTipNewLogEntry()
  let refreshListTip = NavigationTipRefresh()
  let listTip = NavigationTipList()
    
    let uuid1:UUID = UUID()

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {

      //Text(logBookEntry.uuid.uuidString)
      //      Text(logBookEntryUUID.uuidString)
      //      Text("currentuuid: \(displayedLogEntryUUID.id.uuidString)")

      //        if showProgression {
      //            ProgressionView()
      //        }

      TipView(refreshListTip)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
      TipView(listTip)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))

      List(viewModel.WatchLogBooks, id: \.uuid) { book in

        buildLogBookNavigationTree(book: book)

      }
      .listStyle(.insetGrouped)
      .foregroundStyle(appStyles.NavigationTreeFontColor)
      .fontWeight(.medium)
      .font(Font.custom(appStyles.NavigationTreeFont, size: appStyles.NavigationTreeFontSize))
      .refreshable(action: {
        print("refresh")
        Task {
          await viewModel.fetchLogBook()
        }
      })
      .toolbar {

        ToolbarItemGroup(placement: .topBarTrailing) {
          toolBarItemNewButton
            .popoverTip(newLogEntryTip)
            //.id(UUID())

          toolBarItemSettings
            

          toolBarItemTest
            //.id(UUID())
        }
      }
      .sheet(isPresented: $showSettingSheet) {
        SettingView()
      }
      .sheet(isPresented: $showProgression) {
        ProgressionView()
          .background(Color.clear)
      }
      .onDisappear {
        print("tree view onDisappear")

        //dismiss()
      }
      .onAppear {

        //Task { await NavigationTipRefresh.setNavigationRefreshEvent.donate() }
        //Task { await NavigationTipList.setNavigationListEvent.donate() }

        UIRefreshControl.appearance().tintColor = UIColor(appStyles.progressionColor)
        UIRefreshControl.appearance().attributedTitle = NSAttributedString(
          string: "Aktualisiere...",
          attributes: [
            NSAttributedString.Key.font: UIFont(
              name: appStyles.progressionFont, size: appStyles.progressionRefreshFontSize)!
          ])

        Task {
          showProgression = true
          await viewModel.fetchLogBook()

          //try? await Task.sleep(nanoseconds: 2 * 1000000000)
          showProgression = false
        }
      }
      .task {
        print("fetch tree")
        await viewModel.fetchLogBook()

      }

      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      //.background(Color.black.edgesIgnoringSafeArea(.all))

    } detail: {

      LogBookEntryView(logBookEntryUUID: $logBookEntryUUID)
    }
    .blur(radius: blurSetting.isBlur ? 10 : 0)

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
    //logBookEntry = WatchLogBookEntry(uuid: UUID())
    logBookEntryUUID = UUID()
    displayedLogEntryUUID.id = logBookEntryUUID
    print("------------> new entry added \(displayedLogEntryUUID.id)")

  }

  fileprivate func getDateYear(date: Date) -> String {
    return String(Calendar.current.component(.year, from: date))
  }

  fileprivate func getDateMonth(date: Date) -> String {
    return date.formatted(.dateTime.month(.wide))
  }

  fileprivate func getDateWeekDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd. EEEE"  // OR "dd-MM-yyyy"

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
      newLogEntryTip.invalidate(reason: .actionPerformed)
      alertNew.toggle()
      Task { await NavigationTipNewLogEntry.setNavigationNewLogEvent.donate() }
      blurSetting.isBlur = true

    }) {

      Image(systemName: appStyles.NavigationTreeAddEntryImage)
        //.ToolbarImageStyle(appStyles)
        .symbolRenderingMode(.palette)
        .foregroundStyle(
          appStyles.NavigationTreeAddEntryImagePrimaryColor,
          appStyles.NavigationTreeAddEntryImageSecondaryColor
        )
      // .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      // .symbolEffect(.scale)
    }
    .alert("Neues Log erstellen?", isPresented: $alertNew) {
      Button(
        "Erstellen", role: .destructive,
        action: {
          blurSetting.isBlur = false
          addNewLogEntry()

        })
      Button(
        "Abbrechen", role: .cancel,
        action: {
          blurSetting.isBlur = false
        })
    }

    //.tipViewStyle(TipStyler())

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
      // .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      // .symbolEffect(.scale)
    }

  }

  private var toolBarItemTest: some View {

    Button(action: {
      try? Tips.resetDatastore()
    }) {

      Image(systemName: appStyles.NavigationTreeSettingImage)
        //.ToolbarImageStyle(appStyles)
        .symbolRenderingMode(.palette)
        .foregroundStyle(
          appStyles.NavigationTreeSettingImagePrimaryColor,
          appStyles.NavigationTreeAddEntryImageSecondaryColor
        )
      // .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      //  .symbolEffect(.scale)
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
        // HStack {

        Button(action: {

          //logBookEntry = entry
          logBookEntryUUID = entry.uuid
          displayedLogEntryUUID.id = logBookEntryUUID
        }) {
          VStack(alignment: .leading) {
            Text(getDateTime(date: entry.LogDate))
              .TextLabel(
                font: appStyles.NavigationTreeSubFont,
                fontSize: appStyles.NavigationTreeFontSize,
                fontColor: entry.uuid == displayedLogEntryUUID.id
                  ? appStyles.NavigationTreeSubFontColor : appStyles.NavigationTreeFontColor)
            Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
              .TextLabel(
                font: appStyles.NavigationTreeSubFont,
                fontSize: appStyles.NavigationTreeSubFontSize,
                fontColor: appStyles.NavigationTreeSubFontColor)
          }
        }
        .listRowBackground(
          entry.uuid == displayedLogEntryUUID.id ? appStyles.NavigationTreeSelectedRowColor : .none)

        //  }

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
