//
//  NavigationTreeExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 03.07.25.
//

import Foundation
import SwiftUI

enum NavigationToolbarItemType {
  case addEntry
  case settings
}

@ViewBuilder func NavigationToolbarItemImage(
  toolbarItemType: NavigationToolbarItemType, appStyles: StylesLogEntry
) -> some View {

  switch toolbarItemType {
  case .addEntry:
    NavigationToolbarAddEntryImage(appStyles: appStyles)
  case .settings:
    NavigationToolbarSettingsImage(appStyles: appStyles)
  }

}

struct NavigationToolbarAddEntryImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.navigationTreeAddEntryImage)
      .symbolRenderingMode(.palette)
      .foregroundStyle(
        appStyles.navigationTreeAddEntryImagePrimaryColor,
        appStyles.navigationTreeAddEntryImageSecondaryColor
      )
      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      .symbolEffect(.scale)
  }
}

struct NavigationToolbarSettingsImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.navigationTreeSettingImage)
      .symbolRenderingMode(.palette).foregroundStyle(
        appStyles.navigationTreeSettingImagePrimaryColor,
        appStyles.navigationTreeAddEntryImageSecondaryColor
      )
      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      .symbolEffect(.scale)
  }
}
