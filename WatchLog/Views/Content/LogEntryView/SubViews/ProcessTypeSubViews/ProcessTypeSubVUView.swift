//
//  ProcessTypeSubVUView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import SwiftUI

struct ProcessTypeSubVUView: View {

  @Bindable var logEntry: WatchLogEntry
  @Environment(\.appStyles) var appStyles

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack(alignment: .center, spacing: 0) {
        Text("Kennzeichen ON01")
              .textLabel(textLabelLevel: TextLabelLevel.subWithWidth, textLebelWidth: 215)

          LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit:10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate01, isLocked: logEntry.isLocked)
      }

      HStack(alignment: .center, spacing: 0) {
        Text("Kennzeichen ON02")
              .textLabel(textLabelLevel: TextLabelLevel.subWithWidth, textLebelWidth: 215)

          LimitedIndicatorTextField(config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.sub, limit:10, tint: .watchLogFont, autoResizes: true), hint: "", text: $logEntry.processTypeDetails.AccientLicensePlate02, isLocked: logEntry.isLocked)
      }

      HStack(alignment: .center, spacing: 0) {
        Text("Verletzte")
              .textLabel(textLabelLevel: TextLabelLevel.sub)

        ToggleView(
          toggleValue: $logEntry.processTypeDetails.isInjured, isLocked: logEntry.isLocked,
          toggleType: .sub)

        Spacer()

        Text("Flucht")
              .textLabel(textLabelLevel: TextLabelLevel.sub)

        ToggleView(
          toggleValue: $logEntry.processTypeDetails.AccientHitAndRun, isLocked: logEntry.isLocked,
          toggleType: .sub)

        Spacer()

        Text("Alkohol/BtM")
              .textLabel(textLabelLevel: TextLabelLevel.sub)

        ToggleView(
          toggleValue: $logEntry.processTypeDetails.AlcoholConsumed, isLocked: logEntry.isLocked,
          toggleType: .sub)
      }
    }
    .standardEventSubViewPadding()
    .disabled(logEntry.isLocked)
  }

}
