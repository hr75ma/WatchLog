//
//  SwiftUIView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import PencilKit
import SwiftData
import SwiftUI

struct LogBookEntryView: View {
  @Bindable public var logBookEntry: WatchLogBookEntry

  @EnvironmentObject var viewModel: LogEntryViewModel

  @Environment(\.appStyles) var appStyles
  @Environment(\.displayedLogEntryUUID) var displayedLogEntryUUID

  @Environment(\.dismiss) var dismiss


  @State var toolPickerShows = true
  @State var drawing = PKDrawing()

  @State var alertDelete = false
  @State var alertNew = false
  @State var alertClear = false


    
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
          WatchLog: viewModel.watchLogEntry, drawing: $viewModel.watchLogEntry.pkDrawingData,
          toolPickerShows: $toolPickerShows
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

          .stroke(
            viewModel.watchLogEntry.isLocked ? appStyles.isLockedColor : appStyles.isUnLockedColor,
            lineWidth: 4)

      )
      .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)

      .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))

    }
    .task {
      await viewModel.fetchLogEntry(LogEntryUUID: logBookEntry.uuid)
      print("--------->task")
      displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid

    }
    .onDisappear {
      print("entry view onDisappear")
      //dismiss()

    }

    .onChange(
      of: logBookEntry,
      { oldValue, newValue in

        print("--------->onchange")
        Task {
          await viewModel.fetchLogEntry(LogEntryUUID: newValue.uuid)
          displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
        }

      }
    )
    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Text("Log")
          .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize))
          .foregroundStyle(.blue)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }

      ToolbarItemGroup(placement: .primaryAction) {

        ContextButton

          .alert("Log Löschen?", isPresented: $alertDelete) {
            Button(
              "Löschen", role: .destructive,
              action: {
                Task {
                  await viewModel.deleteLogEntry(LogEntry: viewModel.watchLogEntry)
                  newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                  logBookEntry.uuid = viewModel.watchLogEntry.uuid
                  //logEntriesOfDay =  await viewModel.fetchDaysOfLogEntry(logEntry: WatchLogBookEntry( LogEntry: viewModel.watchLogEntry))

                }
              })
            Button(
              "Abbrechen", role: .cancel,
              action: {

              })
          }
          .alert("Neues Log erstellen?", isPresented: $alertNew) {
            Button(
              "Erstellen", role: .destructive,
              action: {
                newEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
                displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
              })
            Button(
              "Abbrechen", role: .cancel,
              action: {

              })
          }
          .alert("Eingaben verwerfen?", isPresented: $alertClear) {
            Button(
              "Verwerfen", role: .destructive,
              action: {
                clearEntry(LogEntry: viewModel.watchLogEntry, drawing: &drawing)
              })
            Button(
              "Nein", role: .cancel,
              action: {

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
  withAnimation {
    LogEntry.EntryTime = .now
  }

}

extension LogBookEntryView {

  private var ContextButton: some View {

      Image(systemName: appStyles.ToolbarContextImage)
      .symbolRenderingMode(.palette)
      .resizable()
      .scaledToFit()
      .frame(width: 40, height: 40, alignment: .center)
      .foregroundStyle(
        appStyles.ToolbarContextColorActivePrimary, appStyles.ToolbarContextColorActiveSecondary
      )
      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6))

      .contextMenu {

        Button {
          alertNew.toggle()
        } label: {

          Label("Neues Log", systemImage: appStyles.ToolBarNewImageActive)
            .symbolRenderingMode(.palette)
            .foregroundStyle(
              appStyles.ToolBarNewColorActiveSecondary, appStyles.ToolBarNewColorActiveSecondary
            )
            .labelStyle(.titleAndIcon)

        }

        if !viewModel.watchLogEntry.isLocked {
          Button {
            Task {
              viewModel.watchLogEntry.isLocked = true
              await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
            }
          } label: {

            Label("Log Speichern", systemImage: appStyles.ToolBarSaveImageActive)
              .symbolRenderingMode(.palette)
              .foregroundStyle(
                appStyles.ToolBarSaveColorActivePrimary, appStyles.ToolBarSaveColorActivePrimary
              )
              .labelStyle(.titleAndIcon)

          }

        }

        Divider()

        if !viewModel.watchLogEntry.isLocked {
          Button(role: .destructive) {
            alertClear.toggle()
          } label: {

            Label("Log leeren", systemImage: appStyles.ToolBarEraserImageActive)
              .labelStyle(.titleAndIcon)

          }
        }

        if !viewModel.watchLogEntry.isLocked {
          Button(role: .destructive) {
            alertDelete.toggle()
          } label: {

            Label("Log Löschen", systemImage: appStyles.ToolBarDeleteImageActive)
              .labelStyle(.titleAndIcon)

          }

        }

      }
  }
}

#Preview{
  @Previewable @State var existingLogBookEntry = WatchLogBookEntry()

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)
    
    LogBookEntryView(logBookEntry: existingLogBookEntry)
    .environmentObject(viewModel)
    .environment(\.appStyles, StylesLogEntry())
    .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())

}
