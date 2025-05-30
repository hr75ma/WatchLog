//
//  TextFieldStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import SwiftUI

class GeneralStylesLogEntry: ObservableObject {
    
    @Published var TextfieldBackgroundColor: Color = Color(hex: 0x3b3b3b).opacity(1)
    
    @Published var TextFieldFontHeight: CGFloat = 32
    
    
    @Published var LabelFont: String = "digital-7"
    @Published var LabelFontSize: CGFloat = 45
    @Published var LabelFontSize2: CGFloat = 35
    
    @Published var TextFieldFont: String = "Roboto-MediumItalic"
    @Published var TextFieldHeight: CGFloat = 35
    @Published var TextFieldHeight2: CGFloat = 30
    
    @Published var CallerImage: String = "phone.arrow.down.left.fill"
    @Published var AccidentImage: String = "car.fill"
    
    
    //generale layouts
    @Published var isLockedColor: Color = Color.red
    @Published var isUnLockedColor: Color = Color.blue
    
    @Published var GeneralInnerFrameColor:Color = Color.blue
    @Published var GeneralInnerFrameBorderWidth:CGFloat = 4
    
    
    
    
    
    
    @Published var GeneralTextColor:Color = Color.blue
    
}
