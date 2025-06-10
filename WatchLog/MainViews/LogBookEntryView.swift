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
    @Binding public var logEntriesOfDay: [WatchLogBookEntry]
    
    @EnvironmentObject var viewModel: LogEntryViewModel
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    @EnvironmentObject var currentUUID: UUIDContainer
    @Environment(\.dismiss) var dismiss
    
    //@Environment var logsOfDay: [WatchLogBookEntry]
    
    @State private var test: Date = Date()
    
    @State var toolPickerShows = true
    @State var drawing = PKDrawing()
    
    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false
    
    @State var showNavigationBar = true
    
    
    
    
    var body: some View {
        
//        Text(Date.now, format: .dateTime.hour().minute().second())
 //       Text(exisitingLogBookEntry.uuid.uuidString)
 //   Text("currentuuid: \(currentUUID.uuid.uuidString)")
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0) {
                
                LogTimeView(LogTime: viewModel.watchLogEntry.EntryTime)
                
                LockedView(LogEntry: viewModel.watchLogEntry)
                
                CallerDataView(LogEntry: viewModel.watchLogEntry)
                
                AccidentSelectionView(LogEntry: viewModel.watchLogEntry)
                
                NoteView(
                    WatchLog: viewModel.watchLogEntry, drawing: $viewModel.watchLogEntry.pkDrawingData, toolPickerShows: $toolPickerShows
                )
                .containerRelativeFrame([.vertical], alignment: .topLeading)
                .disabled(viewModel.watchLogEntry.isLocked)
                
            }
            .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                
                .stroke(viewModel.watchLogEntry.isLocked ? GeneralStyles.isLockedColor : GeneralStyles.isUnLockedColor, lineWidth: 4)
                
            )
            .animation(.easeInOut(duration: 1),  value: viewModel.watchLogEntry.isLocked)

            
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
        }
        .task {
                 await viewModel.fetchLogEntry(LogEntryUUID: exisitingLogBookEntry.uuid)
            print("--------->task")
            currentUUID.uuid = viewModel.watchLogEntry.uuid
            
                
        }
        .onDisappear {
            print("entry view onDisappear")
            dismiss()
            
                
        }
        
        
        .onChange(of: exisitingLogBookEntry, { oldValue, newValue in
            
            print("--------->onchange")
            Task {
                 await viewModel.fetchLogEntry(LogEntryUUID: newValue.uuid)
                currentUUID.uuid = viewModel.watchLogEntry.uuid
            }
            
            
        })
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Text("Log")
              .font(Font.custom(LabelFont, size: LabelFontHeight))
              .foregroundStyle(.blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }

            ToolbarItemGroup(placement: .primaryAction) {
            clearButton
              
            saveButton

            newButton
            
            deleteButton
            
                  .alert("Log Löschen?", isPresented: $alertDelete) {
                      Button("Löschen", role: .destructive, action: {
                          Task {
                              await viewModel.deleteLogEntry(LogEntry: viewModel.watchLogEntry)
                              newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                              exisitingLogBookEntry.uuid = viewModel.watchLogEntry.uuid
                              logEntriesOfDay =  await viewModel.fetchDaysOfLogEntry(logEntry: WatchLogBookEntry( LogEntry: viewModel.watchLogEntry))
                              
                          }
                      })
                      Button("Abbrechen", role: .cancel, action: {
                          
                      })
                  }
                  .alert("Neues Log erstellen?", isPresented: $alertNew) {
                      Button("Erstellen", role: .destructive, action: {
                          newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                          currentUUID.uuid = viewModel.watchLogEntry.uuid
                          Task {
                              logEntriesOfDay = await viewModel.fetchDaysOfLogEntry(logEntry: WatchLogBookEntry(LogEntry: viewModel.watchLogEntry))
                              logEntriesOfDay.append(WatchLogBookEntry(LogEntry: viewModel.watchLogEntry))
                          }
                      })
                      Button("Abbrechen", role: .cancel, action: {
                          
                      })
                  }
                  .alert("Eingaben verwerfen?", isPresented: $alertClear) {
                      Button("Verwerfen", role: .destructive, action: {
                          clearEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                      })
                      Button("Nein", role: .cancel, action: {
                          
                      })
                  }
              }
            
        }
        }
}




