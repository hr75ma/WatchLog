//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LockedView: View {
  @Bindable var LogEntry: WatchLogEntry

  @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry

  let locale = Locale.current

  var body: some View {
      HStack(alignment: .center) {
          
          Text(LogEntry.isLocked ? "Entsperren" : "Sperren")
              .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize2))
              .foregroundStyle(GeneralStyles.GeneralTextColor)
              .frame(width: 170, height: GeneralStyles.LabelFontSize2, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
              .fixedSize(horizontal: true, vertical: true)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
              .lineSpacing(0)
          
          Toggle("", isOn: $LogEntry.isLocked)
              .labelsHidden()
              .toggleStyle(ToggleStyleLockStyleImage(isOffImage: GeneralStyles.isUnLockImage, isOnImage: GeneralStyles.isLockImage))
              .frame(height: 25, alignment: .center)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

      Spacer()
    }
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}
