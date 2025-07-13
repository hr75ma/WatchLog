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

    var body: some View {
        ScrollViewReader { proxy in

            ScrollView(.horizontal) {
                HStack {
                    
                    ForEach(logBookEntriesForDay.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logBookEntriesForDay[index].uuid, displayedLogEntryUUID: $displayedLogEntry)
                            .id(logBookEntriesForDay[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { _ in
                                print("index \(index) - \(logBookEntriesForDay[index].uuid.uuidString)")
                                // logBookEntryUUID = logBookEntriesforDay[index].uuid
                                displayedLogEntryUUID.id = logBookEntriesForDay[index].uuid
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
                await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
                print("task running")
            }
            .onAppear {
                Task {
                    await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
                    withAnimation {
                        print("onappear \(logEntryUUIDContainer.logEntryUUID)")
                        proxy.scrollTo(logEntryUUIDContainer.logEntryUUID, anchor: .top)
                    }
                }
            }
            .onChange(
                of: logEntryUUIDContainer,
                { oldValue, newValue in
                    Task {
                        if oldValue.logDayUUID != newValue.logDayUUID {
                            
                            await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
                            if logBookEntriesForDay.isEmpty {
                                logBookEntriesForDay.append(WatchLogBookEntry(uuid: logEntryUUIDContainer.logEntryUUID))
                            }
                        }
                        
                        withAnimation {
                            print("logBookDayUUID \(logEntryUUIDContainer.logDayUUID)")
                            proxy.scrollTo(logEntryUUIDContainer.logEntryUUID, anchor: .top)
                        }
                    }
                }
            )
        }
    }
}

