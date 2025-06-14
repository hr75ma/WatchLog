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
          
          Text(LogEntry.isLocked ? "Gesperrt" : "Entsperrt")
              .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize2))
              .foregroundStyle(LogEntry.isLocked ? GeneralStyles.isLockedColor : GeneralStyles.GeneralTextColor)
              .frame(width: 170, height: GeneralStyles.LabelFontSize2, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
              .fixedSize(horizontal: true, vertical: true)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
              .lineSpacing(0)
              .animation(.easeInOut(duration: 1), value: LogEntry.isLocked)
              
          
          Toggle("", isOn: $LogEntry.isLocked)
              .labelsHidden()
              .toggleStyle(ToggleStyleImage(
                isOnImage: GeneralStyles.LockImageisLocked,
                isOffImage: GeneralStyles.LockImageisUnLocked,
                isOnColorPrimary: GeneralStyles.LockColorIsLockedPrimary,
                isOnColorSecondary: GeneralStyles.LockColorIsLockedSecondary,
                isOffColorPrimary: GeneralStyles.LockColorIsUnLockedPrimary,
                isOffColorSecondary: GeneralStyles.LockColorIsUnLockedSecondary
                ))
              .frame(height: GeneralStyles.LabelFontSize2, alignment: .center)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

      Spacer()
    }
      .frame(height: GeneralStyles.LabelFontSize2, alignment: .center)
     
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}
