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
    // pre.setPreviewDate(viewModel: viewModel)

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

    // @State private var logBookEntryUUID: UUID = UUID()

    @State var alertNew: Bool = false
    @State var showSettingSheet: Bool = false
    @State var showProgression: Bool = false
    @State var showNewEntrySheet: Bool = false
    @State var showToolbarItem: Bool = true

    @State var scale = 0.0

    @State var dayOfLog: UUID = UUID()

    @State var logEntryUUIDContainer: LogEntryUUIDContainer = LogEntryUUIDContainer()
    // @State var newEntryUUID: UUID = UUID()

    @State var newEntry: WatchLogEntry = WatchLogEntry()

    @State var logBook = WatchLogBook()

    @State var expandContainer: ExpandContainer = ExpandContainer()

    let newLogEntryTip = NavigationTipNewLogEntry()
    let refreshListTip = NavigationTipRefresh()
    let listTip = NavigationTipList()

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            //            VStack {
            //                Text(logEntryUUIDContainer.logEntryUUID.uuidString)
            //
            //                Text("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
            //            }

            if showProgression {
                ProgressionView()
            }

            List(viewModel.WatchLogBooks, id: \.id) { book in
                buildLogBookNavigationTree(book: book)
            }
            .listStyleGeneral()
            // .safeAreaInsetForToolbar()
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .toolbar {
                if showToolbarItem {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        toolBarItemNewButton
                        toolBarItemSettings
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Wachbuch")
                            .navigationTitleModifier()
                    }
                }
            }
            .toolbarModifier() // .background(Color.black.edgesIgnoringSafeArea(.all))
            .refreshable(action: {
                Task {
                    await viewModel.fetchLogBook()
                }
            })

            .fullScreenCover(isPresented: $showNewEntrySheet) {
                NavigationStack {
                    LogBookEntryEditWrapperView(watchLogEntry: newEntry, expandContainer: $expandContainer)
                        .transition(.move(edge: .bottom))
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
            .onChange(of: showNewEntrySheet) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    Task {
                        let isExisting = await viewModel.fetchLogBookEntry(logEntryID: newEntry.id)
                        if isExisting != nil {
                            logEntryUUIDContainer = .init(logEntryUUID: isExisting!.id, logBookDay: isExisting!.watchLogBookDay!)
                        }
                    }
                }
            }
            .onAppear {
                refreshProgressionBehavior(appStyles)
                Task {
                    showProgression = true
                    await viewModel.fetchLogBook()
                    showProgression = false
                }
            }
            .task {
                await viewModel.fetchLogBook()
            }
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DisclosureGroupYearView: View {
    @State var year: WatchLogBookYear
    @Binding var logEntryUUIDContainer: LogEntryUUIDContainer
    @Binding var expandContainer: ExpandContainer

    @State var isExpanded: Bool = false

    @Environment(\.appStyles) var appStyles
    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID

    var body: some View {
        DisclosureGroup(DateManipulation.getYear(from: year.logDate), isExpanded: $isExpanded) {
            ForEach(year.logMonthSorted) { month in
                DisclosureGroupMonthView(month: month, logEntryUUIDContainer: $logEntryUUIDContainer, expandContainer: $expandContainer)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    Task {
                        logEntryUUIDContainer = await viewModel.delete(deleteType: .month, toDeleteItem: year.watchLogBookMonths![i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                    }
                }
            })
        }
        .disclosureGroupStyleYearModifier()
        .onChange(of: expandContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = year.id == expandContainer.yearID
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = year.id == expandContainer.yearID
            }
        }
    }
}

struct DisclosureGroupMonthView: View {
    @State var month: WatchLogBookMonth
    @Binding var logEntryUUIDContainer: LogEntryUUIDContainer
    @Binding var expandContainer: ExpandContainer

    @Environment(\.appStyles) var appStyles
    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID

    @State var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(DateManipulation.getMonth(from: month.logDate), isExpanded: $isExpanded) {
            ForEach(month.logDaysSorted) { day in
                DisclosureGroupLogEntriesView(day: day, logEntryUUIDContainer: $logEntryUUIDContainer, expandContainer: $expandContainer)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    Task {
                        logEntryUUIDContainer = await viewModel.delete(deleteType: .day, toDeleteItem: month.watchLogBookDays![i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                    }
                }
            })
        }
        .disclosureGroupStyleMonth(appStyles)
        .onChange(of: expandContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = month.id == expandContainer.monthID
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = month.id == expandContainer.monthID
            }
        }
    }
}

struct DisclosureGroupLogEntriesView: View {
    @State var day: WatchLogBookDay
    @Binding var logEntryUUIDContainer: LogEntryUUIDContainer
    @Binding var expandContainer: ExpandContainer

    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(\.colorScheme) var colorScheme

    @State var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(DateManipulation.getWeekDay(from: day.logDate), isExpanded: $isExpanded) {
            ForEach(day.logEntriesSorted) { entry in

                Button(action: {
                    logEntryUUIDContainer = .init(logEntryUUID: entry.id, logBookDay: day)
                    displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID

                }) {
                    VStack(alignment: .leading) {
                        Text(DateManipulation.getTime(from: entry.logDate))
                            .navigationTreeButtonLabelStyle(isSeletecedItem: entry.id == displayedLogEntryUUID.id)

                        if entry.processDetails != nil {
                            Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
                                .navigationTreeButtonSubLabelStyle(isSeletecedItem: entry.id == displayedLogEntryUUID.id)
                        }
                    }
                }
                .listRowBackground(
                    Rectangle()
                        .selectedRowBackgroundAnimation(isSelectedRow: entry.id == displayedLogEntryUUID.id, colorScheme: colorScheme, appStyles: appStyles)
                )
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    let logEntry = day.watchLogBookEntries![i]
                    Task {
                        if await viewModel.isDeletedEntryInDisplayedDay(logEntryID: displayedLogEntryUUID.id, logDayID: day.id) {
                            logEntryUUIDContainer = await viewModel.calculateShownAndDeleteLogEntry(logEntryID: logEntry.id, logDayID: day.id)
                            displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
                        } else {
                            await viewModel.deleteLogEntry(logEntryID: logEntry.id)
                        }
                    }
                }
            })
        }
        .disclosureGroupStyleDay(appStyles)
        .onChange(of: expandContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = day.id == expandContainer.dayID
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = day.id == expandContainer.dayID
            }
        }
    }
}

extension ContentView {
    fileprivate var toolBarItemNewButton: some View {
        Button(action: {
            // alertNew.toggle()
            newEntry = WatchLogEntry()
            showNewEntrySheet = true
        }) {
            NavigationToolbarItemImage(toolbarItemType: .addEntry, appStyles: appStyles)
        }
    }

    fileprivate var toolBarItemSettings: some View {
        Button(action: {
            showSettingSheet = true
        }) {
            NavigationToolbarItemImage(toolbarItemType: .settings, appStyles: appStyles)
        }
    }

    fileprivate func buildLogBookNavigationTree(book: WatchLogBook) -> some View {
        ForEach(book.logYearsSorted) { year in
            DisclosureGroupYearView(year: year, logEntryUUIDContainer: $logEntryUUIDContainer, expandContainer: $expandContainer)
        }
        .onDelete(perform: {
            indexSet in
            indexSet.sorted(by: >).forEach { i in
                Task {
                    logEntryUUIDContainer = await viewModel.delete(deleteType: .year, toDeleteItem: book.logYearsSorted[i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                }
            }
        })
    }
}
