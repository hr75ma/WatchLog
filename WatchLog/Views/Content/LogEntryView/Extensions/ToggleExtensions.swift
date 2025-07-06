//
//  ToggleExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

struct toggleStyleLockImage: ToggleStyle {
  var isLocked: Bool = false
  @Environment(\.appStyles) var appStyles

  func makeBody(configuration: toggleStyleLockImage.Configuration) -> some View {

    ZStack(alignment: .center) {
      Image(
        systemName: configuration.isOn ? appStyles.lockImageIsLocked : appStyles.lockImageIsUnLocked
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

      //.animation(.easeInOut(duration: 1), value: configuration.isOn)
      // .scaleEffect(x: isLocked ? -1:1, y: 1).transaction { transaction in
      //     transaction.animation = nil
      // }
      .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: configuration.isOn)
      .symbolEffect(
        .rotate.clockwise.byLayer, options: .nonRepeating, isActive: !configuration.isOn
      )
      .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
    .animation(.easeInOut(duration: 1), value: isLocked)
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    .frame(height: appStyles.labelFontSize, alignment: .center)
    .onTapGesture {
      configuration.$isOn.wrappedValue.toggle()
    }
  }
}

struct standardToggleStyleImage: ToggleStyle {
  var isLocked: Bool = false
  @Environment(\.appStyles) var appStyles

  func makeBody(configuration: standardToggleStyleImage.Configuration) -> some View {

    ZStack(alignment: .center) {
      Image(
        systemName: configuration.isOn
          ? appStyles.standardToggleIsActiveImage : appStyles.standardToggleIsUnactiveImage
      )
      .symbolRenderingMode(.palette)
      .resizable()
      .scaledToFit()
      .foregroundStyle(
        configuration.isOn
          ? isLocked ? appStyles.standardToogleIsLockedColor : appStyles.standardToggleIsActivePrimary
          : appStyles.standardToggleIsUnactivePrimary,
        configuration.isOn
          ? appStyles.standardToggleIsActiveSecondary : appStyles.standardToggleIsUnactiveSecondary
      )
      //.animation(.easeInOut(duration: 1), value: configuration.isOn)
      .symbolEffect(
        .breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: configuration.isOn
      )
      .symbolEffect(
        .breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !configuration.isOn
      )
      .symbolEffect(.scale)
      .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
    }
    .animation(.easeInOut(duration: 1), value: isLocked)
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    .labelsHidden()
    .onTapGesture {
      configuration.$isOn.wrappedValue.toggle()
    }

  }
}
