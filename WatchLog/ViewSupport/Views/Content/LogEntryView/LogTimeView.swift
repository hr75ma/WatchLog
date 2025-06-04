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
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    @State var textColor = Color.blue
    @State var isRunning = false

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {
        Text(time.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
            //.TextStyleAndAnimation(GeneralStyles)
            .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
            .foregroundStyle(textColor)
            //.contentTransition(.numericText())
        Button("start") {
            time = .now
        }
        
      Spacer()
        
        if(isRunning) {
            TimelineView(.periodic(from: .now, by: duration)) { context in
                
                Text(LogTime.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
                    .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
                    .foregroundStyle(color[Int(context.date.timeIntervalSince1970) % color.count])
                    .animation(.easeInOut(duration:duration))
            }
        }
        
      Spacer()
      Text(LogTime.formatted(.dateTime.hour().minute().second()))
            .TextStyleAndAnimation(GeneralStyles)
        

        
    }
    .animation(.default, value: LogTime)
    .onChange(of: time) { oldValue, newValue in
        isRunning.toggle()
//        withAnimation(.bouncy(duration: 1).repeatCount(2, autoreverses: true)) {
//            //self.textColor = (self.textColor == .blue) ? .red : .blue
//            self.textColor = .white
//        } completion: {
//            self.textColor = .blue
//        }
        
    }
    
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
