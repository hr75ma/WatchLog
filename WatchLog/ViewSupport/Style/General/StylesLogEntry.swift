//
//  StylesLogEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

//
//  TextFieldStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.05.25.
//

import SwiftUI

@Observable
class StylesLogEntry {
    
    var TextfieldBackgroundColor: Color = Color(hex: 0x272727).opacity(1)
    var TextfieldBackgroundColorLocked: Color = Color(hex: 0x0a0a0a).opacity(1)
    var TextfieldBackgroundColorUnLocked: Color = Color(hex: 0x1d1d1d).opacity(1)
    
    var TextFieldFontHeight: CGFloat = 32
    
    var GeneralToggleIsActiveImage: String = "checkmark.rectangle"
    var GeneralToggleIsUnactiveImage: String = "rectangle"
    var GeneralToggleIsActivePrimary: Color = Color.green
    var GeneralToggleIsActiveSecondary: Color = Color.blue
    var GeneralToggleIsUnactivePrimary: Color = Color.blue
    var GeneralToggleIsUnactiveSecondary: Color = Color.blue
    
    
    var LabelFont: String = "digital-7"
    var LabelFontSize: CGFloat = 45
    var LabelFontSize2: CGFloat = 35
    
    var TextFieldFont: String = "Roboto-MediumItalic"
    var TextFieldHeight: CGFloat = 35
    var TextFieldHeight2: CGFloat = 30
    
    var SectionCallerImage: String = "phone.badge.waveform.fill"
    var SectionAccidentImage: String = "car.fill"
    var SectionProcessTypeImage: String = "rectangle.and.pencil.and.ellipsis"
    
    
    //generale layouts
    var isLockedColor: Color = Color.red
    var isUnLockedColor: Color = Color.blue
    
    var GeneralTextColor:Color = Color.blue
    var GeneralBackgroundColor:Color = Color.white
    var GeneralInnerFrameColor:Color = Color.blue
    var GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    var ToogleIsLockedColor: Color = Color.blue

    
    //Locking Section
    var LockImageisLocked: String = "lock.ipad"
    var LockImageisUnLocked: String = "lock.open.ipad"
    var LockColorIsLockedPrimary: Color = Color.red
    var LockColorIsLockedSecondary: Color = Color.red
    var LockColorIsUnLockedPrimary: Color = Color.green
    var LockColorIsUnLockedSecondary: Color = Color.green
    
    
    //Accident Section
    var AccidentImageisLocked: String = "checkmark.rectangle"
    var AccidentImageisUnLocked: String = "rectangle"
    var AccidentColorIsLockedPrimary: Color = Color.green
    var AccidentColorIsLockedSecondary: Color = Color.blue
    var AccidentColorIsUnLockedPrimary: Color = Color.blue
    var AccidentColorIsUnLockedSecondary: Color = Color.blue
    
    //Porcesstype Section
    var ProcessTypeColorIsLockedPrimary: Color = Color.blue
    var ProcessTypeColorIsLockedSecondary: Color = Color.blue
    var ProcessTypeColorIsUnLockedPrimary: Color = Color.blue
    var ProcessTypeColorIsUnLockedSecondary: Color = Color.blue
    
    //ToolbarItem
    var ToolBarEraserImageActive: String = "eraser"
    var ToolBarEraserImageUnActive: String = "eraser"
    var ToolBarEraserColorActive: Color = Color.blue
    var ToolBarEraserColorUnActive: Color = Color.red
    
    var ToolBarSaveImageActive: String = "square.and.arrow.down"
    var ToolBarSaveImageUnActive: String = "square.and.arrow.down"
    var ToolBarSaveColorActivePrimary: Color = Color.blue
    var ToolBarSaveColorActiveSecondary: Color = Color.blue
    var ToolBarSaveColorUnActivePrimary: Color = Color.red
    var ToolBarSaveColorUnActiveSecondary: Color = Color.red
    
    var ToolBarNewImageActive: String = "list.clipboard"
    var ToolBarNewImageUnActive: String = "list.clipboard"
    var ToolBarNewColorActivePrimary: Color = Color.white
    var ToolBarNewColorActiveSecondary: Color = Color.blue
    var ToolBarNewColorUnActivePrimary: Color = Color.white
    var ToolBarNewColorUnActiveSecondary: Color = Color.red
    
    var ToolBarDeleteImageActive: String = "trash"
    var ToolBarDeleteImageUnActive: String = "trash.slash"
    var ToolBarDeleteColorActivePrimary: Color = Color.blue
    var ToolBarDeleteColorActiveSecondary: Color = Color.blue
    var ToolBarDeleteColorUnActivePrimary: Color = Color.red
    var ToolBarDeleteColorUnActiveSecondary: Color = Color.red
    
    var ToolbarContextImage: String = "list.bullet.circle"
    var ToolbarContextColorActivePrimary: Color = Color.white
    var ToolbarContextColorActiveSecondary: Color = Color.blue
    var ToolbarContextColorUnActivePrimary: Color = Color.white
    var ToolbarContextColorUnActiveSecondary: Color = Color.red
    
    // Section Canvas
    var CanvasLockedColor: Color = Color(hex: 0x585858).opacity(1)
    var CanvasUnLockedColor: Color = Color.blue
    
    //Note
    var SectionNoteImage = "phone.bubble.fill"
    
    //tree navigation
    var NavigationTreeAddEntryImage: String = "list.clipboard"
    var NavigationTreeAddEntryImagePrimaryColor: Color = Color.white
    var NavigationTreeAddEntryImageSecondaryColor: Color = Color.blue
    
//    @Published var NavigationTreeImagePrimaryColor: Color = Color.white
//    @Published var NavigationTreeImageSecondaryColor: Color = Color.blue
    
    var NavigationTreeSettingImage: String = "gear"
    var NavigationTreeSettingImagePrimaryColor: Color = Color.blue
    var NavigationTreeSettingImageSecondaryColor: Color = Color.blue
    
    var NavigationTreeDisclosureYearGradientStart = Color(hex: 0x222222).opacity(1)
    var NavigationTreeDisclosureYearGradientEnd = Color(hex: 0x2e2e2e).opacity(1)
    
    
    var NavigationTreeFont: String = "Roboto-MediumItalic"
    var NavigationTreeFontSize: CGFloat = 20
    var NavigationTreeFontColor: Color = Color.blue
    
    var NavigationTreeSubFont: String = "Roboto-MediumItalic"
    var NavigationTreeSubFontSize: CGFloat = 15
    var NavigationTreeSubFontColor: Color = Color.white
    
    //clear button for textfield
    var ClearButtonImage: String = "x.square.fill"//"multiply.circle.fill"
    var ClearButtonColorActivePrimary: Color = Color.white
    var ClearButtonColorActiveSecondary: Color = Color.blue
    
    //Picker for ProcessType
    var ProcessTypeFont: String = "Roboto-MediumItalic"
    var ProcessTypeFontHight: CGFloat = 25
    var ProcessTypeFontColor: Color = Color.blue
    var ProcessTypeBackgroundColor: Color = Color.clear
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

