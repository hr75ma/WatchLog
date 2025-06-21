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
  @Bindable public var logBookEntry: WatchLogBookEntry

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
  @State private var showGlowAnimation = false

  @State private var frameSize = CGSize.zero

    @State private var glowingColorSet: [Color] = [.blue, .red, .blue]

  private let glowingColorSetLocked: [Color] = [.blue, .red, .blue]
  private let glowingColorSetNew: [Color] = [.blue, .green, .blue]

  let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: LogBookEntryView.self)
  )

  var body: some View {

    //        Text(Date.now, format: .dateTime.hour().minute().second())
//           Text(logBookEntry.uuid.uuidString)
//       Text("currentuuid: \(displayedLogEntryUUID.id.uuidString)")
//      Text("currentuuid: \(viewModel.watchLogEntry.uuid.uuidString)")

    ScrollView {

      //VStack(spacing: 20) {
        ZStack
        {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(
            AngularGradient(
                colors: glowingColorSet,
                center: .center,
                angle: .degrees(isAnimating ? 360 : 0))
          )
          .blur(radius: 20)
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
          .onChange(of: showGlowAnimation) {
              withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                  isAnimating = true
                  print("on change")
              }
          }
          .isHidden(!showGlowAnimation, remove: true)
          
          
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
                AngularGradient(
                    colors: glowingColorSet,
                    center: .center,
                    angle: .degrees(isAnimating ? 360 : 0))
              )
            .stroke(
                AngularGradient(
                    colors: glowingColorSet,
                    center: .center,
                    angle: .degrees(isAnimating ? 360 : 0))
              , style: StrokeStyle(lineWidth: 5, lineCap: .round))
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
            .onChange(of: showGlowAnimation) {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    isAnimating = true
                    print("on change")
                }
            }
            .isHidden(!showGlowAnimation, remove: true)
          

        VStack(alignment: .leading, spacing: 0) {

          Button("Test") {

            withAnimation(.easeInOut(duration: 1)) {
                showGlowAnimation.toggle()
              print(showGlowAnimation)
            }
          }

          LogTimeView(LogTime: viewModel.watchLogEntry.EntryTime)

          LockedView(LogEntry: viewModel.watchLogEntry)

          CallerDataView(logEntry: viewModel.watchLogEntry)

          ProcessTypeSelectionView(LogEntry: viewModel.watchLogEntry)

          NoteView(
            logEntry: viewModel.watchLogEntry, drawing: $viewModel.watchLogEntry.pkDrawingData,
            toolPickerShows: $toolPickerShows
          )
          .containerRelativeFrame([.vertical], alignment: .topLeading)
          .disabled(viewModel.watchLogEntry.isLocked)

        }
        .background(Color.black)
        //.sizeReader(size: $frameSize)

        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity,
          alignment: .topLeading
        )
        .cornerRadius(20)
        .overlay(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(
              viewModel.watchLogEntry.isLocked
                ? appStyles.isLockedColor : appStyles.isUnLockedColor,
              lineWidth: showGlowAnimation ? 0 : 5)
        )
        

        .animation(.easeInOut(duration: 1), value: viewModel.watchLogEntry.isLocked)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
      //   }

    }
    .task {
      await viewModel.fetchLogEntry(LogEntryUUID: logBookEntry.uuid)
      print("--------->task")
      displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
        glowingColorSet = viewModel.watchLogEntry.isNewEntryLog ? glowingColorSetNew : glowingColorSetLocked
        withAnimation(.easeInOut(duration: 1)) {
            if viewModel.watchLogEntry.isNewEntryLog || viewModel.watchLogEntry.isLocked {
                
                showGlowAnimation = true
                
            } else {
                
                showGlowAnimation = false
            }
            print("change both 1")
        }
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
            glowingColorSet = viewModel.watchLogEntry.isNewEntryLog ? glowingColorSetNew : glowingColorSetLocked
            withAnimation(.easeInOut(duration: 1)) {
                if viewModel.watchLogEntry.isNewEntryLog || viewModel.watchLogEntry.isLocked {
                    showGlowAnimation = true
                } else {
                    showGlowAnimation = false
                }
                
                
                print("change both 2")
            }
        }
          

      }
    )
    .onChange(of: viewModel.watchLogEntry.isLocked) { oldValue, newValue in
        glowingColorSet = viewModel.watchLogEntry.isLocked ? glowingColorSetLocked : glowingColorSetLocked
        withAnimation(.easeInOut(duration: 1)) {
            showGlowAnimation = false
            if newValue {
                
                showGlowAnimation = true
                
            } else {
                showGlowAnimation = false
            }
            print("change lock")
        }
    }
    .onChange(of: viewModel.watchLogEntry.isNewEntryLog) { oldValue, newValue in
        glowingColorSet = viewModel.watchLogEntry.isNewEntryLog ? glowingColorSetNew : glowingColorSetLocked
        withAnimation(.easeInOut(duration: 1)) {
            if newValue {
                
                showGlowAnimation = true
                
            }
            print("change new entry")
        }
    }
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
                  newEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                  logBookEntry.uuid = viewModel.watchLogEntry.uuid

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
                  newEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                  
                  displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid
                  logBookEntry.clear()
                  logBookEntry.uuid = viewModel.watchLogEntry.uuid
                  
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
                clearEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
              })
            Button(
              "Nein", role: .cancel,
              action: {

              })
          }
      }

    }

  }

  //}
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

struct SizeReader: ViewModifier {
  @Binding var size: CGSize

  func body(content: Content) -> some View {
    content
      .onGeometryChange(for: CGSize.self, of: \.size) { newVal in
        size = newVal
        print("Size: \(size.width) x \(size.height)")
      }

  }
}

extension View {
  func sizeReader(size: Binding<CGSize>) -> some View {
    modifier(SizeReader(size: size))
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
              viewModel.watchLogEntry.isNewEntryLog = false
              await viewModel.saveLogEntry(LogEntry: viewModel.watchLogEntry)
              print(">>> Log saved \(viewModel.watchLogEntry.uuid)")
              logBookEntry.uuid = viewModel.watchLogEntry.uuid
              viewModel.watchLogEntry.isNewEntryLog = false
              displayedLogEntryUUID.id = viewModel.watchLogEntry.uuid

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
  @Previewable @State var isNewEntry = false

  let databaseService = DatabaseService()
  let viewModel = LogEntryViewModel(dataBaseService: databaseService)

  LogBookEntryView(logBookEntry: existingLogBookEntry)
    .environmentObject(viewModel)
    .environment(\.appStyles, StylesLogEntry.shared)
    //.environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
    .environment(DisplayedLogEntryID())
}
