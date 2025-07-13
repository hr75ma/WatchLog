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
    
    @State private var scrollPos: UUID?

    var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(logBookEntriesForDay.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logBookEntriesForDay[index].uuid, displayedLogEntryUUID: $testDisplax) // $displayedLogEntry)
                            .id(logBookEntriesForDay[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { scrolled in
                                if scrolled {
                                    print("index \(index) - \(logBookEntriesForDay[index].uuid.uuidString)")
                                    logEntryUUID = logBookEntriesForDay[index].uuid
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
            .task {
//                await logBookEntriesForDay = viewModel.fetchLogEntriesFromDay(from: logEntryUUIDContainer.logDayUUID)
//                print("task running")
            }
            .onAppear {
                Task {
                    logBookEntriesForDay = logEntryUUIDContainer.logEntryBookDay.logEntriesSorted
                    print("onappear scroll\(logEntryUUIDContainer.logEntryUUID)")
                    withAnimation {
                        print("onappear \(logEntryUUIDContainer.logEntryUUID)")
                        scrollPos = logEntryUUIDContainer.logEntryUUID
                    }
                }
            }
            .onChange(of: logEntryUUID) {
                print("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
                print("gelieferte entryUUID: \(logEntryUUIDContainer.logEntryUUID.uuidString)")
                displayedLogEntryUUID.id = logEntryUUID
                logEntryUUIDContainer.logEntryUUID = logEntryUUID
            }
            .onChange(of: logEntryUUIDContainer) { oldValue, newValue in
                Task { @MainActor in
                    print("gelieferte entryUUID: \(newValue.logEntryUUID.uuidString)")
                    if oldValue.logEntryBookDay.uuid != newValue.logEntryBookDay.uuid {
                        logBookEntriesForDay = newValue.logEntryBookDay.logEntriesSorted
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
    }
}
