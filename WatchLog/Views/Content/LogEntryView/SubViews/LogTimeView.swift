//
//  DateAndTimeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LogTimeView: View {
    var LogTime: Date
    
    let color = [Color.blue, Color.yellow, Color.blue]
    @State private var colorIndex: Int = 0
    @State var time: Date = .now
    let duration: TimeInterval = 1
    
    @Environment(\.appStyles) var appStyles

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {
        Text(LogTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
            .TextStyleAndAnimation(appStyles)
      Spacer()
        Text(LogTime.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
            .TextStyleAndAnimation(appStyles)
      Spacer()
      Text(LogTime.formatted(.dateTime.hour().minute().second()))
            .TextStyleAndAnimation(appStyles)
        

        
    }
    .animation(.default, value: LogTime)
    
    //.border(.cyan)
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}

fileprivate struct TextFormatterStyle: ViewModifier {
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
