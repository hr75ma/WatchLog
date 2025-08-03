//
//  ProcessTypeSubVUView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool
    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            licencePlate01
                .standardInputPadding()
            licencePlate02
                .standardInputPadding()
            miscToggle
                .standardInputPadding()
        }
    
        .disabled(logEntry.isLocked)
    }
}

extension ProcessTypeSubVUView {
    private var licencePlate01: some View {

            FloatingBorderLabelTextField("Kennzeichen ON01", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate01, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, textfieldAutoCapitalization: .characters, limit: 15, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
        }



    private var licencePlate02: some View {

            FloatingBorderLabelTextField("Kennzeichen ON02", textfieldContent: $logEntry.processTypeDetails.AccientLicensePlate02, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, textfieldAutoCapitalization: .characters, limit: 15, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))

    }

    private var miscToggle: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack {
                Text("Verletztungen")
                    .textLabel(textLabelLevel: TextLabelLevel.sub, isDimmend: !logEntry.processTypeDetails.isInjured, disableAnimation: viewIsReadOnly)

                ToggleView(
                    toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked, isDimmend: !logEntry.processTypeDetails.isInjured, removeAnimation: viewIsReadOnly, toggleType: .sub)
            }
            Spacer()

            VStack {
                Text("Flucht")
                    .textLabel(textLabelLevel: TextLabelLevel.sub, isDimmend: !logEntry.processTypeDetails.AccientHitAndRun, disableAnimation: viewIsReadOnly)

                ToggleView(
                    toggleValue: $logEntry.processTypeDetails.AccientHitAndRun, isLocked: logEntry.isLocked, isDimmend: !logEntry.processTypeDetails.AccientHitAndRun, removeAnimation: viewIsReadOnly, toggleType: .sub)
            }
            Spacer()

            VStack {
                Text("Alkohol/BtM")
                    .textLabel(textLabelLevel: TextLabelLevel.sub, isDimmend: !logEntry.processTypeDetails.AlcoholConsumed, disableAnimation: viewIsReadOnly)

                ToggleView(
                    toggleValue: $logEntry.processTypeDetails.AlcoholConsumed, isLocked: logEntry.isLocked, isDimmend: !logEntry.processTypeDetails.AlcoholConsumed, removeAnimation: viewIsReadOnly, toggleType: .sub)
            }
        }
    }
}
