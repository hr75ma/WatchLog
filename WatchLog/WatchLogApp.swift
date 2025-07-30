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
        }
        .environmentObject(viewModel)
        .environment(BlurSetting())
        .environment(DisplayedLogEntryID())
        .environmentObject(AppSettings.shared)
    }
}

extension EnvironmentValues {
    @Entry var appStyles = StylesLogEntry.shared
    // @Entry var displayedLogEntryUUID = DisplayedLogEntryID()
}
