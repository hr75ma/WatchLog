//
//  TabView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.06.25.
//

import SwiftUI

struct TabViewForLogView: View {
    
    @Bindable public var logBookEntry: WatchLogBookEntry
    @Binding public var logEntriesOfDay: [WatchLogBookEntry]
    
    @EnvironmentObject var viewModel: LogEntryViewModel
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    @EnvironmentObject var currentUUID: UUIDContainer

    
    var body: some View {
        TabView {
            
            ForEach(logEntriesOfDay) { logBookEntry in
                
                LogBookEntryView(exisitingLogBookEntry: logBookEntry)
                //dummyView(exisitingLogBookEntry: logBookEntry)
                    .tag(logBookEntry.uuid)
                
            }
                
                
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    
    
}

//#Preview {
//    TabView(LogBookEntry: <#WatchLogBookEntry#>, LogEntriesFromDays: <#Binding<[WatchLogBookEntry]>#>)
//}
