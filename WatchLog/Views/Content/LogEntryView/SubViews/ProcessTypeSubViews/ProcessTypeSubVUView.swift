//
//  ProcessTypeSubVUView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUView: View {
    
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON01")
                    .sectionTextLabelSubWidth(appStyles: appStyles, width: 215)
                
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextFieldSubSection(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON02")
                    .sectionTextLabelSubWidth(appStyles: appStyles, width: 215)
                
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate02)
                    .sectionTextFieldSubSection(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate02, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Verletzte")
                    .subSectionTextLabel()
                
                ToggleView(toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked, toggleType: .sub)
                
                Spacer()
                
                Text("Flucht")
                    .subSectionTextLabel()
                
                ToggleView(toggleValue: $logEntry.processTypeDetails.AccientHitAndRun, isLocked: logEntry.isLocked, toggleType: .sub)
                
                Spacer()
                
                Text("Alkohol/BtM")
                    .subSectionTextLabel()
                
                ToggleView(toggleValue: $logEntry.processTypeDetails.AlcoholConsumed, isLocked: logEntry.isLocked, toggleType: .sub)

            }
        }
        .standardEventSubViewPadding()
        .disabled(logEntry.isLocked)
    }

}
