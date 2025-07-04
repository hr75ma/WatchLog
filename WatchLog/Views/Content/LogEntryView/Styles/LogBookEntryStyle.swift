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
    
    func bottomBorder(_ appStyles: StylesLogEntry) -> some View {
        self
        .overlay(
          Rectangle()
            .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
            .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
          alignment: .bottom
        )
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    func standardSubViewPadding() -> some View {
        self
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    }
    
    
}





// logTime section

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
  @MainActor func LogTimeStyleAndAnimation(_ appStyles: StylesLogEntry) -> some View {
    modifier(TextFormatterStyle(appStyles: appStyles))
  }
}
