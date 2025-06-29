//
//  SwiftUIView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import PencilKit
import SwiftData
import SwiftUI
import os

struct LogBookEntryView: View {
  @Binding public var logBookEntryUUID: UUID

  @EnvironmentObject var viewModel: LogEntryViewModel

  @Environment(\.appStyles) var appStyles
  @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID

  @Environment(\.dismiss) var dismiss

  @State var toolPickerShows = true
  @State var drawing = PKDrawing()

  @State var alertDelete = false
  @State var alertNew = false
  @State var alertClear = false

  @State private var isAnimating = false
  @State private var glowingColorSet: [Color] = [.blue, .yellow, .red]
    @State private var isBlur = false

  var body: some View {

    //        Text(Date.now, format: .dateTime.hour().minute().second())
    //           Text(logBookEntry.uuid.uuidString)
    //       Text("currentuuid: \(displayedLogEntryUUID.id.uuidString)")
    //      Text("currentuuid: \(viewModel.watchLogEntry.uuid.uuidString)")

    ScrollView {

      ZStack {

        glowingBorderEffect

        VStack(alignment: .leading, spacing: 0) {

          LogTimeView(logTime: viewModel.watchLogEntry.EntryTime)

          LockEditingView(logEntry: viewModel.watchLogEntry)

          CallInView(logEntry: viewModel.watchLogEntry)

          CallerDataView(logEntry: viewModel.watchLogEntry)

          ProcessTypeSelectionView(logEntry: viewModel.watchLogEntry)

          NoteView(
            logEntry: viewModel.watchLogEntry, drawing: $viewModel.watchLogEntry.pkDrawingData,
            toolPickerShows: $toolPickerShows
          )
        }
        .background(Color.black)
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity,
          alignment: .topLeading
        )
        .cornerRadius(20)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .blur(radius: isBlur ? 10 : 0)
      .animation(.linear(duration: 0.3), value: isBlur)
      .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
        
    }
    .task {
      await viewModel.fetchLogEntry(LogEntryUUID: logBookEntryUUID)
      print("--------->task")
      displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
      glowingColorSet = getGlowColorSet(logEntry: viewModel.watchLogEntry)

    }
    .onDisappear {
      print("entry view onDisappear")
      //dismiss()

    }
    .onChange(
      of: logBookEntryUUID,
      { oldValue, newValue in
        print("--------->onchange")
        Task {
          await viewModel.fetchLogEntry(LogEntryUUID: newValue)
          displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
          glowingColorSet = getGlowColorSet(logEntry: viewModel.watchLogEntry)
        }
      }
    )
    .onChange(of: viewModel.watchLogEntry.isLocked) { oldValue, newValue in
      glowingColorSet = getGlowColorSet(logEntry: viewModel.watchLogEntry)
    }
    .onChange(of: viewModel.watchLogEntry.isNewEntryLog) { oldValue, newValue in
      glowingColorSet = getGlowColorSet(logEntry: viewModel.watchLogEntry)
    }
    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Text("Log")
          .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSizeSub))
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
                  newEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                  logBookEntryUUID = viewModel.watchLogEntry.uuid
                    isBlur = false
                }
              })
            Button(
              "Abbrechen", role: .cancel,
              action: {
                  isBlur = false
              })
          }
          .alert("Neues Log erstellen?", isPresented: $alertNew) {
            Button(
              "Erstellen", role: .destructive,
              action: {
                newEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
                  isBlur = false
              })
            Button(
              "Abbrechen", role: .cancel,
              action: {
                  isBlur = false
              })
          }
          .alert("Eingaben verwerfen?", isPresented: $alertClear) {
            Button(
              "Verwerfen", role: .destructive,
              action: {
                clearEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                  isBlur = false
              })
            Button(
              "Nein", role: .cancel,
              action: {
                  isBlur = false
              })
          }
      }

    }

  }

  private func getGlowColorSet(logEntry: WatchLogEntry) -> [Color] {

    if logEntry.isLocked {
      return appStyles.glowingColorSetLocked
    } else {
      if logEntry.isNewEntryLog {
        return appStyles.glowingColorSetNew
      } else {
        return appStyles.glowingColorSetEditing
      }

    }

  }

}

private func clearEntry(LogEntry: inout WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry.clear()
  drawing = PKDrawing()
}

private func newEntry(LogEntry: inout WatchLogEntry, drawing: inout PKDrawing) {
  LogEntry = WatchLogEntry()
  drawing = PKDrawing()
  withAnimation {
    LogEntry.EntryTime = .now
  }

}

extension LogBookEntryView {

