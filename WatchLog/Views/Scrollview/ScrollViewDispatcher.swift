//
//  ScrollViewDispatcher.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import SwiftUI

struct ScrollViewDispatcher: View {
    @Binding public var logEntryUUIDContainer: LogEntryUUIDContainer

    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(\.appStyles) var appStyles
    @Environment(BlurSetting.self) var blurSetting


    @State private var logEntryUUID: UUID = UUID()

    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false
    
    @State var numberOfEntry: Int = 0
    
    
    
    
    @State private var scrollPos: UUID?

    var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid)
                            .id(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { scrolled in
                                if scrolled {
                                    print("index \(index) - \(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid.uuidString)")
                                    logEntryUUID = logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid
                                    numberOfEntry = index+1
                                }
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.3)
                                    .scaleEffect(x: 1, y: phase.isIdentity ? 1.0 : 0.9)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPos, anchor: .top)
            .scrollTargetBehavior(.viewAligned)
            //.scrollDisabled(logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries!.count == 1)
            .onAppear {
                Task { @MainActor in
                    print("onappear scroll\(logEntryUUIDContainer.logEntryUUID)")
                    withAnimation {
                        print("onappear \(logEntryUUIDContainer.logEntryUUID)")
                        scrollPos = logEntryUUIDContainer.logEntryUUID
                    }
                }
            }
            .onChange(of: logEntryUUID) {
                Task { @MainActor in
                    print("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
                    print("gelieferte entryUUID: \(logEntryUUIDContainer.logEntryUUID.uuidString)")
                    displayedLogEntryUUID.id = logEntryUUID
                    logEntryUUIDContainer.logEntryUUID = logEntryUUID
                }
            }
            .onChange(of: logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries) { oldValue, newValue in
                print("changed logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries")
                if !logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries!.isEmpty {
                    scrollPos = logEntryUUIDContainer.logEntryBookDay.logEntriesSorted.first!.uuid
                }
                
            }
            .onChange(of: logEntryUUIDContainer) { oldValue, newValue in
                Task { @MainActor in
                    print("gelieferte entryUUID: \(newValue.logEntryUUID.uuidString)")
                    if oldValue.logEntryBookDay.uuid != newValue.logEntryBookDay.uuid {
                        logEntryUUID = newValue.logEntryUUID
                        //try? await Task.sleep(for: .milliseconds(20))
                        print("onChange new Day: \(newValue.logEntryUUID)")
                        withAnimation {
                                scrollPos = logEntryUUIDContainer.logEntryUUID
                        }
                    } else {
                        //try? await Task.sleep(for: .milliseconds(20))
                        print("onChange same Day: \(newValue.logEntryUUID)")
                        withAnimation {
                            
                                scrollPos = logEntryUUIDContainer.logEntryUUID
                            
                        }
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text("Eintrag \(numberOfEntry) von \(logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries!.count)")
//                        .navigationTitleModifier()
//                }
//
//                ToolbarItemGroup(placement: .primaryAction) {
//                   MenuButton
//                }
//            }
            // .navigationBarBackground()
    }
}

extension ScrollViewDispatcher {
    
    var MenuButton: some View {
        Menu {
            Button {
                blurSetting.isBlur = true
                alertNew.toggle()
            } label: {
                NavigationMenuLabelView(menuItemType: MenuType.new)
            }
            
//            if !displayedWatchLogEntry.isLocked {
                Button {
                    saveEntry()
                    blurSetting.isBlur = false
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.save)
//                }
                
                Divider()
                
                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    // alertClear.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.clear)
                }
                
                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    //alertDelete.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.delete)
                }
            }
        } label: {
            NavigationToolbarItemImage(toolbarItemType: .menu, appStyles: appStyles)
        }
        .alert("Neues Log erstellen?", isPresented: $alertNew) {
            Button(
                "Erstellen", role: .destructive,
                action: {
                    newEntry()
                    //displayedLogEntryUUID = watchLogEntry.uuid
                    
                })
            cancelAlertButton()
        }
    }
    
    private func newEntry() {
        Task {
            blurSetting.isBlur = false
            let logBookDay = await viewModel.fetchLogBookDayOrEmptyDay(from: .now)
            let watchLogBookEntry = WatchLogBookEntry()
            logBookDay!.addLogEntry(watchLogBookEntry)
            logEntryUUIDContainer = .init(logEntryUUID: watchLogBookEntry.uuid, logBookDay: logBookDay!)
            //displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
         }
    }
    
    fileprivate func cancelAlertButton() -> Button<Text> {
        return Button(
            "Abbrechen", role: .cancel,
            action: {
                blurSetting.isBlur = false
            })
    }
    
    private func saveEntry() {
        Task {
            blurSetting.isBlur = true
//            displayedWatchLogEntry.isLocked = true
//            displayedWatchLogEntry.isNewEntryLog = false
//            await viewModel.saveLogEntry(LogEntry: displayedWatchLogEntry)
//            displayedWatchLogEntry.isNewEntryLog = false
//            //displayedLogEntryUUID = watchLogEntry.uuid
//            //logBookEntryUUID = displayedLogEntryUUID
           blurSetting.isBlur = false
        }
    }
     
}
