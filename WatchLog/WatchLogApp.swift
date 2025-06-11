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
        let textFieldStyleLogEntry = GeneralStylesLogEntry()
        var currentLogEntryUUID:UUIDContainer = UUIDContainer()
        var logsOfCurrentDay: LogsOfCurrentDay = LogsOfCurrentDay()
        
            
        WindowGroup {
        
                SplashView()
                //ContentView()
        
            
    }
        .environmentObject(viewModel)
        .environmentObject(textFieldStyleLogEntry)
        .environmentObject(currentLogEntryUUID)
        .environment(logsOfCurrentDay)
    
    }
}
