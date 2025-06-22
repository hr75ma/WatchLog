//
//  DateAndTimeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LogTimeView: View {
  var logTime: Date

  @State var time: Date = .now
  @Environment(\.appStyles) var appStyles

  let locale = Locale.current

  var body: some View {

    logTimeSection
      .animation(.default, value: logTime)
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
      .overlay(
        Rectangle()
          .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
          .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
        alignment: .bottom
      )
  }
}

extension LogTimeView {

  private var logTimeSection: some View {
    HStack(alignment: .center) {
      Text(logTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
        .TextStyleAndAnimation(appStyles)
      Spacer()
      Text(logTime.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
        .TextStyleAndAnimation(appStyles)
      Spacer()
      Text(logTime.formatted(.dateTime.hour().minute().second()))
        .TextStyleAndAnimation(appStyles)
    }
  }
}

private struct TextFormatterStyle: ViewModifier {
  let stylesLogEntry: StylesLogEntry
  func body(content: Content) -> some View {
    content
      .font(Font.custom(stylesLogEntry.LabelFont, size: stylesLogEntry.LabelFontSize))
      .foregroundStyle(stylesLogEntry.GeneralTextColor)
      .contentTransition(.numericText())
  }
}

extension Text {
  @MainActor fileprivate func TextStyleAndAnimation(_ stylesLogEntry: StylesLogEntry) -> some View {
    modifier(TextFormatterStyle(stylesLogEntry: stylesLogEntry))
  }
}
