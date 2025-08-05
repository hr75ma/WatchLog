//
//  WatchLogApp.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftData
import SwiftUI
import TipKit

@main
struct WatchLogApp: App {
    @State private var showSplashView: Bool = true

    var body: some Scene {
        let databaseService = DatabaseService()
        let viewModel = LogEntryViewModel(dataBaseService: databaseService)
        
        
        WindowGroup {
            SplashView()
                .usesAlertController()
        }
        .environmentObject(viewModel)
        .environment(BlurSetting())
        .environment(DisplayedLogEntryID())
        .environment(ExpandContainer())
        .environment(ExpandedRows())
        .environmentObject(AppSettings.shared)
        .environment(ClosedEventFilter())
    }
}

extension EnvironmentValues {
    @Entry var appStyles = StylesLogEntry.shared
    // @Entry var displayedLogEntryUUID = DisplayedLogEntryID()
}