  private var glowingBorderEffect: some View {

    ZStack {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(
          AngularGradient(
            colors: glowingColorSet,
            center: .center,
            angle: .degrees(isAnimating ? 360 : 0))
        )
        .blur(radius: 18)

      //      RoundedRectangle(cornerRadius: 20, style: .continuous)
      //        .stroke(
      //          AngularGradient(
      //            colors: glowingColorSet,
      //            center: .center,
      //            angle: .degrees(isAnimating ? 360 : 0)),
      //          style: StrokeStyle(lineWidth: 4, lineCap: .round))
    }
    .onAppear {
      withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
        isAnimating = true
        print("on")
      }
    }
    .onDisappear {
      isAnimating = false
      print("off")
    }
  }

  private var ContextButton: some View {

    Menu {

      Button {
          isBlur = true
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
              isBlur = true
            viewModel.watchLogEntry.isLocked = true
            viewModel.watchLogEntry.isNewEntryLog = false
            await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
            print(">>> Log saved \(viewModel.watchLogEntry.uuid)")
            //await  logBookEntry = viewModel.fetchLogEntryMod(LogEntryUUID: viewModel.watchLogEntry.uuid)!
            viewModel.watchLogEntry.isNewEntryLog = false
            displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
            logBookEntryUUID = displayedLogEntryUUID.id

          }
            isBlur = false
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

    } label: {
      Image(systemName: appStyles.ToolbarContextImage)
        .symbolRenderingMode(.palette)
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30, alignment: .center)
        .foregroundStyle(
          appStyles.ToolbarContextColorActivePrimary, appStyles.ToolbarContextColorActiveSecondary
        )
        .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6))
    }
  }

  //   private var ContextButton: some View {
  //
  //    Image(systemName: appStyles.ToolbarContextImage)
  //      .symbolRenderingMode(.palette)
  //      .resizable()
  //      .scaledToFit()
  //      .frame(width: 30, height: 30, alignment: .center)
  //      .foregroundStyle(
  //        appStyles.ToolbarContextColorActivePrimary, appStyles.ToolbarContextColorActiveSecondary
  //      )
  //      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6))
  //
  //      .contextMenu {
  //
  //        Button {
  //          alertNew.toggle()
  //        } label: {
  //
  //          Label("Neues Log", systemImage: appStyles.ToolBarNewImageActive)
  //            .symbolRenderingMode(.palette)
  //            .foregroundStyle(
  //              appStyles.ToolBarNewColorActiveSecondary, appStyles.ToolBarNewColorActiveSecondary
  //            )
  //            .labelStyle(.titleAndIcon)
  //
  //        }
  //
  //        if !viewModel.watchLogEntry.isLocked {
  //          Button {
  //            Task {
  //              viewModel.watchLogEntry.isLocked = true
  //              viewModel.watchLogEntry.isNewEntryLog = false
  //              await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
  //              print(">>> Log saved \(viewModel.watchLogEntry.uuid)")
  //              //await  logBookEntry = viewModel.fetchLogEntryMod(LogEntryUUID: viewModel.watchLogEntry.uuid)!
  //              viewModel.watchLogEntry.isNewEntryLog = false
  //              displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
  //              logBookEntryUUID = displayedLogEntryUUID.id
  //
  //            }
  //          } label: {
  //
  //            Label("Log Speichern", systemImage: appStyles.ToolBarSaveImageActive)
  //              .symbolRenderingMode(.palette)
  //              .foregroundStyle(
  //                appStyles.ToolBarSaveColorActivePrimary, appStyles.ToolBarSaveColorActivePrimary
  //              )
  //              .labelStyle(.titleAndIcon)
  //
  //          }
  //
  //        }
  //
  //        Divider()
  //
  //        if !viewModel.watchLogEntry.isLocked {
  //          Button(role: .destructive) {
  //            alertClear.toggle()
  //          } label: {
  //
  //            Label("Log leeren", systemImage: appStyles.ToolBarEraserImageActive)
  //              .labelStyle(.titleAndIcon)
  //
  //          }
  //        }
  //
  //        if !viewModel.watchLogEntry.isLocked {
  //          Button(role: .destructive) {
  //            alertDelete.toggle()
  //          } label: {
  //
  //            Label("Log Löschen", systemImage: appStyles.ToolBarDeleteImageActive)
  //              .labelStyle(.titleAndIcon)
  //
  //          }
  //
  //        }
  //
  //      }
  //  }
}

#Preview{
  //@Previewable @State var existingLogBookEntry = WatchLogBookEntry()
  @Previewable @State var existingLogBookEntry = UUID()
  @Previewable @State var isNewEntry = false

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)

  LogBookEntryView(logBookEntryUUID: $existingLogBookEntry)
    .environmentObject(viewModel)
    .environment(\.appStyles, StylesLogEntry.shared)
    //.environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
    .environment(DisplayedLogEntryID())
}
