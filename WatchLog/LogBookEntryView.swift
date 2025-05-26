//
//  SwiftUIView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import SwiftUI
import PencilKit
import SwiftData

struct LogBookEntryView: View {
    @Bindable public var exisitingLogBookEntry: WatchLogBookEntry
    
    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var test: Date = Date()
    
    
    
    var body: some View {
        
        Text(Date.now, format: .dateTime.hour().minute().second())

        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0) {
                
                LogTimeView(LogTime: viewModel.watchLogEntry.EntryTime)
                
                LockedView(LogEntry: viewModel.watchLogEntry)
                
            }
            
            Button {
                viewModel.watchLogEntry.EntryTime = Date.now
                         } label: {
                             Text("New Random Number")
                         }.buttonStyle(.borderedProminent)
            
            
            
        }
        .task {
                await viewModel.fetchLogEntry(LogEntryUUID: exisitingLogBookEntry.uuid)
                
        }
        .onDisappear {
            dismiss()
        }
        .onChange(of: exisitingLogBookEntry, { oldValue, newValue in
            
            Task {
                await viewModel.fetchLogEntry(LogEntryUUID: newValue.uuid)
            }
        })
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        
        }
        
    }







#Preview {
    @Previewable @State var exisitingLogBookEntry = WatchLogBookEntry()
    
    let textFieldStyleLogEntry = TextFieldStyleLogEntry()
    let databaseService = DatabaseService()
    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    LogBookEntryView(exisitingLogBookEntry: exisitingLogBookEntry)
        .environmentObject(viewModel)
        .environmentObject(textFieldStyleLogEntry)
    
}