private func clearEntry(LogEntry: WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry.clear()
  drawing = PKDrawing()
}

private func newEntry(LogEntry: WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry.new()
  drawing = PKDrawing()
    withAnimation{
        LogEntry.EntryTime = .now
    }

}

extension LogBookEntryView {
    private var clearButton: some View {
        Button(action: {
            alertClear.toggle()
        }) {
          label: do {
              Image(systemName: viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarEraserImageUnActive : GeneralStyles.ToolBarEraserImageActive)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarEraserColorUnActive : GeneralStyles.ToolBarEraserColorActive)
              
                  .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)
              
                  .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6) ,isActive: viewModel.watchLogEntry.isLocked)
                  .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !viewModel.watchLogEntry.isLocked)
                  //.contentTransition(.symbolEffect(.replace.offUp, options: .nonRepeating))
                  .symbolEffect(.scale)
                }
        }
        .disabled(viewModel.watchLogEntry.isLocked)
    }
    
    private var saveButton: some View {
        Button(action: {
          Task {
              viewModel.watchLogEntry.isLocked = true
            await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
          }
        }) {
          label: do {
              Image(systemName: viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarSaveImageUnActive : GeneralStyles.ToolBarSaveImageActive)
                  .symbolRenderingMode(.multicolor)
              .foregroundStyle(viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarSaveColorUnActivePrimary : GeneralStyles.ToolBarSaveColorActivePrimary)
          
              .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)
          
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6) ,isActive: viewModel.watchLogEntry.isLocked)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !viewModel.watchLogEntry.isLocked)
              //.contentTransition(.symbolEffect(.replace.offUp, options: .nonRepeating))
              .symbolEffect(.scale)
          }
        }
        .disabled(viewModel.watchLogEntry.isLocked)
    }
    
    private var newButton: some View {
        //new Entry button
        Button(action: {
            alertNew.toggle()
        }) {
          label: do {
              Image(systemName: GeneralStyles.ToolBarNewImageActive)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(GeneralStyles.ToolBarNewColorActivePrimary, GeneralStyles.ToolBarNewColorActiveSecondary)
                  
          }
        }
        //.disabled(viewModel.watchLogEntry.isLocked)
    }
    
    private var deleteButton: some View {
        //delete button
        Button(action: {
            alertDelete.toggle()
        }) {
          label: do {
              Image(systemName: viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarDeleteImageUnActive : GeneralStyles.ToolBarDeleteImageActive)
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarDeleteColorUnActivePrimary : GeneralStyles.ToolBarDeleteColorActivePrimary, viewModel.watchLogEntry.isLocked ? GeneralStyles.ToolBarDeleteColorUnActiveSecondary : GeneralStyles.ToolBarDeleteColorActiveSecondary
                  )
              
                  .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)
              
                  
                  
                  //.contentTransition(.symbolEffect(.replace, options: .nonRepeating))
                  .symbolEffect(.breathe.pulse, options: .nonRepeating.speed(6), isActive: viewModel.watchLogEntry.isLocked)
                  .symbolEffect(.breathe.pulse, options: .nonRepeating.speed(6), isActive: !viewModel.watchLogEntry.isLocked)
                  .symbolEffect(.scale)
                  

                  
          }
        }
        .disabled(viewModel.watchLogEntry.isLocked)
    }
}



//#Preview {
//    @Previewable @State var exisitingLogBookEntry = WatchLogBookEntry()
//    
//    let textFieldStyleLogEntry = GeneralStylesLogEntry()
//    let databaseService = DatabaseService()
//    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
//    var currentLogEntryUUID:UUIDContainer = UUIDContainer()
//    LogBookEntryView(exisitingLogBookEntry: exisitingLogBookEntry)
//        .environmentObject(viewModel)
//        .environmentObject(textFieldStyleLogEntry)
//        .environmentObject(currentLogEntryUUID)
//    
//}


