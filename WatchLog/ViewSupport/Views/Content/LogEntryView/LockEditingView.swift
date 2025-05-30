//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI


struct LockedView: View {
  @Bindable var LogEntry: WatchLogEntry
    
    
  @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    
  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {

      Text("Gesperrt")
        .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize2))
        .foregroundStyle(.blue)
        .frame(height: GeneralStyles.TextFieldHeight, alignment: .center)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: true)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        
                Toggle("", isOn: $LogEntry.isLocked)
                .labelsHidden()
                .toggleStyle(ToggleStyleLock())
                .frame(height: GeneralStyles.TextFieldHeight, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        
      Spacer()
    }
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}
