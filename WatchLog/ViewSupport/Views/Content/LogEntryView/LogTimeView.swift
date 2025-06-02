//
//  DateAndTimeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct LogTimeView: View {
    var LogTime: Date
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {
        Text(LogTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
            .TextStyleAndAnimation(GeneralStyles)
        
      Spacer()
        Text(LogTime.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
            .TextStyleAndAnimation(GeneralStyles)
        
      Spacer()
      Text(LogTime.formatted(.dateTime.hour().minute().second()))
            .TextStyleAndAnimation(GeneralStyles)
        
    }
    .animation(.default, value: LogTime)
    
    //.border(.cyan)
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}

fileprivate struct TextFormatterStyle: ViewModifier {
    let GeneralStyles: GeneralStylesLogEntry
    func body(content: Content) -> some View {
        content
            .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
            .foregroundStyle(GeneralStyles.GeneralTextColor)
            .contentTransition(.numericText())
    }
}

extension Text {
   @MainActor fileprivate func TextStyleAndAnimation(_ generalStyles: GeneralStylesLogEntry) -> some View {
       modifier(TextFormatterStyle(GeneralStyles: generalStyles))
   }
}
