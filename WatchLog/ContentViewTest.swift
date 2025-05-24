import PencilKit
import SwiftData
//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import SwiftUI
import SwiftData

#Preview{
    
    @Previewable @State var exisitingLogBookEntry: UUID = UUID()
    ContentViewTest(exisitingLogBookEntryUUID: $exisitingLogBookEntry)
}




let TextfieldBackgroundColor: Color = Color(hex: 0x3b3b3b).opacity(1)
let LabelFontHeight: CGFloat = 35
let TextFieldFontHeight: CGFloat = 32
let LabelFont: String = "digital-7"
let TextFieldFont: String = "Roboto-MediumItalic"
let TextFieldHeight: CGFloat = 40

struct ContentViewTest: View {
    @Binding var exisitingLogBookEntryUUID: UUID
    
    //@EnvironmentObject var Database: DatabaseService
    
    
  @State var toolPickerShows = true
  @State var drawing = PKDrawing()
  @State var nameText: String = ""
  @State var currentTime: Date = Date()
  @State var LogEntry: WatchLogEntry = WatchLogEntry()
  @Environment(\.modelContext) var modelContext
  var dataBaseController: DataBaseController?

  var body: some View {

    // Zoomable {

    NavigationStack {

      ScrollView {

        VStack(alignment: .leading, spacing: 0) {

          DateAndTimeView(currentTime: $LogEntry.EntryTime)

          LockEditingView(WatchLog: LogEntry)

          CallerView(WatchLog: LogEntry)

          AccidentView(WatchLog: LogEntry)

          NoteView(
            DrawData: $LogEntry.drawingData, drawing: $drawing, toolPickerShows: $toolPickerShows
          )
          .containerRelativeFrame([.vertical], alignment: .topLeading)
          .disabled(LogEntry.isLocked)

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
      .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
    }
    .onAppear() {
        LogEntry = dataBaseController!.fetchExistingLogBookEntry(exisitingLogBookEntryUUID: exisitingLogBookEntryUUID)
        
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Text("Eintrag")
          .font(Font.custom(LabelFont, size: LabelFontHeight))
          .foregroundStyle(.blue)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }

      ToolbarItemGroup(placement: .automatic) {
        Button(action: {
          clearEntry(LogEntry: LogEntry, drawing: &drawing)
        }) {
          label: do {
            Image(systemName: "eraser.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              .foregroundStyle(LogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .disabled(LogEntry.isLocked)
        Button(action: {
          
          dataBaseController!.saveLogEntry(LogEntry: LogEntry)

        }) {
          label: do {
            Image(systemName: "square.and.arrow.down.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              .foregroundStyle(LogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .disabled(LogEntry.isLocked)

        Button(action: {
          newEntry(LogEntry: LogEntry, drawing: &drawing)
        }) {
          label: do {
            Image(systemName: "trash.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.monochrome)
              .symbolVariant(.fill)
              .foregroundStyle(LogEntry.isLocked ? .gray : .blue)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          }
        }
        .disabled(LogEntry.isLocked)

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

}
