//
//  ProcessTypeSubVKKOView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

    struct ProcessTypeSubVKKOView: View {
        
        @Bindable var LogEntry: WatchLogEntry
        @Environment(\.appStyles) var appStyles
        
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 0) {
                    Text("Kennzeichen")
                        .SectionTextLabelSecond(appStyles)
                        .frame(height: appStyles.TextFieldHeight2, alignment: .topLeading)
                    
                    TextField("", text: $LogEntry.processTypeDetails.AccientLicensePlate01)
                        .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
                        .limitInputLength(text: $LogEntry.processTypeDetails.AccientLicensePlate01, length: 10)
                        .showClearButton($LogEntry.processTypeDetails.AccientLicensePlate01)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)
        }
    }
