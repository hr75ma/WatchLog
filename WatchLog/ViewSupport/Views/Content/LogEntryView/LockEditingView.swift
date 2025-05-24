//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI



struct LockEditingView: View {
  @Bindable var WatchLog: WatchLogEntry

  let DisplaySize: CGFloat = 35

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {

      Text("Gesperrt")
        .font(Font.custom(LabelFont, size: LabelFontHeight))
        .foregroundStyle(.blue)
        .frame(height: TextFieldHeight, alignment: .topLeading)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: true)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

      Toggle("", isOn: $WatchLog.isLocked)
        .labelsHidden()
        .toggleStyle(MyStyleLock())
      //.border(.red)

      Spacer()

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
