//
//  ScrollViewDispatcher.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import SwiftUI

struct ScrollViewDispatcher: View {
    // @Binding public var logBookEntryUUID: UUID
    // @Binding public var logBookDayUUID: UUID
    @Binding public var logEntryUUIDContainer: LogEntryUUIDContainer

    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID

    @State private var logBookEntriesForDay: [WatchLogBookEntry] = []
    @State private var displayedLogEntry: UUID = UUID()
    @State private var logEntryUUID: UUID = UUID()
    
    @State private var testDisplax: UUID = UUID()

    var body: some View {
        ScrollViewReader { proxy in

            ScrollView(.horizontal) {
                HStack {
                    
                    ForEach(logBookEntriesForDay.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logBookEntriesForDay[index].uuid, displayedLogEntryUUID: $testDisplax) //$displayedLogEntry)
                            .id(logBookEntriesForDay[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { scrolled in
                                if scrolled {
                                    print("index \(index) - \(logBookEntriesForDay[index].uuid.uuidString)")
                                    // logBookEntryUUID = logBookEntriesforDay[index].uuid
                                    //displayedLogEntryUUID.id = logBookEntriesForDay[index].uuid
                                    logEntryUUID = logBookEntriesForDay[index].uuid
                                }
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                            .scrollTransition { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.3)
//                                    .scaleEffect(x: 1, y: phase.isIdentity ? 1.0 : 0.9)
//                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .task {
//                await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
//                print("task running")
            }
            .onAppear {
                Task {
                    logBookEntriesForDay = logEntryUUIDContainer.logEntryBookDay.logEntriesSorted
                    withAnimation {
                                            print("onappear scroll\(logEntryUUIDContainer.logEntryUUID)")
                                            proxy.scrollTo(logEntryUUIDContainer.logEntryUUID, anchor: .top)
                                        }
//                    await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
//                    withAnimation {
//                        print("onappear \(logEntryUUIDContainer.logEntryUUID)")
//                        proxy.scrollTo(logEntryUUIDContainer.logEntryUUID, anchor: .top)
//                    }
                }
            }
            .onChange(of: logEntryUUID) {
                
                print("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
                displayedLogEntryUUID.id = logEntryUUID
                logEntryUUIDContainer.logEntryUUID = logEntryUUID
                
            }
            .onChange(of: logEntryUUIDContainer) { oldValue, newValue in
                Task {
                    if oldValue.logEntryBookDay.uuid != newValue.logEntryBookDay.uuid {
                        
                        logBookEntriesForDay = newValue.logEntryBookDay.logEntriesSorted
                        //displayedLogEntryUUID.id = newValue.logEntryUUID
                        //logEntryUUID = newValue.logEntryUUID
                        withAnimation {
                            print("onChange new Day: \(newValue.logEntryUUID)")
                            proxy.scrollTo(newValue.logEntryUUID, anchor: .top)
                        }
                        
                    } else {
                        //displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
                        //logEntryUUID = newValue.logEntryUUID
                        withAnimation {
                            print("onChange same Day: \(newValue.logEntryUUID)")
                            proxy.scrollTo(newValue.logEntryUUID, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

