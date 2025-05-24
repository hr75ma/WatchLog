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
    
    @State var uuid: UUID = UUID()
    
    //@Environment(\.modelContext) var modelContext
    //@State private var databaseController: DataBaseController = DataBaseController()
    
    var body: some Scene {
        WindowGroup {
            
            //ContentViewTest(exisitingLogBookEntryUUID: $uuid)
            ContentView()
                //.environment(databaseController)
               
        }
        //.environmentObject(viewModel)
        .modelContainer(for: [WatchLogBookYear.self, WatchLogBookMonth.self, WatchLogBookDay.self, WatchLogBookEntry.self])
    
    }
}
