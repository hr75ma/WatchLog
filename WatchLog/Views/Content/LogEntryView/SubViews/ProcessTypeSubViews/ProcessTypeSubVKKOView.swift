//
//  ProcessTypeSubVKKOView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

    struct ProcessTypeSubVKKOView: View {
        
        @Bindable var logEntry: WatchLogEntry
        @Environment(\.appStyles) var appStyles
        
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 0) {
                    Text("Kennzeichen")
                        .subSectionTextLabel()

                    TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                        .subSectionTextField(text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10, appStyles: appStyles)

                        
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
            }
            .standardEventSubViewPadding()
        }
    }
