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
        .usesAlertController()
        .environment(LogEntryViewModel(dataBaseService: DatabaseService()))
        .environment(BlurSetting())
        .environment(\.appStyles, StylesLogEntry.shared)
        .environment(DisplayedLogEntryID())
        .environmentObject(AppSettings.shared)
        .environment(ExpandContainer())
        .environment(ExpandedRows())
        .environment(ClosedEventFilter())
}

struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    @Environment(LogEntryViewModel.self) var viewModel
    //@EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(BlurSetting.self) var blurSetting
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(ExpandContainer.self) var expansionContainer
    @Environment(ExpandedRows.self) var expandedRows

    // @Environment(\.dismiss) var dismiss

    // @State private var logBookEntryUUID: UUID = UUID()

    @State var alertNew: Bool = false
    @State var showSettingSheet: Bool = false
    @State var showProgression: Bool = false
    @State var showNewEntrySheet: Bool = false
    @State var showToolbarItem: Bool = true

    @State var scrollToNewEntry: UUID?

    @State var logEntryUUIDContainer: LogEntryUUIDContainer = LogEntryUUIDContainer()
    @State var newEntry: WatchLogEntry = WatchLogEntry()

    @State var logBook = WatchLogBook()
    
    @State var testBadge: Int = 0

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

            ScrollViewReader { proxy in

                List(viewModel.WatchLogBooks, id: \.id) { book in
                    buildLogBookNavigationTree(book: book)
                }
                .listStyleGeneral()
                .listStyle(.sidebar)
                .onChange(of: displayedLogEntryUUID.id) { _, newValue in
                    withAnimation(.smooth) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
                .onChange(of: scrollToNewEntry) { oldValue, newValue in
//                    print("------------------->")
//                    print(newValue)
                    if newValue == nil { return }

                    if newValue != oldValue {
                        withAnimation(.smooth) {
                            proxy.scrollTo(scrollToNewEntry, anchor: .center)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.watchLogViewGeneralBackground)
            .toolbar {
                if showToolbarItem {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        toolBarItemNewButton
                        toolBarItemSettings
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Wachbuch")
                            .navigationTitleModifier()
                            .customBadge(viewModel.nonClosedEventContainer.nonClosedEvents.count)
                            
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
                    LogBookEntryEditWrapperView(watchLogEntry: newEntry)
                }
                .fullScreenCoverModifier()
            }
            .sheet(isPresented: $showSettingSheet) {
                SettingView()
            }
            .sheet(isPresented: $showProgression) {
                ProgressionView()
            }
            .onDisappear {
                //print("tree view onDisappear")
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
                    
                    //only for preview
//                    await viewModel.initialSetOfNonClosedLogBookEntries()
//                    print("------->init for preview")
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
    @Binding var scrollToNewEntry: UUID?

    @State var isExpanded: Bool = false

    @Environment(\.appStyles) var appStyles
    @Environment(LogEntryViewModel.self) var viewModel
    //@EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(ExpandContainer.self) var expansionContainer
    @Environment(ExpandedRows.self) var expandedRows

    var body: some View {
        DisclosureGroup(DateManipulation.getYear(from: year.logDate), isExpanded: $isExpanded) {
            ForEach(year.logMonthSorted) { month in
                DisclosureGroupMonthView(month: month, logEntryUUIDContainer: $logEntryUUIDContainer, scrollToNewEntry: $scrollToNewEntry)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    Task {
                        expandedRows.rows.remove(year.watchLogBookMonths![i].id)
                        logEntryUUIDContainer = await viewModel.delete(deleteType: .month, toDeleteItem: year.watchLogBookMonths![i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                    }
                }
            })
        }
        .disclosureGroupStyleYearModifier()
        .onChange(of: isExpanded) { _, newValue in
            //print("disclosureYear \(isExpanded)")

            if newValue {
                expandedRows.rows.insert(year.id)
            } else {
                expandedRows.rows.remove(year.id)
            }
            //print("expanded rows \(expandedRows.rows)")
        }
        .onChange(of: expansionContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = year.id == expansionContainer.yearID || expandedRows.rows.contains(year.id)
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = year.id == expansionContainer.yearID || expandedRows.rows.contains(year.id)
            }
        }
    }
}

struct DisclosureGroupMonthView: View {
    @State var month: WatchLogBookMonth
    @Binding var logEntryUUIDContainer: LogEntryUUIDContainer
    @Binding var scrollToNewEntry: UUID?

    @Environment(\.appStyles) var appStyles
    @Environment(LogEntryViewModel.self) var viewModel
    //@EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(ExpandContainer.self) var expansionContainer
    @Environment(ExpandedRows.self) var expandedRows

    @State var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(DateManipulation.getMonth(from: month.logDate), isExpanded: $isExpanded) {
            ForEach(month.logDaysSorted) { day in
                DisclosureGroupLogEntriesView(day: day, logEntryUUIDContainer: $logEntryUUIDContainer, scrollToNewEntry: $scrollToNewEntry)
            }
            .onDelete(perform: { indexSet in
                indexSet.sorted(by: >).forEach { i in
                    Task {
                        expandedRows.rows.remove(month.watchLogBookDays![i].id)
                        logEntryUUIDContainer = await viewModel.delete(deleteType: .day, toDeleteItem: month.watchLogBookDays![i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                    }
                }
            })
        }
        .disclosureGroupStyleMonth(appStyles)
        .onChange(of: isExpanded) { _, newValue in
            if newValue {
                expandedRows.rows.insert(month.id)
            } else {
                expandedRows.rows.remove(month.id)
            }
        }
        .onChange(of: expansionContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = month.id == expansionContainer.monthID || expandedRows.rows.contains(month.id)
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = month.id == expansionContainer.monthID || expandedRows.rows.contains(month.id)
            }
        }
    }
}

struct DisclosureGroupLogEntriesView: View {
    @State var day: WatchLogBookDay
    @Binding var logEntryUUIDContainer: LogEntryUUIDContainer
    @Binding var scrollToNewEntry: UUID?

    @Environment(LogEntryViewModel.self) var viewModel
    //@EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(\.colorScheme) var colorScheme
    @Environment(ExpandContainer.self) var expansionContainer
    @Environment(ExpandedRows.self) var expandedRows
    @Environment(ClosedEventFilter.self) var closedEventFilter

    @State var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(DateManipulation.getWeekDay(from: day.logDate), isExpanded: $isExpanded) {
            ForEach(day.logEntriesSorted) { entry in

                Button(action: {
                    logEntryUUIDContainer = .init(logEntryUUID: entry.id, logBookDay: day)
                    displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
                    expansionContainer.setExpansionData(watchLogBookEntry: entry)
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(DateManipulation.getTime(from: entry.logDate))
                                .navigationTreeButtonLabelStyle(isSeletecedItem: entry.id == displayedLogEntryUUID.id)

                            if !entry.callerName.isEmpty {
                                Text(entry.callerName)
                                    .navigationTreeButtonSubLabelStyle(isSeletecedItem: entry.id == displayedLogEntryUUID.id)
                            }

                            if entry.processDetails != nil {
                                Text(entry.processDetails!.processTypeShort.localized)
                                    .navigationTreeButtonSubLabelStyle(isSeletecedItem: entry.id == displayedLogEntryUUID.id)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                        if closedEventFilter.closedFilter == .last24h {
                            if !entry.isClosed && DateManipulation.isDateInLast24h(date: entry.logDate) {
                                notClosedEventView
                            }
                        } else {
                            if closedEventFilter.closedFilter == .all {
                                if !entry.isClosed {
                                    notClosedEventView
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
        .onChange(of: isExpanded) { _, newValue in
            if newValue {
                expandedRows.rows.insert(day.id)
            } else {
                expandedRows.rows.remove(day.id)
            }
        }
        .onChange(of: expansionContainer.entryID) {
            withAnimation(.smooth) {
                isExpanded = day.id == expansionContainer.dayID || expandedRows.rows.contains(day.id)
                // scrollToNewEntry = day.id == expansionContainer.dayID ? true : false
            }
        }
        .task {
            withAnimation(.smooth) {
                isExpanded = day.id == expansionContainer.dayID || expandedRows.rows.contains(day.id)
                scrollToNewEntry = day.id == expansionContainer.dayID ? expansionContainer.id : nil
            }
        }
    }
}

extension DisclosureGroupLogEntriesView {
    fileprivate var notClosedEventView: some View {
        return VStack(alignment: .trailing, spacing: 0) {
            Image(systemName: appStyles.navigationTreeNotClosedImage)
                .notClosedImageStyle(primaryColor: .watchlogTreeClosedEventPrimary, secondaryColor: .watchlogTreeClosedEventSecondary, size: appStyles.navigationTreeNotClosedImageSize)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(maxWidth: appStyles.navigationTreeNotClosedImageSize, maxHeight: .infinity, alignment: .center)
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
            DisclosureGroupYearView(year: year, logEntryUUIDContainer: $logEntryUUIDContainer, scrollToNewEntry: $scrollToNewEntry)
        }
        .onDelete(perform: {
            indexSet in
            indexSet.sorted(by: >).forEach { i in
                Task {
                    expandedRows.rows.remove(book.logYearsSorted[i].id)
                    logEntryUUIDContainer = await viewModel.delete(deleteType: .year, toDeleteItem: book.logYearsSorted[i], displayedUUID: displayedLogEntryUUID.id, logEntryUUIDContainer: logEntryUUIDContainer)
                }
            }
        })
    }
}
