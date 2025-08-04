//
//  ProcessTypeSubKVView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubKVView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool
    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            injueresToggle
                .standardInputPadding()
        }
        .standardSubSectionContentPadding()
        .disabled(logEntry.isLocked)
    }
}

extension ProcessTypeSubKVView {
 
    private var injueresToggle: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Verletztungen")
                .textLabel(textLabelLevel: TextLabelLevel.sub, isDimmend: !logEntry.processTypeDetails.isInjured, disableAnimation: viewIsReadOnly)

            ToggleView(toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked, isDimmend: !logEntry.processTypeDetails.isInjured, removeAnimation: viewIsReadOnly, toggleType: .sub)
             Spacer()
         }
    }
    
}
