//
//  TextFieldStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import SwiftUI

class GeneralStylesLogEntry: ObservableObject {
    
    @Published var TextfieldBackgroundColor: Color = Color(hex: 0x272727).opacity(1)
    @Published var TextfieldBackgroundColorLocked: Color = Color(hex: 0x0a0a0a).opacity(1)
    @Published var TextfieldBackgroundColorUnLocked: Color = Color(hex: 0x1d1d1d).opacity(1)
    
    
    
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
    @Published var GeneralBackgroundColor:Color = Color.white
    @Published var GeneralInnerFrameColor:Color = Color.blue
    @Published var GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    @Published var ToogleIsLockedColor: Color = Color.blue

    
    //Locking Section
    @Published var LockImageisLocked: String = "checkmark.rectangle"
    @Published var LockImageisUnLocked: String = "rectangle"
    @Published var LockColorIsLockedPrimary: Color = Color.red
    @Published var LockColorIsLockedSecondary: Color = Color.red
    @Published var LockColorIsUnLockedPrimary: Color = Color.blue
    @Published var LockColorIsUnLockedSecondary: Color = Color.blue
    
    
    //Accident Section
    @Published var AccidentImageisLocked: String = "checkmark.rectangle"
    @Published var AccidentImageisUnLocked: String = "rectangle"
    @Published var AccidentColorIsLockedPrimary: Color = Color.green
    @Published var AccidentColorIsLockedSecondary: Color = Color.blue
    @Published var AccidentColorIsUnLockedPrimary: Color = Color.blue
    @Published var AccidentColorIsUnLockedSecondary: Color = Color.blue
    
    //ToolbarItem
    @Published var ToolBarEraserImageActive: String = "eraser"
    @Published var ToolBarEraserImageUnActive: String = "eraser"
    @Published var ToolBarEraserColorActive: Color = Color.blue
    @Published var ToolBarEraserColorUnActive: Color = Color.red
    
    @Published var ToolBarSaveImageActive: String = "square.and.arrow.down"
    @Published var ToolBarSaveImageUnActive: String = "square.and.arrow.down"
    @Published var ToolBarSaveColorActivePrimary: Color = Color.blue
    @Published var ToolBarSaveColorActiveSecondary: Color = Color.blue
    @Published var ToolBarSaveColorUnActivePrimary: Color = Color.red
    @Published var ToolBarSaveColorUnActiveSecondary: Color = Color.red
    
    @Published var ToolBarNewImageActive: String = "list.clipboard"
    @Published var ToolBarNewImageUnActive: String = "list.clipboard"
    @Published var ToolBarNewColorActivePrimary: Color = Color.white
    @Published var ToolBarNewColorActiveSecondary: Color = Color.blue
    @Published var ToolBarNewColorUnActivePrimary: Color = Color.white
    @Published var ToolBarNewColorUnActiveSecondary: Color = Color.red
    
    @Published var ToolBarDeleteImageActive: String = "trash"
    @Published var ToolBarDeleteImageUnActive: String = "trash.slash"
    @Published var ToolBarDeleteColorActivePrimary: Color = Color.blue
    @Published var ToolBarDeleteColorActiveSecondary: Color = Color.blue
    @Published var ToolBarDeleteColorUnActivePrimary: Color = Color.red
    @Published var ToolBarDeleteColorUnActiveSecondary: Color = Color.red
    
    // Section Canvas
    @Published var CanvasLockedColor: Color = Color(hex: 0x585858).opacity(1)
    @Published var CanvasUnLockedColor: Color = Color.blue
    
    //Note
    @Published var SectionNoteImage = "phone.bubble.fill"
    
    //tree navigation
    @Published var NavigationTreeAddEntryImage: String = "list.clipboard"
    @Published var NavigationTreeAddEntryImagePrimaryColor: Color = Color.white
    @Published var NavigationTreeAddEntryImageSecondaryColor: Color = Color.blue
    
//    @Published var NavigationTreeImagePrimaryColor: Color = Color.white
//    @Published var NavigationTreeImageSecondaryColor: Color = Color.blue
    
    @Published var NavigationTreeSettingImage: String = "gear"
    @Published var NavigationTreeSettingImagePrimaryColor: Color = Color.blue
    @Published var NavigationTreeSettingImageSecondaryColor: Color = Color.blue
    
    @Published var NavigationTreeDisclosureYearGradientStart = Color(hex: 0x222222).opacity(1)
    @Published var NavigationTreeDisclosureYearGradientEnd = Color(hex: 0x2e2e2e).opacity(1)
    
    
    @Published var NavigationTreeFont: String = "Roboto-MediumItalic"
    @Published var NavigationTreeFontSize: CGFloat = 20
    @Published var NavigationTreeFontColor: Color = Color.blue
    
    
    
    
    
    
    
    
    
    
    
    
    
}
