//
//  ProcessTypeSubVUView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUView: View {
    
    @Bindable var LogEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON01")
                    .SectionTextLabelSecond(appStyles)
                    .frame(width: 215, height: appStyles.TextFieldHeight2, alignment: .topLeading)
                
                TextField("", text: $LogEntry.processTypeDetails.AccientLicensePlate01)
                    .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
                    .limitInputLength(text: $LogEntry.processTypeDetails.AccientLicensePlate01, length: 10)
                    .showClearButton($LogEntry.processTypeDetails.AccientLicensePlate01)
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON02")
                    .SectionTextLabelSecond(appStyles)
                    .frame(width: 215, height: appStyles.TextFieldHeight2, alignment: .topLeading)
                
                TextField("", text: $LogEntry.processTypeDetails.AccientLicensePlate02)
                    .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
                    .limitInputLength(text: $LogEntry.processTypeDetails.AccientLicensePlate02, length: 10)
                    .showClearButton($LogEntry.processTypeDetails.AccientLicensePlate02)
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("Verletzte")
                    .SectionTextLabelSecond(appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $LogEntry.processTypeDetails.isInjured)
                    .labelsHidden()
                    .toggleStyle(
                      ToggleStyleImage(
                          isOnImage: appStyles.AccidentImageisLocked,
                          isOffImage: appStyles.AccidentImageisUnLocked,
                          isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
                          isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
                          isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
                          isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
                          isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
                      )
                    )
                    .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                Text("Verkehrsunfallflucht")
                    .SectionTextLabelSecond(appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $LogEntry.processTypeDetails.AccientHitAndRun)
                    .labelsHidden()
                    .toggleStyle(
                      ToggleStyleImage(
                          isOnImage: appStyles.AccidentImageisLocked,
                          isOffImage: appStyles.AccidentImageisUnLocked,
                          isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
                          isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
                          isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
                          isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
                          isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
                      )
                    )
                    .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                Text("Alkohol/BtM")
                    .SectionTextLabelSecond(appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $LogEntry.processTypeDetails.AlcoholConsumed)
                    .labelsHidden()
                    .toggleStyle(
                      ToggleStyleImage(
                          isOnImage: appStyles.AccidentImageisLocked,
                          isOffImage: appStyles.AccidentImageisUnLocked,
                          isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
                          isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
                          isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
                          isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
                          isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
                      )
                    )
                    .frame(height: appStyles.TextFieldHeight2, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .disabled(LogEntry.isLocked)
    }

}
