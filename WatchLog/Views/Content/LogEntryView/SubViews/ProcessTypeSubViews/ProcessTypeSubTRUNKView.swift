//
//  ProcessTypeSubTrunkView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubTRUNKView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool
    @Environment(\.appStyles) var appStyles

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            licencePlate01
                .standardInputPadding()
                .standardAdditionalTopPadding()
        }
        .standardSubSectionContentPadding()
        .disabled(logEntry.isLocked)
    }
}

extension ProcessTypeSubTRUNKView {
    private var licencePlate01: some View {

            FloatingBorderLabelTextField("Kennzeichen", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate01, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, textfieldAutoCapitalization: .characters, limit: 15, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))

        
    }
}
