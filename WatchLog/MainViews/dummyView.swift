//
//  dummyView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.06.25.
//

import SwiftUI

struct dummyView: View {
    
    @Bindable public var exisitingLogBookEntry: WatchLogBookEntry
    
    //@EnvironmentObject var viewModel: LogEntryViewModel
    
    
    
    var body: some View {
        
        ScrollView {
            
            Text("Hello, World! \(exisitingLogBookEntry.uuid)")
        }
        
    }
}

//#Preview {
//    dummyView()
//}
