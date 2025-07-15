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

#Preview {
    // ---------->DataBaseManager speicher db

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
        .environmentObject(AppSettings.shared)
        .task {
            // try? Tips.resetDatastore()
            try? Tips.configure([
                // .displayFrequency(.immediate)
                .datastoreLocation(.applicationDefault),
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
    @Environment(\.colorScheme) var colorScheme
    
    // @Environment(\.dismiss) var dismiss
    
    //@State private var logBookEntryUUID: UUID = UUID()
    
    @State var alertNew: Bool = false
    @State var showSettingSheet: Bool = false
    @State var showProgression: Bool = false
    @State var showToolbarItem: Bool = true
    
    @State var dayOfLog: UUID = UUID()
    
    @State var logEntryUUIDContainer: LogEntryUUIDContainer = LogEntryUUIDContainer()
    
    let newLogEntryTip = NavigationTipNewLogEntry()
    let refreshListTip = NavigationTipRefresh()
    let listTip = NavigationTipList()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            
//            Text(logEntryUUIDContainer.logEntryUUID.uuidString)
//            Text("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
//            
            if showProgression {
                ProgressionView()
            }
            
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
                        toolBarItemSettings
                    }
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Wachbuch")
                                .navigationTitleModifier()
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettingSheet) {
                SettingView()
            }
            .sheet(isPresented: $showProgression) {
                ProgressionView()
            }
            .onDisappear {
                print("tree view onDisappear")
                // dismiss()
            }
            .onAppear {
                refreshProgressionBehavior(appStyles)
                Task {
                    showProgression = true
                    await viewModel.fetchLogBook()
                    // try? await Task.sleep(nanoseconds: 2 * 1000000000)
                    showProgression = false
                }
            }
            .task {
                await viewModel.fetchLogBook()
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            // .background(Color.black.edgesIgnoringSafeArea(.all))
        } detail: {

            ScrollViewDispatcher(logEntryUUIDContainer: $logEntryUUIDContainer)
        }
        .navigationSplitViewStyles(appStyles)
        .blurring(blurSetting: blurSetting)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                showToolbarItem = true
            case .inactive:
                showToolbarItem = false
            case .background:
                showToolbarItem = false
            default:
                break
            }
        }
        .appearanceUpdate()
    }
    
    private func testOnDeleteShownEntry(displayedUUID: UUID) {
        Task {
            let isExisting = await viewModel.isLogBookEntryExisting(from: displayedUUID)
            if !isExisting {
                manageWhatIsShowing()
            }
        }
    }
    
    private func delete<T>(deleteType: DeleteTypes, toDeleteItem: T) {
        switch deleteType {
        case .logEntry:
            Task {
                await viewModel.deleteLogEntry(
                    LogEntry: WatchLogEntry(watchLookBookEntry: toDeleteItem as! WatchLogBookEntry))
            }
        case .day:
            Task {
                await viewModel.deleteLogDay(watchLogBookDay: toDeleteItem as! WatchLogBookDay)
            }
        case .month:
            Task {
                await viewModel.deleteLogMonth(watchLogBookMonth: toDeleteItem as! WatchLogBookMonth)
            }
        case .year:
            Task {
                await viewModel.deleteLogYear(watchLogBookYear: toDeleteItem as! WatchLogBookYear)
            }
        }
        testOnDeleteShownEntry(displayedUUID: displayedLogEntryUUID.id)
    }
    
    private func manageWhatIsShowing() {
        
        Task {
            let logBookDay = await viewModel.fetchLogBookDayOrEmptyDay(from: .now)
            let watchLogBookEntry = WatchLogBookEntry()
            logBookDay!.addLogEntry(watchLogBookEntry)
            logEntryUUIDContainer = .init(logEntryUUID: watchLogBookEntry.uuid, logBookDay: logBookDay!)
            //displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
        }
    }
    
    private func addNewLogEntry() {
        
        Task {
            let logBookDay = await viewModel.fetchLogBookDayOrEmptyDay(from: .now)
            let watchLogBookEntry = WatchLogBookEntry()
            logBookDay!.addLogEntry(watchLogBookEntry)
            logEntryUUIDContainer = .init(logEntryUUID: watchLogBookEntry.uuid, logBookDay: logBookDay!)
            //displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
        }
    }
}

