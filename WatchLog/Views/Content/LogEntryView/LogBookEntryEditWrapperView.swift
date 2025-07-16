//
//  LogBookEntryWrapperView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.07.25.
//

import SwiftUI

struct LogBookEntryEditWrapperView: View {

    @Binding public var logBookEntryUUID: UUID
    @Binding public var isEditing: Bool
    @Binding var watchLogEntry: WatchLogEntry
    @EnvironmentObject var viewModel: LogEntryViewModel

    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(BlurSetting.self) var blurSetting
    @Environment(\.dismiss) var dismiss

    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false

    
    var body: some View {
        HStack {
            LogBookEntryView(watchLogEntry: $watchLogEntry, isEditing: $isEditing)
        }
        .onAppear{
            Task {
                print("onappear Edit - \(logBookEntryUUID.uuidString)")
                watchLogEntry = await viewModel.fetchLogEntryMod(LogEntryUUID: logBookEntryUUID)
                watchLogEntry.isLocked = isEditing ? false : true
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                    blurSetting.isBlur = false
                    dismiss()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.back)
                }
                
                Text("Eintrag")
                    .navigationTitleModifier()
            }
            
            ToolbarItem(placement: .primaryAction) {
                MenuButton
            }
        }
        .blurring(blurSetting: blurSetting)
    }
}

extension LogBookEntryEditWrapperView {
    
    var MenuButton: some View {
        Menu {
            //if !watchLogEntry.isLocked {
                Button {
                    watchLogEntry.remoteSignalContainer.signale = .save
                    blurSetting.isBlur = false
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.save)
                }

                Divider()

                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    alertDelete.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.delete)
                }
            
        } label: {
            NavigationToolbarItemImage(toolbarItemType: .menu, appStyles: appStyles)
        }
        .alert("Log Löschen?", isPresented: $alertDelete) {
            Button(
                "Löschen", role: .destructive,
                action: {
                    watchLogEntry.remoteSignalContainer.signale = .delete
                    blurSetting.isBlur = false
                    dismiss()
                })
            cancelAlertButton()
        }
        
    }
    
    private func cancelAlertButton() -> Button<Text> {
        return Button(
            "Abbrechen", role: .cancel,
            action: {
                blurSetting.isBlur = false
            })
    }

    
    
}


//#Preview {
//    // @Previewable @State var existingLogBookEntry = WatchLogBookEntry()
//    @Previewable @State var existingLogBookEntry = UUID()
//    @Previewable @State var isEditing = true
//    @Previewable @State var watchLogEntry: WatchLogEntry = WatchLogEntry()
//
//    let databaseService = DatabaseService()
//    let viewModel = LogEntryViewModel(dataBaseService: databaseService)
//
//    LogBookEntryWrapperView(logBookEntryUUID: $existingLogBookEntry, isEditing: $isEditing, watchLogEntry: $watchLogEntry)
//        .environmentObject(viewModel)
//        .environment(BlurSetting())
//        .environment(\.appStyles, StylesLogEntry.shared)
//        // .environment(\.displayedLogEntryUUID, DisplayedLogEntryID())
//        .environment(DisplayedLogEntryID())
//        .environmentObject(AppSettings.shared)
//}
