//
//  WatchLogApp.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftUI
import SwiftData

@main
struct WatchLogApp: App {
    
    @State private var showSplashView:Bool = true
    
    
    
    var body: some Scene {
        
        let databaseService = DatabaseService()
        let viewModel = LogEntryViewModel(dataBaseService: databaseService)
        var currentLogEntryUUID:UUIDContainer = UUIDContainer()
        
    
        WindowGroup {
        
                SplashView()
                //ContentView()
        
            
    }
        .environmentObject(viewModel)
        .environmentObject(currentLogEntryUUID)
    
    }
}

extension EnvironmentValues {
    @Entry var appStyles = StylesLogEntry()
    
}
