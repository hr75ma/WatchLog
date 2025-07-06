//
//  LogBookEntryStyle.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.07.25.
//

import Foundation
import SwiftUI

//general section

extension View {

  func standardBottomBorder(_ appStyles: StylesLogEntry) -> some View {
    self
      .overlay(
        Rectangle()
          .frame(height: appStyles.standardInnerFrameBorderWidth)  // Border thickness
          .foregroundColor(appStyles.standardFrameColor),  // Border color
        alignment: .bottom
      )
      .cornerRadius(10)
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
  }

  func standardSubViewPadding() -> some View {
    self
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
  }
}

// logTime section

extension View {
  func timeSectionPadding() -> some View {
    self
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))

  }
}

struct TextFormatterStyle: ViewModifier {
  let appStyles: StylesLogEntry
  func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.logTimeFont, size: appStyles.logTimeFontSize))
      .foregroundStyle(appStyles.standardFontColor)
      .contentTransition(.numericText())
  }
}

extension Text {
  @MainActor func logTimeStyleAndAnimation(_ appStyles: StylesLogEntry) -> some View {
    modifier(TextFormatterStyle(appStyles: appStyles))
  }
}

//locked section
