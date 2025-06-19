//
//  SettingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.appStyles) var appStyles
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            Text("WatchLog")
                .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize))
                .foregroundStyle(appStyles.GeneralTextColor)
                .contentTransition(.numericText())
        }
        
        Text("Version 0.1")
            .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize))
            .foregroundStyle(appStyles.GeneralTextColor)
            .contentTransition(.numericText())
        
        Text("by HL")
            .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize))
            .foregroundStyle(appStyles.GeneralTextColor)
            .contentTransition(.numericText())
    }
}

#Preview {
    
    SettingView()
        .environment(\.appStyles  ,StylesLogEntry.shared)
}
