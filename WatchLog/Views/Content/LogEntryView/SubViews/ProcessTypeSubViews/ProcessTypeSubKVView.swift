//
//  ProcessTypeSubKVView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubKVView: View {
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text("Verletzte")
                        .textLabel(textLabelLevel: TextLabelLevel.sub)

                    ToggleView(toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked, toggleType: .sub)
                    Spacer()
                }
            }
            .standardEventSubViewPadding()
            .disabled(logEntry.isLocked)
        }
    }
}
