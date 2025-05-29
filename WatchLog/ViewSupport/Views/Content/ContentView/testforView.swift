//
//  testView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 28.05.25.
//

import SwiftUI
import SwiftData


    
    

struct testforView: View {
    @Bindable public var entry: WatchLogBookEntry
    //@Binding public var idif: Int
    
   // @EnvironmentObject var viewModel: LogEntryViewModel
   // @State private var id: String = ""
    
    
    var body: some View {
        Text(Date.now, format: .dateTime.hour().minute().second())
         Text(entry.uuid.uuidString)
        //Text("\(idif)")
    }
        
}

