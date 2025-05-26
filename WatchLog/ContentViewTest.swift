import PencilKit
import SwiftData
//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import SwiftUI

#Preview {
    @Previewable @State var exisitingLogBookEntry = WatchLogBookEntry()
    
    let textFieldStyleLogEntry = TextFieldStyleLogEntry()
    let databaseService = DatabaseService()
    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    LogBookEntryView(exisitingLogBookEntry: exisitingLogBookEntry)
        .environmentObject(viewModel)
        .environmentObject(textFieldStyleLogEntry)
    
}

let TextfieldBackgroundColor: Color = Color(hex: 0x3b3b3b).opacity(1)
let LabelFontHeight: CGFloat = 35
let TextFieldFontHeight: CGFloat = 32
let LabelFont: String = "digital-7"
let TextFieldFont: String = "Roboto-MediumItalic"
let TextFieldHeight: CGFloat = 40

struct ContentViewTest: View {
   var exisitingLogBookEntry: WatchLogBookEntry
    @EnvironmentObject var viewModel: LogEntryViewModel
    
  @State var exisitingLogBookEntryUUID: UUID = UUID()

  @State var toolPickerShows = true
  @State var drawing = PKDrawing()
  @State var nameText: String = ""
  @State var currentTime: Date = Date()
    
    

  var body: some View {
      
//      let databaseService = DatabaseService()
//      let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    //@State var LogEntry = viewModel.watchLogEntry
    // Zoomable {


      ScrollView {

        VStack(alignment: .leading, spacing: 0) {

            DateAndTimeView(WatchLog: viewModel.watchLogEntry)

            LockEditingView(WatchLog: viewModel.watchLogEntry)

            CallerView(WatchLog: viewModel.watchLogEntry)

            AccidentView(WatchLog: viewModel.watchLogEntry)

          NoteView(
            WatchLog: viewModel.watchLogEntry, drawing: $drawing, toolPickerShows: $toolPickerShows
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
            .stroke(Color.blue, lineWidth: 4)
        )
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
      }
      .task {
              await viewModel.fetchLogEntry(LogEntryUUID: exisitingLogBookEntry.uuid)
              
      }

      .onChange(of: exisitingLogBookEntry, { oldValue, newValue in
          
          Task {
              await viewModel.fetchLogEntry(LogEntryUUID: newValue.uuid)
          }
      })
      .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Text("Eintrag")
          .font(Font.custom(LabelFont, size: LabelFontHeight))
          .foregroundStyle(.blue)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }

      ToolbarItemGroup(placement: .automatic) {
        Button(action: {
          clearEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
        }) {
          label: do {
            Image(systemName: "eraser.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              .foregroundStyle(viewModel.watchLogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .disabled(viewModel.watchLogEntry.isLocked)
        Button(action: {
          Task {
            await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
          }
        }) {
          label: do {
            Image(systemName: "square.and.arrow.down.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              .foregroundStyle(viewModel.watchLogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .disabled(viewModel.watchLogEntry.isLocked)

        Button(action: {
                newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
        }) {
          label: do {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              //.foregroundStyle(viewModel.watchLogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        //.disabled(viewModel.watchLogEntry.isLocked)

      }
    }

  }

}

private func clearEntry(LogEntry: WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry.clear()
  drawing = PKDrawing()
 withAnimation{
     LogEntry.EntryTime = .now
 }

}

private func newEntry(LogEntry: WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry.new()
  drawing = PKDrawing()
    withAnimation{
        LogEntry.EntryTime = .now
    }

}
