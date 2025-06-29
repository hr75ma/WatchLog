//
//  ProcessTypeSubDAUFView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubDAUFView: View {
    
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen")
                    .sectionTextLabelSub(appStyles: appStyles)
                   
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextFieldSubSection(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}
