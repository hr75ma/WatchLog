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
    //@Binding public var logBookEntryUUID: UUID
    @Binding public var watchLogEntry: WatchLogEntry 
    @Binding public var isEditing: Bool
    //@State private var watchLogEntry: WatchLogEntry = .init()
    

    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(BlurSetting.self) var blurSetting
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase

    @State var toolPickerShows = true

    @State var fromBackground: Bool = false

    @State private var isAnimating = false
    @State private var glowingColorSet: [Color] = [.clear, .clear, .clear]

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

                    LockEditingView(logEntry: watchLogEntry, isEditing: $isEditing)

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
            Task {
                //print("onappear - \(logBookEntryUUID.uuidString)")
                //watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
                watchLogEntry.isLocked = isEditing ? false : true
                glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
            }
        }
        .task {
            //watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
            watchLogEntry.isLocked = isEditing ? false : true
            glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
        }
        .onDisappear {
            print("dismiss LogBookEntryView")
 //           dismiss()
        }
//        .onChange(
//            of: logBookEntryUUID,
//            { _, _ in
//                Task {
//                    watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
//                    watchLogEntry.isLocked = isEditing ? false : true
//                    // displayedLogEntryUUID = watchLogEntry.uuid
//                    glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
//                }
//            }
//        )
        .onChange(of: watchLogEntry.isLocked) { _, newValue in
            glowingColorSet = getGlowColorSet(logEntry: watchLogEntry)
            if newValue {
                print("save")
                saveEntry()
            }
        }

        .onChange(of: watchLogEntry.remoteSignalContainer.signale) { _, newValue in
            switch newValue {
            case .save:
                print("remote signal save received")
                    watchLogEntry.isLocked = true
                    
            case .delete:
                print("remote signal delete received")
                if watchLogEntry.uuid == displayedLogEntryUUID.id  {
                   deleteEntry()
                }
                dismiss()
            default:
                break
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
                print("inactive")
            default:
                break
            }
        }
        .standardScrollViewPadding()
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
    
    private func deleteEntry() {
        Task {
            await viewModel.deleteLogEntry(LogEntry: watchLogEntry)
                blurSetting.isBlur = false
            }
    }

    private func saveEntry() {
        Task {
            blurSetting.isBlur = true
            watchLogEntry.isLocked = true
            watchLogEntry.isNewEntryLog = false
            //print(watchLogEntry.CallerNumber)
            await viewModel.saveLogEntry(LogEntry: watchLogEntry)
            watchLogEntry.isNewEntryLog = false
            // displayedLogEntryUUID = watchLogEntry.uuid
            // logBookEntryUUID = displayedLogEntryUUID
            blurSetting.isBlur = false
        }
    }
}

extension View {
    func isVisible(_ isVisible: Binding<Bool>, edge: Alignment = .center) -> some View {
        modifier(IsVisible(isVisible: isVisible, edge: edge))
    }
}

struct IsVisible: ViewModifier {
    @Binding var isVisible: Bool
    let edge: Alignment

    func body(content: Content) -> some View {
        content
            .overlay(
                LazyVStack {
                    Color.clear
                        .onAppear {
                            isVisible = true
                        }
                        .onDisappear {
                            isVisible = false
                        }
                },
                alignment: edge)
    }
}

// #Preview {
//    // @Previewable @State var existingLogBookEntry = WatchLogBookEntry()
//    @Previewable @State var existingLogBookEntry = UUID()
//    @Previewable @State var isEditing = true
//    @Previewable @State var watchLogEntry: WatchLogEntry = WatchLogEntry()
//
//    let databaseService = DatabaseService()
//    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
//
//    LogBookEntryView(logBookEntryUUID: $existingLogBookEntry, isEditing: $isEditing, watchLogEntry: $watchLogEntry)
//        .environmentObject(viewModel)
//        .environment(BlurSetting())
//        .environment(\.appStyles, StylesLogEntry.shared)
//        // .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
//        .environment(DisplayedLogEntryID())
//        .environmentObject(AppSettings.shared)
// }
