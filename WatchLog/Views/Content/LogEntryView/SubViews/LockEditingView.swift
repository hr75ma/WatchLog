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
      .frame(height: appStyles.labelFontSize, alignment: .center)
      .timeSectionPadding()
      .standardBottomBorder(appStyles)
  }
}

extension LockEditingView {

  private var lockSection: some View {

    HStack(alignment: .center) {

      Text(logEntry.isLocked ? "Gesperrt" : "Entsperrt")
        .labelStyle(isLocked: logEntry.isLocked)
        .animation(.easeInOut(duration: 1), value: logEntry.isLocked)

      Toggle("", isOn: $logEntry.isLocked)
        .labelsHidden()
        .toggleStyle(toggleStyleLockImage(isLocked: logEntry.isLocked))
        .disabled(logEntry.isNewEntryLog)
      Spacer()
    }
  }
}
