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

    // @State private var logBookEntryUUID: UUID = UUID()

    @State var alertNew: Bool = false
    @State var showSettingSheet: Bool = false
    @State var showProgression: Bool = false
    @State var showNewEntrySheet: Bool = false
    @State var showToolbarItem: Bool = true

    @State var dayOfLog: UUID = UUID()

    @State var logEntryUUIDContainer: LogEntryUUIDContainer = LogEntryUUIDContainer()
    @State var newEntryUUID: UUID = UUID()

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
            //.safeAreaInsetForToolbar()
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
            .toolbarModifier()            // .background(Color.black.edgesIgnoringSafeArea(.all))
            .refreshable(action: {
                Task {
                    await viewModel.fetchLogBook()
                }
            })

            .fullScreenCover(isPresented: $showNewEntrySheet) {
                NavigationStack {
                    LogBookEntryEditWrapperView(logBookEntryUUID: $newEntryUUID)
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
                
                withAnimation {
                    
                    if oldValue == true && newValue == false {
                        Task {
                            let isExisting = await viewModel.fetchLogBookEntry(from: newEntryUUID)
                            if isExisting != nil {
                                logEntryUUIDContainer = .init(logEntryUUID: isExisting!.uuid, logBookDay: isExisting!.watchLogBookDay!)
                            }
                        }
                    }
                }

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

            // .navigationSplitViewStyle(.balanced)

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
        .navigationBarTitleDisplayMode(.inline)
    }

    private func testOnDeleteDisplayedEntry(displayedUUID: UUID) {
        Task {
            let isExisting = await viewModel.isLogBookEntryExisting(from: displayedUUID)
            if !isExisting {
                // manageWhatIsShowing()
                logEntryUUIDContainer = .init(logEntryUUID: UUID(), logBookDay: WatchLogBookDay())
            }
        }
    }

    private func delete<T>(deleteType: DeleteTypes, toDeleteItem: T) {
        switch deleteType {
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
        default:
            break
        }
        testOnDeleteDisplayedEntry(displayedUUID: displayedLogEntryUUID.id)
    }
}

extension ContentView {
    private var toolBarItemNewButton: some View {
        Button(action: {
            //alertNew.toggle()
            blurSetting.isBlur = true
            newEntryUUID = UUID()
            showNewEntrySheet = true
        }) {
            NavigationToolbarItemImage(toolbarItemType: .addEntry, appStyles: appStyles)
        }
        .alert("Neues Log erstellen?", isPresented: $alertNew) {
            Button(
                "Erstellen", role: .destructive,
                action: {
                    blurSetting.isBlur = true
                    newEntryUUID = UUID()
                    showNewEntrySheet = true
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
        .onDelete(perform: {
            indexSet in
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
