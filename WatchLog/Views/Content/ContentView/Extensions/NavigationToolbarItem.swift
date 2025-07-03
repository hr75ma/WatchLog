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
  toolbarItem: NavigationToolbarItemType, appStyles: StylesLogEntry
) -> some View {

  switch toolbarItem {
  case .addEntry:
    NavigationToolbarAddEntryImage(appStyles: appStyles)
  case .settings:
    NavigationToolbarSettingsImage(appStyles: appStyles)
  }

}

struct NavigationToolbarAddEntryImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.NavigationTreeAddEntryImage)
      //.ToolbarImageStyle(appStyles)
      .symbolRenderingMode(.palette)
      .foregroundStyle(
        appStyles.NavigationTreeAddEntryImagePrimaryColor,
        appStyles.NavigationTreeAddEntryImageSecondaryColor
      )
      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      .symbolEffect(.scale)
  }
}

struct NavigationToolbarSettingsImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.NavigationTreeSettingImage)
      .symbolRenderingMode(.palette).foregroundStyle(
        appStyles.NavigationTreeSettingImagePrimaryColor,
        appStyles.NavigationTreeAddEntryImageSecondaryColor
      )
      .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2))
      .symbolEffect(.scale)
  }
}
