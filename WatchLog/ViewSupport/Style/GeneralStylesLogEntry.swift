//
//  TextFieldStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import SwiftUI

class GeneralStylesLogEntry: ObservableObject {
    
    @Published var TextfieldBackgroundColor: Color = Color(hex: 0x272727).opacity(1)
    
    @Published var TextFieldFontHeight: CGFloat = 32
    
    
    @Published var LabelFont: String = "digital-7"
    @Published var LabelFontSize: CGFloat = 45
    @Published var LabelFontSize2: CGFloat = 35
    
    @Published var TextFieldFont: String = "Roboto-MediumItalic"
    @Published var TextFieldHeight: CGFloat = 35
    @Published var TextFieldHeight2: CGFloat = 30
    
    @Published var SectionCallerImage: String = "phone.badge.waveform.fill"
    @Published var SectionAccidentImage: String = "car.fill"
    
    
    //generale layouts
    @Published var isLockedColor: Color = Color.red
    @Published var isUnLockedColor: Color = Color.blue
    
    @Published var GeneralTextColor:Color = Color.blue
    @Published var GeneralInnerFrameColor:Color = Color.blue
    @Published var GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    @Published var ToogleIsActiveColor: Color = Color.red
    @Published var ToogleIsUnActiveColor: Color = Color.green
    
    
    @Published var isLockImage: String = "pencil.slash"
    @Published var isUnLockImage: String = "pencil"
    
    @Published var isAccidentImage: String = "checkmark.rectangle.fill"
    @Published var isUnAccidentImage: String = "rectangle.fill"
    @Published var ToogleIsAccidentColor: Color = Color.green
    @Published var ToogleIsUnAccidentColor: Color = Color.blue
    
    //ToolbarItem
    @Published var ToolBarIsActiveImageEraser: String = "eraser.fill"
    @Published var ToolBarIsUnActiveImageEraser: String = "eraser.fill"
    
    @Published var ToolBarIsActiveImageSave: String = "square.and.arrow.down.fill"
    @Published var ToolBarIsUnActiveImageSave: String = "square.and.arrow.down.fill"
    
    
    
    @Published var ToolBarIsActiveImageNew: String = "document.badge.plus.fill"
    @Published var ToolBarIsUnActiveImageNew: String = "document.badge.plus.fill"
    
    
    @Published var ToolBarIsActiveImageDelete: String = "trash.fill"
    @Published var ToolBarIsUnActiveImageDelete: String = "trash.slash.fill"
    
    //Note
    @Published var SectionNoteImage = "phone.bubble.fill"
    
    
    
    
    
    
    
    
    
    
}
