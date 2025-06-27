//
//  PickerExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import Foundation
import SwiftUI

extension Picker {
    
    func PickerStyleForProcessTypeSelection(_ appStyles: StylesLogEntry) -> some View {
        self
            .font(Font.custom(appStyles.ProcessTypeFont, size: appStyles.ProcessTypeFontHight))
            .foregroundStyle(appStyles.ProcessTypeFontColor)
            .background(appStyles.ProcessTypeBackgroundColor)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        
    }
    
    
}
