//
//  LogBookEntryEditWrapperView 2.swift
//  WatchLog
//
//  Created by Marcus Hörning on 16.07.25.
//


//
//  LogBookEntryWrapperView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.07.25.
//

import SwiftUI

struct LogBookEntryShowWrapperView: View {

    @Binding public var logBookEntryUUID: UUID
    let viewIsReadOnly: Bool = true
    
    @State private var watchLogEntry: WatchLogEntry = .init()
    
    @EnvironmentObject var viewModel: LogEntryViewModel

    @Environment(\.dismiss) var dismiss

    
    
    var body: some View {
        
        HStack {
            LogBookEntryView(watchLogEntry: $watchLogEntry, viewIsReadOnly: viewIsReadOnly)
        }
//        .onAppear{
//            Task {
//                print("onappear Show - \(logBookEntryUUID.uuidString)")
//                watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
//                watchLogEntry.isLocked = true
//            }
//        }
        .task {
            
                print("onappear Show - \(logBookEntryUUID.uuidString)")
                watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
                watchLogEntry.isLocked = true
          
        }
    }
}

//#Preview {
//    // @Previewable @State var existingLogBookEntry = WatchLogBookEntry()
//    @Previewable @State var existingLogBookEntry = UUID()
//    @Previewable @State var isEditing = true
//    @Previewable @State var watchLogEntry: WatchLogEntry = WatchLogEntry()
//
//    let databaseService = DatabaseService()
//    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
//
//    LogBookEntryWrapperView(logBookEntryUUID: $existingLogBookEntry, isEditing: $isEditing, watchLogEntry: $watchLogEntry)
//        .environmentObject(viewModel)
//        .environment(BlurSetting())
//        .environment(\.appStyles, StylesLogEntry.shared)
//        // .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
//        .environment(DisplayedLogEntryID())
//        .environmentObject(AppSettings.shared)
//}
