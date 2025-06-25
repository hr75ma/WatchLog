//
//  ProcessTypeSubDAUFView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubDAUFView: View {
    
    @Bindable var LogEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen")
                    .sectionTextLabelSub(appStyles: appStyles)
                   
                TextField("", text: $LogEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextField(appStyles: appStyles, text: $LogEntry.processTypeDetails.AccientLicensePlate01, isLocked: LogEntry.isLocked, numberOfCharacters: 10)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}
