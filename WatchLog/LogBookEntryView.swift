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
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    @Environment(\.dismiss) var dismiss
    
    @State private var test: Date = Date()
    
    @State var toolPickerShows = true
    @State var drawing = PKDrawing()
    
    
    
    var body: some View {
        
        Text(Date.now, format: .dateTime.hour().minute().second())
         Text(exisitingLogBookEntry.uuid.uuidString)
        
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
            .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
        }
        .task {
                 viewModel.fetchLogEntry(LogEntryUUID: exisitingLogBookEntry.uuid)
            print("--------->task")
            print("--------->\(exisitingLogBookEntry.uuid.uuidString)")
                
        }
        .onDisappear {
            dismiss()
        }
        .onAppear() { //testdaten
            viewModel.generateLogBookEntry()
        }
        .onChange(of: exisitingLogBookEntry, { oldValue, newValue in
            
            print("--------->onchange")
            print("--------->\(exisitingLogBookEntry.uuid.uuidString)")
            Task {
                 viewModel.fetchLogEntry(LogEntryUUID: newValue.uuid)
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

          ToolbarItemGroup(placement: .automatic) {
            Button(action: {
              clearEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
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

              
              
            Button(action: {
                    newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
            }) {
              label: do {
                  Image(systemName: GeneralStyles.ToolBarNewImageActive)
                      .symbolRenderingMode(.palette)
                      .foregroundStyle(GeneralStyles.ToolBarNewColorActivePrimary, GeneralStyles.ToolBarNewColorActiveSecondary)
                      
              }
            }
            //.disabled(viewModel.watchLogEntry.isLocked)
              
              Button(action: {
                  Task {
                      await viewModel.deleteLogEntry(LogEntry: viewModel.watchLogEntry)
                      newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                      exisitingLogBookEntry.uuid = viewModel.watchLogEntry.uuid
                  }
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



#Preview {
    @Previewable @State var exisitingLogBookEntry = WatchLogBookEntry()
    
    let textFieldStyleLogEntry = GeneralStylesLogEntry()
    let databaseService = DatabaseService()
    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    LogBookEntryView(exisitingLogBookEntry: exisitingLogBookEntry)
        .environmentObject(viewModel)
        .environmentObject(textFieldStyleLogEntry)
    
}
