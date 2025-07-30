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
            
            FloatingBorderLabelTextField("Kennzeichen ON01", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit: 15, tint: .watchLogFont, autoResizes: true, textfieldAutoCapitalization: .characters))
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
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
