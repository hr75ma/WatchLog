//
//  ProcessTypeSubVUWView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUWView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool
    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            licencePlate01

            animalToggle
        }
        .standardEventSubViewPadding()
    }
}

extension ProcessTypeSubVUWView {
    
    private var licencePlate01: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Kennzeichen ON01")
                .textLabel(textLabelLevel: TextLabelLevel.subWithWidth, textLebelWidth: 215)

            LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit: 10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly)
        }
    }
    
    private var animalToggle: some View {
       HStack(alignment: .center, spacing: 0) {
            Text("Tier am Leben")
                .textLabel(textLabelLevel: TextLabelLevel.sub)

           ToggleView(toggleValue: $logEntry.processTypeDetails.isAnimaleLiving, isLocked: logEntry.isLocked, removeAnimation: viewIsReadOnly, toggleType: .sub)
                .disabled(logEntry.isLocked)
            Spacer()
        }
    }
    
    
    
    
}
