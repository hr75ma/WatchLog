//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LockedView: View {
  @Bindable var LogEntry: WatchLogEntry

    @Environment(\.appStyles) var appStyles

  let locale = Locale.current

  var body: some View {
      HStack(alignment: .center) {
          
          Text(LogEntry.isLocked ? "Gesperrt" : "Entsperrt")
              .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize2))
              .foregroundStyle(LogEntry.isLocked ? appStyles.isLockedColor : appStyles.GeneralTextColor)
              .frame(width: 170, height: appStyles.LabelFontSize2, alignment: .leading)
              .multilineTextAlignment(.leading)
              .lineLimit(1)
              .fixedSize(horizontal: true, vertical: true)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
              .lineSpacing(0)
              .animation(.easeInOut(duration: 1), value: LogEntry.isLocked)
              
          
          Toggle("", isOn: $LogEntry.isLocked)
              .labelsHidden()
              .toggleStyle(ToggleStyleImage(
                isOnImage: appStyles.LockImageisLocked,
                isOffImage: appStyles.LockImageisUnLocked,
                isOnColorPrimary: appStyles.LockColorIsLockedPrimary,
                isOnColorSecondary: appStyles.LockColorIsLockedSecondary,
                isOffColorPrimary: appStyles.LockColorIsUnLockedPrimary,
                isOffColorSecondary: appStyles.LockColorIsUnLockedSecondary
                ))
              .frame(height: appStyles.LabelFontSize2, alignment: .center)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
              .disabled(LogEntry.isNewEntryLog)

      Spacer()
    }
      .frame(height: appStyles.LabelFontSize2, alignment: .center)
     
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}
