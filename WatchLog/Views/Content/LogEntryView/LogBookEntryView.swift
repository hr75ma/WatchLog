//
//  SwiftUIView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import os
import PencilKit
import SwiftData
import SwiftUI

struct LogBookEntryView: View {
    @Binding public var logBookEntryUUID: UUID
    @Binding public var displayedLogEntryUUID: UUID
    @EnvironmentObject var viewModel: LogEntryViewModel

    @Environment(\.appStyles) var appStyles
    //@Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(BlurSetting.self) var blurSetting

    // @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase

    @State var watchLogEntry: WatchLogEntry = .init()
    
    @State var toolPickerShows = true
    @State var drawing = PKDrawing()

    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false

    @State var fromBackground: Bool = false

    @State private var isAnimating = false
    @State private var glowingColorSet: [Color] = [.blue, .yellow, .red]

    var body: some View {
//                Text(Date.now, format: .dateTime.hour().minute().second())
//                   Text(logBookEntryUUID.uuidString)
//               Text("currentuuid: \(displayedLogEntryUUID.id.uuidString)")
//              Text("currentuuid: \(viewModel.watchLogEntry.uuid.uuidString)")

        ScrollView {
            ZStack {
                glowingBorderEffect
                    .isHidden(fromBackground, remove: true)

                VStack(alignment: .leading, spacing: 0) {
                    LogTimeView(logTime: watchLogEntry.EntryTime)

                    LockEditingView(logEntry: watchLogEntry)

                    CallInView(logEntry: watchLogEntry)

                    CallerDataView(logEntry: watchLogEntry)

                    ProcessTypeSelectionView(logEntry: watchLogEntry)

                    NoteView(
                        logEntry: watchLogEntry, drawing: $watchLogEntry.pkDrawingData,
                        toolPickerShows: $toolPickerShows
                    )
                }
                .standardViewBackground()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .cornerRadius(appStyles.standardCornerRadius)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .standardLogEntryViewPadding()
        }
        .onAppear {
            isAnimating = true
            print("onappear")
        }
        .task {
            watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
            displayedLogEntryUUID = watchLogEntry.uuid
            glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
        }
        .onDisappear {
            print("diappear")
            // isAnimating = false
            // dismiss()
        }
        .onChange(
            of: logBookEntryUUID,
            { _, newValue in
                Task {
                    watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
                    displayedLogEntryUUID = watchLogEntry.uuid
                    glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
                }
            }
        )
        .onChange(of: watchLogEntry.isLocked) { _, newValue in
            glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
            if newValue {
                saveEntry()
            }
        }
        .onChange(of: watchLogEntry.isNewEntryLog) { _, _ in
            glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                Task {
                    fromBackground = false
                }
            case .background:
                isAnimating = false
                fromBackground = true
                print("come from background")
            case .inactive:
                isAnimating = false
                fromBackground = true
            default:
                break
            }
        }
        .standardScrollViewPadding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Eintrag")
                    .navigationTitleModifier()
            }

            ToolbarItemGroup(placement: .primaryAction) {
                MenuButton
            }
        }
        // .navigationBarBackground()
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
            RoundedRectangle(cornerRadius: appStyles.standardCornerRadius, style: .continuous)
                .fill(
                    AngularGradient(
                        colors: glowingColorSet,
                        center: .center,
                        angle: .degrees(isAnimating ? 360 : 0))
                )
                .blur(radius: appStyles.glowingBlurRadius)

            //      RoundedRectangle(cornerRadius: 20, style: .continuous)
            //        .stroke(
            //          AngularGradient(
            //            colors: glowingColorSet,
            //            center: .center,
            //            angle: .degrees(isAnimating ? 360 : 0)),
            //          style: StrokeStyle(lineWidth: 4, lineCap: .round))
        }
        .animation(Animation.linear(duration: appStyles.glowingAnimationDuration).repeatForever(autoreverses: false), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }

    var MenuButton: some View {
        Menu {
            Button {
                blurSetting.isBlur = true
                alertNew.toggle()
            } label: {
                NavigationMenuLabelView(menuItemType: MenuType.new)
            }

            if !watchLogEntry.isLocked {
                Button {
                    saveEntry()
                    blurSetting.isBlur = false
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.save)
                }

                Divider()

                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    alertClear.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.clear)
                }

                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    alertDelete.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.delete)
                }
            }
        } label: {
            NavigationToolbarItemImage(toolbarItemType: .menu, appStyles: appStyles)
        }
        .alert("Log Löschen?", isPresented: $alertDelete) {
            Button(
                "Löschen", role: .destructive,
                action: {
                    Task {
                        await viewModel.deleteLogEntry(LogEntry: viewModel.watchLogEntry)
                        newEntry(LogEntry: &watchLogEntry, drawing: &drawing)
                        logBookEntryUUID = watchLogEntry.uuid
                        blurSetting.isBlur = false
                    }
                })
            cancelAlertButton()
        }
        .alert("Neues Log erstellen?", isPresented: $alertNew) {
            Button(
                "Erstellen", role: .destructive,
                action: {
                    newEntry(LogEntry: &viewModel.watchLogEntry, drawing: &drawing)
                    displayedLogEntryUUID = watchLogEntry.uuid
                    blurSetting.isBlur = false
                })
            cancelAlertButton()
        }
        .alert("Eingaben verwerfen?", isPresented: $alertClear) {
            Button(
                "Verwerfen", role: .destructive,
                action: {
                    clearEntry(LogEntry: &watchLogEntry, drawing: &drawing)
                    blurSetting.isBlur = false
                })
            cancelAlertButton()
        }
    }

    fileprivate func cancelAlertButton() -> Button<Text> {
        return Button(
            "Abbrechen", role: .cancel,
            action: {
                blurSetting.isBlur = false
            })
    }

    private func saveEntry() {
        Task {
            blurSetting.isBlur = true
            watchLogEntry.isLocked = true
            watchLogEntry.isNewEntryLog = false
            await viewModel.saveLogEntry(LogEntry: watchLogEntry)
            watchLogEntry.isNewEntryLog = false
            displayedLogEntryUUID = watchLogEntry.uuid
            logBookEntryUUID = displayedLogEntryUUID
            blurSetting.isBlur = false
        }
    }
}

#Preview {
    // @Previewable @State var existingLogBookEntry = WatchLogBookEntry()
    @Previewable @State var existingLogBookEntry = UUID()
    @Previewable @State var displayedLogEntry = UUID()
    @Previewable @State var isNewEntry = false

    let databaseService = DatabaseService()
    let viewModel = LogEntryViewModel(dataBaseService: databaseService)

    LogBookEntryView(logBookEntryUUID: $existingLogBookEntry, displayedLogEntryUUID: $displayedLogEntry)
        .environmentObject(viewModel)
        .environment(BlurSetting())
        .environment(\.appStyles, StylesLogEntry.shared)
        // .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
        .environment(DisplayedLogEntryID())
        .environmentObject(AppSettings.shared)
}
