//
//  ProcessTypeSubDAUFView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.06.25.
//

import SwiftUI

struct ProcessTypeSubDAUFView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool
    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                Text("Kennzeichen")
                    .textLabel(textLabelLevel: TextLabelLevel.sub)

                LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit: 10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly)
                // .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
            }
        }
        .standardEventSubViewPadding()
    }
}
