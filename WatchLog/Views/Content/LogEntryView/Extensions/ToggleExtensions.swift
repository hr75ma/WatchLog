//
//  ToggleExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

struct toggleStyleLockImage: ToggleStyle {
  var isLocked: Bool = false
  let appStyles: StylesLogEntry

  func makeBody(configuration: toggleStyleLockImage.Configuration) -> some View {

    ZStack(alignment: .center) {
      Image(
        systemName: configuration.isOn ? appStyles.LockImageisLocked : appStyles.lockImageIsUnLocked
      )
      .symbolRenderingMode(.palette)
      .resizable()
      .scaledToFit()
      .foregroundStyle(
        configuration.isOn
          ? appStyles.lockColorIsLockedPrimary : appStyles.lockColorIsUnLockedPrimary,
        configuration.isOn
          ? appStyles.lockColorIsLockedSecondary : appStyles.lockColorIsUnLockedSecondary
      )
      .animation(.easeInOut(duration: 1), value: configuration.isOn)
      .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: configuration.isOn)
      .symbolEffect(
        .rotate.clockwise.byLayer, options: .nonRepeating, isActive: !configuration.isOn
      )
      .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
    .animation(.easeInOut(duration: 1), value: isLocked)
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    .onTapGesture {
      configuration.$isOn.wrappedValue.toggle()
    }
  }
}
