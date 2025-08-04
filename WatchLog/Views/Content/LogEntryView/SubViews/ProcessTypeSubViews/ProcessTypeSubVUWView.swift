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
                .standardInputPadding()
                .standardAdditionalTopPadding()

            animalToggle
        }
        .standardSubSectionContentPadding()
        .disabled(logEntry.isLocked)
    }
}

extension ProcessTypeSubVUWView {
    
    private var licencePlate01: some View {
            FloatingBorderLabelTextField("Kennzeichen ON01", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate01, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, textfieldAutoCapitalization: .characters, limit: 15, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
    }
    
    private var animalToggle: some View {
       HStack(alignment: .center, spacing: 0) {
            Text("Tier am Leben")
               .textLabel(textLabelLevel: TextLabelLevel.sub, isDimmend: !logEntry.processTypeDetails.isAnimaleLiving, disableAnimation: viewIsReadOnly)

           ToggleView(toggleValue: $logEntry.processTypeDetails.isAnimaleLiving, isLocked: logEntry.isLocked, isDimmend: !logEntry.processTypeDetails.isAnimaleLiving, removeAnimation: viewIsReadOnly, toggleType: .sub)
                .disabled(logEntry.isLocked)
            Spacer()
        }
    }
    
    
    
    
}
