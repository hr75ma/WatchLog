//
//  DateAndTimeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LogTimeView: View {
    var LogTime: Date
    
    @EnvironmentObject var textStyles: GeneralStylesLogEntry

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {
        Text(LogTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
            .TextStyleAndAnimation(textStyles)
        
      Spacer()
      Text(LogTime.formatted(.dateTime.day().month(.defaultDigits).year()))
            .TextStyleAndAnimation(textStyles)
        
      Spacer()
      Text(LogTime.formatted(.dateTime.hour().minute().second()))
            .TextStyleAndAnimation(textStyles)
        
    }
    .animation(.default, value: LogTime)
    
    //.border(.cyan)
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: 4)  // Border thickness
        .foregroundColor(textStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}

struct TextFormatterStyle: ViewModifier {
    let textStyles: GeneralStylesLogEntry
    func body(content: Content) -> some View {
        content
            .font(Font.custom(textStyles.LabelFont, size: textStyles.LabelFontSize))
            .foregroundStyle(textStyles.GeneralTextColor)
            .contentTransition(.numericText())
    }
}

extension Text {
    @MainActor func TextStyleAndAnimation(_ textStyles: GeneralStylesLogEntry) -> some View {
        modifier(TextFormatterStyle(textStyles: textStyles))
    }
}
