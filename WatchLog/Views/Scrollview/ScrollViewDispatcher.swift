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

    @State private var logBookEntriesforDay: [WatchLogBookEntry] = []
    @State private var displayedLogEntry: UUID = UUID()

    var body: some View {
        ScrollViewReader { proxy in

            ScrollView(.horizontal) {
                HStack {
                    ForEach(logBookEntriesforDay.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logBookEntriesforDay[index].uuid, displayedLogEntryUUID: $displayedLogEntry)
                            .id(logBookEntriesforDay[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { _ in
                                print("index \(index) - \(logBookEntriesforDay[index].uuid.uuidString)")
                                // logBookEntryUUID = logBookEntriesforDay[index].uuid
                                displayedLogEntryUUID.id = logBookEntriesforDay[index].uuid
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

//            .task {
//                await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logBookDayUUID)
//                displayedLogEntryUUID.id = logBookEntryUUID
//                displayedLogEntry = displayedLogEntryUUID.id
//                    print("task \(logBookEntryUUID)")
//                    proxy.scrollTo(logBookEntryUUID, anchor: .top)
//
//            }
            .onAppear {
                Task {
                    await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
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
                            
                            await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
                            
                        }
                        
                        withAnimation {
                            print("logBookDayUUID \(logEntryUUIDContainer.logDayUUID)")
                            displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
                            proxy.scrollTo(logEntryUUIDContainer.logEntryUUID, anchor: .top)
                        }
                    }
                }
            )
        }
    }
}