extension ContentView {
    private var toolBarItemNewButton: some View {
        Button(action: {
            alertNew.toggle()
            // Task { await NavigationTipNewLogEntry.setNavigationNewLogEvent.donate() }
            blurSetting.isBlur = true
        }) {
            NavigationToolbarItemImage(toolbarItemType: .addEntry, appStyles: appStyles)
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
    }

    private var toolBarItemSettings: some View {
        Button(action: {
            showSettingSheet = true
        }) {
            NavigationToolbarItemImage(toolbarItemType: .settings, appStyles: appStyles)
        }
    }

    private func buildLogBookNavigationTree(book: WatchLogBook) -> some View {
        ForEach(book.logYearsSorted) { year in
            DisclorsureGroupYear(year: year)
        }
        .onDelete(perform: { indexSet in
            indexSet.sorted(by: >).forEach { i in
                let LogEntry = book.logYearsSorted[i]
                delete(deleteType: .year, toDeleteItem: LogEntry)
            }
        })
    }

    private func DisclorsureGroupYear(year: WatchLogBookYear) -> some View {
        DisclosureGroup(DateManipulation.getYear(from: year.LogDate)) {
            ForEach(year.logMonthSorted) { month in
                DisclosureGroupLogMonth(month: month)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    let LogEntry = year.watchLogBookMonths![i]
                    delete(deleteType: .month, toDeleteItem: LogEntry)
                }
            })
        }
        .disclosureGroupStyleYearModifier()
    }

    private func DisclosureGroupLogMonth(month: WatchLogBookMonth) -> some View {
        DisclosureGroup(DateManipulation.getMonth(from: month.LogDate)) {
            ForEach(month.logDaysSorted) { day in
                DisclosureGroupLogEntries(day: day)
                // DisclosureTestView(day: day, logBookEntryUUID: $logBookEntryUUID)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    let LogEntry = month.watchLogBookDays![i]
                    delete(deleteType: .day, toDeleteItem: LogEntry)
                }
            })
        }
        .disclosureGroupStyleMonth(appStyles)
    }

    private func DisclosureGroupLogEntries(day: WatchLogBookDay) -> some View {
        DisclosureGroup(DateManipulation.getWeekDay(from: day.LogDate)) {
            ForEach(day.logEntriesSorted) { entry in
                
                
                    Button(action: {
                        logEntryUUIDContainer = .init(logEntryUUID: entry.uuid, logBookDay: day)
                        displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
                        
                    }) {
                        VStack(alignment: .leading) {
                            Text(DateManipulation.getTime(from: entry.LogDate))
                                .navigationTreeButtonLabelStyle(isSeletecedItem: entry.uuid == displayedLogEntryUUID.id)
                            
                            if entry.processDetails != nil {
                                Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
                                    .navigationTreeButtonSubLabelStyle(isSeletecedItem: entry.uuid == displayedLogEntryUUID.id)
                            }
                        }
                    }
                    .listRowBackground(
                        Rectangle()
                            .selectedRowBackgroundAnimation(isSelectedRow: entry.uuid == displayedLogEntryUUID.id, colorScheme: colorScheme, appStyles: appStyles)
                    )
                
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    let logEntry = day.watchLogBookEntries![i]
                    //delete(deleteType: .logEntry, toDeleteItem: logEntry)
                    Task {
                        
                        if await viewModel.isDeletedEntryInDisplayedDay(logEntryUUID: displayedLogEntryUUID.id, logEntryDayUUI: day.uuid) {
                            logEntryUUIDContainer = await viewModel.calculateShownAndDeleteLogEntry(logEntryUUID: logEntry.uuid, logEntryDayUUI: day.uuid)
                        } else {
                            await viewModel.deleteLogEntry(logEntryUUID: logEntry.uuid)
                        }
                    }
                }
            })
        }
        .disclosureGroupStyleDay(appStyles)
    }
}

// extension DisclosureTestView {
//  public func testOnEqualUUID(logEntryUUID: UUID, displayedLogEntryUUID: UUID) -> Bool {
//    if logEntryUUID == displayedLogEntryUUID {
//      //isSelection = true
//
//      return true
//    }
//    //isSelection = false
//
//    return false
//  }
// }

// struct DisclosureTestView: View {
//  @State var day: WatchLogBookDay
//  @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
//  @Binding var logBookEntryUUID: UUID
//
//  @State var isSelection: Bool = false
//  @State var isSelectedRow: WatchLogBookEntry? = nil
//
//  @Environment(\.appStyles) var appStyles
//  @Environment(\.colorScheme) var colorScheme
//
//  var body: some View {
//
//    DisclosureGroup(DateManipulation.getWeekDay(from: day.LogDate)) {
//      ForEach(day.logEntriesSorted) { entry in
//        Button(action: {
//          logBookEntryUUID = entry.uuid
//          displayedLogEntryUUID.id = logBookEntryUUID
//
//        }) {
//          VStack(alignment: .leading) {
//            Text(DateManipulation.getTime(from: entry.LogDate))
//              .navigationTreeLinkLabelStyle(
//                isSeletecedItem: testOnEqualUUID(
//                  logEntryUUID: entry.uuid, displayedLogEntryUUID: displayedLogEntryUUID.id))
//            if entry.processDetails != nil {
//              Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
//                .navigationTreeLinkSubLabelStyle(
//                  isSeletecedItem: entry.uuid == displayedLogEntryUUID.id)
//            }
//          }
//          .onChange(
//            of: testOnEqualUUID(
//              logEntryUUID: entry.uuid, displayedLogEntryUUID: displayedLogEntryUUID.id)
//          ) { oldValue, newValue in
//              print("--->onchange:")
//              print("entryuuid: \(entry.LogDate)")
//              print("entryuuid: \(entry.uuid)")
//              print("displayedLogEntryUUID: \(displayedLogEntryUUID.id)")
//              print("isSelectedRow: \(isSelectedRow?.uuid)")
//
//            withAnimation {
//               // isSelectedRow = isSelectedRow == entry && isSelectedRow?.id == displayedLogEntryUUID.id ? nil : entry
//                isSelectedRow = isSelectedRow == entry && entry.uuid == displayedLogEntryUUID.id ? nil : entry
//               print("isSelectedRow: \(isSelectedRow?.uuid)")
//                print("")
//            }
//          }
//
//        }
//        .listRowBackground(
//          RoundedRectangle(cornerRadius: 0)
//            //.backgroundRow(isSelectedRow: isSelectedRow == entry, colorScheme: colorScheme)
//            //.backgroundRow(isSelectedRow: isSelectedRow == entry, colorScheme: colorScheme)
//            .backgroundRow(isSelectedRow: entry.uuid == displayedLogEntryUUID.id, colorScheme: colorScheme)
//            //.animation(.easeInOut(duration: 1), value: isSelectedRow)
//        )
//      }
//
//    }
//    .disclosureGroupStyleDay(appStyles)
//
//  }
// }
