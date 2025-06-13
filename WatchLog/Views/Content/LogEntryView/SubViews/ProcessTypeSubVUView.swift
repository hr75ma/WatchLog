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
                
                TextField("", text: $LogEntry.AccientLicensePlate01)
                    .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
                    .limitInputLength(text: $LogEntry.AccientLicensePlate01, length: 10)
                    .showClearButton($LogEntry.AccientLicensePlate01)
                    .disabled(LogEntry.isLocked)
                
            }
            //.transition(.opacity)
            //.animation(.easeInOut(duration: 1), value: isAccientHidden)
            //.isHidden(!LogEntry.isAccient, remove: true)
            
            
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen ON02")
                    .SectionTextLabelSecond(appStyles)
                    .frame(width: 215, height: appStyles.TextFieldHeight2, alignment: .topLeading)
                
                TextField("", text: $LogEntry.AccientLicensePlate02)
                    .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
                    .limitInputLength(text: $LogEntry.AccientLicensePlate02, length: 10)
                    .showClearButton($LogEntry.AccientLicensePlate02)
                    .disabled(LogEntry.isLocked)
                
            }
            //.isHidden(!LogEntry.isAccient, remove: true)
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Text("Verletzte")
                    .SectionTextLabelSecond(appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $LogEntry.isInjured)
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
                    .disabled(LogEntry.isLocked)
                
                Spacer()
                
                Text("Verkehrsunfallflucht")
                    .SectionTextLabelSecond(appStyles)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                Toggle("", isOn: $LogEntry.AccientHitAndRun)
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
                    .disabled(LogEntry.isLocked)
            }
            
            //        .isHidden(!LogEntry.isAccient, remove: true)
        }
    }
}
