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
    
    @State private var selectedTab:UUID = UUID()

    
    var body: some View {
        TabView(selection: $selectedTab) {
            
//            if logEntriesOfDay.isEmpty {
//                LogBookEntryView(exisitingLogBookEntry: logBookEntry, logEntriesOfDay: $logEntriesOfDay)
//            } else {
//                ForEach(logEntriesOfDay) { logBookEntry in
//                    
//                    LogBookEntryView(exisitingLogBookEntry: logBookEntry, logEntriesOfDay: $logEntriesOfDay)
//                    //dummyView(exisitingLogBookEntry: logBookEntry)
//                        .tag(logBookEntry.uuid)
//                        
//                    
//                }
//            }
            
                
                
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onAppear() {
            selectedTab = logBookEntry.uuid
        }
        .onChange(of: logBookEntry.uuid) {
            selectedTab = logBookEntry.uuid
        }
    }
    
    private func handleSwipe(translation: CGFloat) {
        print("handling swipe! horizontal translation was \(translation)")
    }
    
}

//#Preview {
//    TabView(LogBookEntry: <#WatchLogBookEntry#>, LogEntriesFromDays: <#Binding<[WatchLogBookEntry]>#>)
//}
