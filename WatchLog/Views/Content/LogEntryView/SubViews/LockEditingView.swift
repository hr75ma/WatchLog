//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LockEditingView: View {
  @Bindable var logEntry: WatchLogEntry

  @Environment(\.appStyles) var appStyles

  let locale = Locale.current

  var body: some View {

    lockSection
      .frame(height: appStyles.LabelFontSizeSub, alignment: .center)
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
      .overlay(
        Rectangle()
          .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
          .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
        alignment: .bottom
      )
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
  }
}

extension LockEditingView {

  private var lockSection: some View {

    HStack(alignment: .center) {

      Text(logEntry.isLocked ? "Gesperrt" : "Entsperrt")
        .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize))
        .foregroundStyle(logEntry.isLocked ? appStyles.isLockedColor : appStyles.GeneralTextColor)
        .frame(width: 170, height: appStyles.LabelFontSizeSub, alignment: .leading)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: true)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        .lineSpacing(0)
        .animation(.easeInOut(duration: 1), value: logEntry.isLocked)

        Toggle("", isOn: $logEntry.isLocked)
          .labelsHidden()
          .toggleStyle(
            toggleStyleLockImage(appStyles: appStyles, isLocked: logEntry.isLocked)
          )

        .frame(height: appStyles.LabelFontSizeSub, alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .disabled(logEntry.isNewEntryLog)

      Spacer()
    }
  }
}
