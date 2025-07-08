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
  case menu
}

@ViewBuilder func NavigationToolbarItemImage(
  toolbarItemType: NavigationToolbarItemType, appStyles: StylesLogEntry
) -> some View {

  switch toolbarItemType {
  case .addEntry:
    NavigationToolbarAddEntryImage(appStyles: appStyles)
  case .settings:
    NavigationToolbarSettingsImage(appStyles: appStyles)
  case .menu:
    NavigationToolbarMenuImage(appStyles: appStyles)
  }

}

struct NavigationToolbarAddEntryImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.navigationAddImage)
      .navigationToolBarSymbolModifier(appStyles: appStyles)
      .foregroundStyle(
        .watchLogNavigationTreeAddEntryImagePrimary, .watchLogNavigationTreeAddEntryImageSecondary
      )
  }
}

struct NavigationToolbarSettingsImage: View {
  let appStyles: StylesLogEntry

  var body: some View {

    Image(systemName: appStyles.navigationSettingImage)
      .navigationToolBarSymbolModifier(appStyles: appStyles)
      .foregroundStyle(
        .watchLogNavigationTreeSettingImagePrimary, .watchLogNavigationTreeSettingImageSecondary
      )
  }
}

struct NavigationToolbarMenuImage: View {
  let appStyles: StylesLogEntry

  var body: some View {
    Image(systemName: appStyles.navigationMenuImage)
      .navigationToolBarSymbolModifier(appStyles: appStyles)
      .foregroundStyle(
        .watchLogToolBarContextColorActivePrimary, .watchLogToolBarContextColorActiveSecondary
      )
  }
}
