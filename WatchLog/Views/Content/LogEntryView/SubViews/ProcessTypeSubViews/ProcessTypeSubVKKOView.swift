//
//  ProcessTypeSubVKKOView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubVKKOView: View {
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

extension ProcessTypeSubVKKOView {
    private var licencePlate01: some View {
            FloatingBorderLabelTextField("Kennzeichen ON01", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate01, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, textfieldAutoCapitalization: .characters, limit: 15, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))

    }
}
