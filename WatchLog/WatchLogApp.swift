//
//  WatchLogApp.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct WatchLogApp: App {
    
    @State private var showSplashView:Bool = true
    
    
    
    var body: some Scene {
        
        let databaseService = DatabaseService()
        let viewModel = LogEntryViewModel(dataBaseService: databaseService)
        
        WindowGroup {
        
                SplashView()
                .task {
                    try? Tips.configure([
                        //.displayFrequency(.immediate)
                        .datastoreLocation(.applicationDefault)
 
                    ])
                }
                //ContentView()
    }
        .environmentObject(viewModel)
        .environment(BlurSetting())
        .environment(DisplayedLogEntryID())

    
    }
}

extension EnvironmentValues {
    @Entry var appStyles = StylesLogEntry.shared
    //@Entry var displayedLogEntryUUID = DisplayedLogEntryID()
    
    
}
