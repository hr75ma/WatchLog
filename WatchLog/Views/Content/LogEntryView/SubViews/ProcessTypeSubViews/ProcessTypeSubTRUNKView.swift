//
//  ProcessTypeSubTrunkView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubTRUNKView: View {
    
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON01")
                    .subSectionTextWidthLabel(width: 215)
                    
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextField(text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10, appStyles: appStyles)
                   
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}

