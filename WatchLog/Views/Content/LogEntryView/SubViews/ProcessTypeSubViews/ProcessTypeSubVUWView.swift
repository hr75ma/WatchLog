//
//  ProcessTypeSubVUWView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUWView: View {
    
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen")
                    .sectionTextLabelSub(appStyles: appStyles)
                
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextField(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Tier lebt")
                    .sectionTextLabelSub(appStyles: appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $logEntry.processTypeDetails.isInjured)
                    .labelsHidden()
                    .toggleStyle(
                        generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
                    )
                    .frame(height: appStyles.TextFieldHeightSub, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .disabled(logEntry.isLocked)
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))        
        
    }
}
