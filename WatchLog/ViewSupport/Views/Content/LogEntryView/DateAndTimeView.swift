//
//  DateAndTimeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct DateAndTimeView: View {
    @Bindable var WatchLog: WatchLogEntry

  let DisplaySize: CGFloat = 45

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {
        Text(WatchLog.EntryTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
        .font(Font.custom("digital-7", size: DisplaySize))
        .foregroundStyle(.blue)
        .contentTransition(.numericText())
        
      Spacer()
      Text(WatchLog.EntryTime.formatted(.dateTime.day().month(.defaultDigits).year()))
        .font(Font.custom("digital-7", size: DisplaySize))
        .foregroundStyle(.blue)
        .contentTransition(.numericText())
        
      Spacer()
      Text(WatchLog.EntryTime.formatted(.dateTime.hour().minute().second()))
        .font(Font.custom("digital-7", size: DisplaySize))
        .foregroundStyle(.blue)
        .contentTransition(.numericText())
        
    }
    
    //.border(.cyan)
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: 4)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )
  }
}
