//
//  PickerExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import Foundation
import SwiftUI

struct customSegmentedPickerView: View {
    @Binding var preselectedIndex: CallInType.CallInTypeShort
    let appStyles: StylesLogEntry
    
    init(preselectedIndex: Binding<CallInType.CallInTypeShort>, appStyles: StylesLogEntry) {
        self._preselectedIndex = preselectedIndex
        
        self.appStyles = appStyles
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(appStyles.GeneralInnerFrameColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(appStyles.TextfieldBackgroundColorUnLocked)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont(name: appStyles.TextFieldFont, size: appStyles.callInFontSize)!, .foregroundColor: UIColor(appStyles.GeneralTextColor)], for: .normal)

        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont(name: appStyles.TextFieldFont, size: appStyles.callInFontSize)!, .foregroundColor: UIColor(appStyles.GeneralPickerTextColor)], for: .selected)
        
        UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    
    var body: some View {
        Picker("", selection: $preselectedIndex) {
            ForEach(
                Array(
                    CallInType.callInTypes.sorted { (first, second) -> Bool in
                        return first.value < second.value
                    }), id: \.key
            ) { key, value in
                
                //callInItem(value: value, key: key, isLocked: false, isSelected: true).tag(key)
                Text(value)
                    //.fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            
        }
        .frame(height: appStyles.callInFieldHeight)
        .pickerStyle(.segmented)
    }
}
