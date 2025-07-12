//
//  ScrollViewDispatcher.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import SwiftUI

struct ScrollViewDispatcher: View {
    @Binding public var logBookEntryUUID: UUID
    @Binding public var logBookDayUUID: UUID
    
    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    
    @State private var logBookEntriesforDay: [WatchLogBookEntry] = []
    
    var body: some View {
        
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(logBookEntriesforDay.indices, id: \.self) { index in
                        LogBookEntryView(logBookEntryUUID: $logBookEntriesforDay[index].uuid)
                            .id(logBookEntriesforDay[index].uuid)
                            .onScrollVisibilityChange(threshold: 1) { visibility in
                                print("index \(index) - \(logBookEntriesforDay[index].uuid.uuidString)")
                                logBookEntryUUID = logBookEntriesforDay[index].uuid
                                displayedLogEntryUUID.id = logBookEntriesforDay[index].uuid
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
            .scrollTargetBehavior(.viewAligned)
            
            .task {
                await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logBookDayUUID)
                    print("task \(logBookEntryUUID)")
                    proxy.scrollTo(logBookEntryUUID, anchor: .top)
            }
            .onAppear {
                Task {
                    await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logBookDayUUID)
                    withAnimation {
                        print("onapear \(logBookEntryUUID)")
                        proxy.scrollTo(logBookEntryUUID, anchor: .top)
                    }
                }
            }
            .onChange(
                of: logBookEntryUUID,
                { _, newValue in
                    Task {
                        await logBookEntriesforDay = viewModel.fetchLogEntriesFromDay(from: logBookDayUUID)
                        withAnimation {
                            print("newValue \(newValue)")
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                }
            )

            
        }
        
    }
}


extension ScrollViewDispatcher {
    func setUUID(_ uuid: UUID) -> UUID {
        return uuid
    }
}

