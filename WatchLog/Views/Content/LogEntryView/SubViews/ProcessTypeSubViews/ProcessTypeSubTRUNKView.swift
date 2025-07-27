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
        }
        .standardEventSubViewPadding()
    }
}

extension ProcessTypeSubTRUNKView {
    
    private var licencePlate01: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Kennzeichen ON01")
                .textLabel(textLabelLevel: TextLabelLevel.subWithWidth, textLebelWidth: 215)
            
            LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit: 10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly)
        }
    }
}
