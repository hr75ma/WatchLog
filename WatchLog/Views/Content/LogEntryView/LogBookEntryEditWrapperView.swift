//
//  LogBookEntryWrapperView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.07.25.
//

import SwiftUI

struct LogBookEntryEditWrapperView: View {

    //@Binding public var logBookEntryUUID: UUID
    @State public var watchLogEntry: WatchLogEntry
    //@State private var watchLogEntry: WatchLogEntry = .init()
    @EnvironmentObject var viewModel: LogEntryViewModel

    @Environment(\.appStyles) var appStyles
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(BlurSetting.self) var blurSetting
    @Environment(\.dismiss) var dismiss

    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false
    
    @State var scale = 0.0
        @State var opacity = 0.0
    @State var oset = 0.0
    
    let viewIsReadOnly: Bool = false

    
    var body: some View {
       // GeometryReader { proxy in
            
            HStack {
                LogBookEntryView(watchLogEntry: $watchLogEntry,viewIsReadOnly: viewIsReadOnly)

            }
        .safeAreaInsetForToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    blurSetting.isBlur = false
                    dismiss()
                } label: {
                    NavigationToolbarItemImage(toolbarItemType: .back, appStyles: appStyles)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Text(watchLogEntry.isLocked ? "Eintrag Ansicht (gesperrt)" :"Eintrag bearbeiten")
                    .navigationTitleModifier()
                    .contentTransition(.numericText())
                    .animation(.smooth(duration: 1), value: watchLogEntry.isLocked)
            }
            
            
            ToolbarItem(placement: .primaryAction) {
                MenuButton
            }
        }
        .toolbarModifier() 
        .blurring(blurSetting: blurSetting)
    }
}

extension LogBookEntryEditWrapperView {
    
    var MenuButton: some View {
            Menu {
                
                    if !watchLogEntry.isLocked {
                        Button {
                            watchLogEntry.remoteSignalContainer.signale = .save
                            blurSetting.isBlur = false
                        } label: {
                            NavigationMenuLabelView(menuItemType: MenuType.save)
                        }
                    }
                    Divider()
                    
                    Button(role: .destructive) {
                        blurSetting.isBlur = true
                        alertDelete.toggle()
                    } label: {
                        NavigationMenuLabelView(menuItemType: MenuType.delete)
                    }
            }
            label: {
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
