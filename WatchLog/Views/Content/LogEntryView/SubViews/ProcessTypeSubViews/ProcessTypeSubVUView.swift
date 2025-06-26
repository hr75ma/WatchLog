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
                    .sectionTextLabelSubWidth(appStyles: appStyles)
                
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate01)
                    .sectionTextField(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON02")
                    .sectionTextLabelSubWidth(appStyles: appStyles)
                
                TextField("", text: $logEntry.processTypeDetails.AccientLicensePlate02)
                    .sectionTextField(appStyles: appStyles, text: $logEntry.processTypeDetails.AccientLicensePlate02, isLocked: logEntry.isLocked, numberOfCharacters: 10)
                    
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Verletzte")
                    .sectionTextLabelSub(appStyles: appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $logEntry.processTypeDetails.isInjured, )
                  .labelsHidden()
                  .toggleStyle(
                    generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
                  )
                  .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                  .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                  
                
                Spacer()
                
                Text("Flucht")
                    .sectionTextLabelSub(appStyles: appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $logEntry.processTypeDetails.AccientHitAndRun)
                    .labelsHidden()
                    .toggleStyle(
                        generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
                    )
                    .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                Text("Alkohol/BtM")
                    .sectionTextLabelSub(appStyles: appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $logEntry.processTypeDetails.AlcoholConsumed)
                    .labelsHidden()
                    .toggleStyle(
                        generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
                    )
                    .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        .disabled(logEntry.isLocked)
    }

}
