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
                //dismiss()
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
            //.background(Color.black.edgesIgnoringSafeArea(.all))
        } detail: {
            
            LogBookEntryView(logBookEntryUUID: $logBookEntryUUID)
        }
        .navigationSplitViewStyles(isBlur: blurSetting.isBlur, appStyles)
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
    }
    
    private func generateNewLogEntryAfterExistingDeleted(existingEntryID: UUID) {
        
        Task {
            let isCurrentUuuidExisting = await viewModel.isLogBookEntryExisting(from: existingEntryID)
            if !isCurrentUuuidExisting {
                addNewLogEntry()
            }
        }
    }
    
    private func delete<T>(deleteType: DeleteTypes,toDeleteItem: T) {
        
        switch deleteType {
            case .logEntry:
            Task {
                await viewModel.deleteLogEntry(LogEntry: WatchLogEntry(watchLookBookEntry: toDeleteItem as! WatchLogBookEntry))
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
                await viewModel.deleteLogYear(watchLogBookYear: toDeleteItem as!  WatchLogBookYear)
            }
        }
        generateNewLogEntryAfterExistingDeleted(existingEntryID: displayedLogEntryUUID.id)
        
    }
    
    private func addNewLogEntry() {
        logBookEntryUUID = UUID()
        displayedLogEntryUUID.id = logBookEntryUUID
    }
}
  

extension ContentView {

  private var toolBarItemNewButton: some View {
    Button(action: {
      alertNew.toggle()
      //Task { await NavigationTipNewLogEntry.setNavigationNewLogEvent.donate() }
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
      NavigationToolbarSettingsImage(appStyles: appStyles)
    }
  }

 private func buildLogBookNavigationTree(book: WatchLogBook) -> some View {

    ForEach(book.logYearsSorted) { year in
      DisclorsureGroupYear(year: year)
    }
    .onDelete(perform: { indexSet in
      indexSet.sorted(by: >).forEach { (i) in
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
        indexSet.sorted(by: >).forEach { (i) in
          let LogEntry = year.watchLogBookMonths![i]
          delete(deleteType: .month, toDeleteItem: LogEntry)
          
        }
      })
    }
    .disclosureGroupStyleYear(appStyles)
  }

    private func DisclosureGroupLogMonth(month: WatchLogBookMonth) -> some View {
      DisclosureGroup(DateManipulation.getMonth(from: month.LogDate)) {
      ForEach(month.logDaysSorted) { day in
        DisclosureGroupLogEntries(day: day)
      }
      .onDelete(perform: { indexSet in
        indexSet.sorted(by: >).forEach { (i) in
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
          logBookEntryUUID = entry.uuid
          displayedLogEntryUUID.id = logBookEntryUUID
        }) {
          VStack(alignment: .leading) {
              Text(DateManipulation.getTime(from: entry.LogDate))
              .navigationTreeLinkLabelStyle(
                isSeletecedItem: entry.uuid == displayedLogEntryUUID.id, appStyles: appStyles)
              if entry.processDetails != nil {
                  Text(ProcessType.processTypes[entry.processDetails!.processTypeShort]!)
                      .navigationTreeLinkSubLabelStyle(
                        isSeletecedItem: entry.uuid == displayedLogEntryUUID.id, appStyles: appStyles)
              }
          }
        }
        .selectedRowBackgroundColor(
          isSelectedRow: entry.uuid == displayedLogEntryUUID.id, appStyles)
      }
      .onDelete(perform: { indexSet in
        indexSet.sorted(by: >).forEach { (i) in
          let LogEntry = day.watchLogBookEntries![i]
          delete(deleteType: .logEntry, toDeleteItem: LogEntry)
          
        }
      })
    }
    .disclosureGroupStyleDay(appStyles)
  }

}
