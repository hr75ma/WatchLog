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
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen")
                    .textLabel(textLabelLevel: TextLabelLevel.sub)

                LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit: 10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly)
            }

            HStack(alignment: .center, spacing: 0) {
                Text("Tier lebt")
                    .textLabel(textLabelLevel: TextLabelLevel.sub)

                ToggleView(toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked, removeAnimation: viewIsReadOnly, toggleType: .sub)
                    .disabled(logEntry.isLocked)
                Spacer()
            }
        }
        .standardEventSubViewPadding()
    }
}
