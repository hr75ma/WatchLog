//
//  SettingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Text("WatchLog")
                .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
                .foregroundStyle(GeneralStyles.GeneralTextColor)
                .contentTransition(.numericText())
        }
        
        Text("Version 0.1")
            .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
            .foregroundStyle(GeneralStyles.GeneralTextColor)
            .contentTransition(.numericText())
        
        Text("by HL")
            .font(Font.custom(GeneralStyles.LabelFont, size: GeneralStyles.LabelFontSize))
            .foregroundStyle(GeneralStyles.GeneralTextColor)
            .contentTransition(.numericText())
    }
}

#Preview {
    
    let textFieldStyleLogEntry = GeneralStylesLogEntry()
    SettingView()
        .environmentObject(textFieldStyleLogEntry)
}
