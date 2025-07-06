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
      .timeSectionPadding()
      .standardBottomBorder()
  }
}

extension LogTimeView {

  private var logTimeSection: some View {
    HStack(alignment: .center) {
      Text(logTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
        .logTimeStyleAndAnimation()
      Spacer()
      Text(logTime.formatted(.dateTime.day(.twoDigits).month(.twoDigits).year()))
        .logTimeStyleAndAnimation()
      Spacer()
      Text(logTime.formatted(.dateTime.hour().minute().second()))
        .logTimeStyleAndAnimation()
    }
  }
}


