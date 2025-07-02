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
        //try? Tips.resetDatastore()
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
    @Environment(\.scenePhase) var scenePhase

  // @Environment(\.dismiss) var dismiss
  //@State private var logBookEntry: WatchLogBookEntry = WatchLogBookEntry()

  @State private var logBookEntryUUID: UUID = UUID()

  @State var alertNew: Bool = false
  @State var showSettingSheet: Bool = false

  @State var showProgression: Bool = false
    
    @State var showToolbarItem: Bool = true


  let newLogEntryTip = NavigationTipNewLogEntry()
  let refreshListTip = NavigationTipRefresh()
  let listTip = NavigationTipList()
    


    var body: some View {
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
            //Text(logBookEntry.uuid.uuidString)
            //      Text(logBookEntryUUID.uuidString)
            //      Text("currentuuid: \(displayedLogEntryUUID.id.uuidString)")
            
            //        if showProgression {
            //            ProgressionView()
            //        }
            
//            TipView(refreshListTip)
//                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            TipView(listTip)
//                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            List(viewModel.WatchLogBooks, id: \.uuid) { book in
                
                buildLogBookNavigationTree(book: book)
            }
            .listStyleGeneral()
            .refreshable(action: {
                Task {
                    await viewModel.fetchLogBook()
                }
            })
            .toolbar {
                if showToolbarItem {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        toolBarItemNewButton
                           // .popoverTip(newLogEntryTip)
                        toolBarItemSettings
                        
                    }
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
                await viewModel.fetchLogBook()
            }
            
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            //.background(Color.black.edgesIgnoringSafeArea(.all))
            
        } detail: {
            
            LogBookEntryView(logBookEntryUUID: $logBookEntryUUID)
        }
        .blur(radius: blurSetting.isBlur ? 10 : 0)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                showToolbarItem = true
            case .inactive:
                showToolbarItem = false
            case .background:
                showToolbarItem = true
            default:
                break
            }
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
      //newLogEntryTip.invalidate(reason: .actionPerformed)
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
        .symbolRenderingMode(.palette)        .foregroundStyle(appStyles.NavigationTreeSettingImagePrimaryColor,appStyles.NavigationTreeAddEntryImageSecondaryColor)
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
    .disclosureGroupStyleYear(appStyles)
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
    .disclosureGroupStyleMonth(appStyles)
  }

  func DisclosureGroupLogEntries(day: WatchLogBookDay) -> some View {

    DisclosureGroup(getDateWeekDay(date: day.LogDate)) {
      ForEach(day.logEntriesSorted) { entry in
        Button(action: {
          logBookEntryUUID = entry.uuid
          displayedLogEntryUUID.id = logBookEntryUUID
        }) {
          VStack(alignment: .leading) {
            Text(getDateTime(date: entry.LogDate))
                  .navigationTreeLinkLabelStyle(isSeletecedItem: entry.uuid == displayedLogEntryUUID.id, appStyles: appStyles)
            Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
                  .navigationTreeLinkSubLabelStyle(isSeletecedItem: entry.uuid == displayedLogEntryUUID.id, appStyles: appStyles)
          }
        }
        .selectedRowBackgroundColor(isSelectedRow: entry.uuid == displayedLogEntryUUID.id, appStyles)
      }
      .onDelete(perform: { indexSet in
        indexSet.sorted(by: >).forEach { (i) in
          let LogEntry = day.watchLogBookEntries![i]
          deleteLogEntry(watchLogBookEntry: LogEntry)
        }
      })
    }
    .disclosureGroupStyleDay(appStyles)
  }

}
