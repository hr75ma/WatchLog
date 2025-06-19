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


final class StylesLogEntry:Sendable {
    
    static let shared = StylesLogEntry()
    
    private init() {}
    
    let TextfieldBackgroundColor: Color = Color(hex: 0x272727).opacity(1)
    let TextfieldBackgroundColorLocked: Color = Color(hex: 0x0a0a0a).opacity(1)
    let TextfieldBackgroundColorUnLocked: Color = Color(hex: 0x1d1d1d).opacity(1)
    
    let TextFieldFontHeight: CGFloat = 32
    
    let GeneralToggleIsActiveImage: String = "checkmark.rectangle"
    let GeneralToggleIsUnactiveImage: String = "rectangle"
    let GeneralToggleIsActivePrimary: Color = Color.green
    let GeneralToggleIsActiveSecondary: Color = Color.blue
    let GeneralToggleIsUnactivePrimary: Color = Color.blue
    let GeneralToggleIsUnactiveSecondary: Color = Color.blue
    
    
    let LabelFont: String = "digital-7"
    let LabelFontSize: CGFloat = 45
    let LabelFontSize2: CGFloat = 35
    
    let TextFieldFont: String = "Roboto-MediumItalic"
    let TextFieldHeight: CGFloat = 35
    let TextFieldHeight2: CGFloat = 30
    
    let SectionCallerImage: String = "phone.badge.waveform.fill"
    let SectionCallerImagePrimary: Color = Color.white
    let SectionCallerImageSecondary: Color = Color.blue
    
    
    let SectionProcessTypeImage: String = "character.book.closed.fill"
    let SectionProcessTypeImagePrimary: Color = Color.blue
    let SSectionProcessTypeImageSecondary: Color = Color.blue
    
    
    //let SectionNoteImage = "phone.bubble.fill"
    let SectionNoteImage = "message.badge.waveform.fill"
    let SectionNoteImagePrimary: Color = Color.white
    let SectionNoteImageSecondary: Color = Color.blue
    
    
    //generale layouts
    let isLockedColor: Color = Color.red
    let isUnLockedColor: Color = Color.blue
    
    let GeneralTextColor:Color = Color.blue
    let GeneralBackgroundColor:Color = Color.white
    let GeneralInnerFrameColor:Color = Color.blue
    let GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    let ToogleIsLockedColor: Color = Color.blue

    
    //Locking Section
    let LockImageisLocked: String = "lock.ipad"
    let LockImageisUnLocked: String = "lock.open.ipad"
    let LockColorIsLockedPrimary: Color = Color.red
    let LockColorIsLockedSecondary: Color = Color.red
    let LockColorIsUnLockedPrimary: Color = Color.green
    let LockColorIsUnLockedSecondary: Color = Color.green
    
    
    //Accident Section
    let AccidentImageisLocked: String = "checkmark.rectangle"
    let AccidentImageisUnLocked: String = "rectangle"
    let AccidentColorIsLockedPrimary: Color = Color.green
    let AccidentColorIsLockedSecondary: Color = Color.blue
    let AccidentColorIsUnLockedPrimary: Color = Color.blue
    let AccidentColorIsUnLockedSecondary: Color = Color.blue
    
    //Porcesstype Section
    let ProcessTypeColorIsLockedPrimary: Color = Color.blue
    let ProcessTypeColorIsLockedSecondary: Color = Color.blue
    let ProcessTypeColorIsUnLockedPrimary: Color = Color.blue
    let ProcessTypeColorIsUnLockedSecondary: Color = Color.blue
    
    //ToolbarItem
    let ToolBarEraserImageActive: String = "eraser"
    let ToolBarEraserImageUnActive: String = "eraser"
    let ToolBarEraserColorActive: Color = Color.blue
    let ToolBarEraserColorUnActive: Color = Color.red
    
    let ToolBarSaveImageActive: String = "square.and.arrow.down"
    let ToolBarSaveImageUnActive: String = "square.and.arrow.down"
    let ToolBarSaveColorActivePrimary: Color = Color.blue
    let ToolBarSaveColorActiveSecondary: Color = Color.blue
    let ToolBarSaveColorUnActivePrimary: Color = Color.red
    let ToolBarSaveColorUnActiveSecondary: Color = Color.red
    
    let ToolBarNewImageActive: String = "list.clipboard"
    let ToolBarNewImageUnActive: String = "list.clipboard"
    let ToolBarNewColorActivePrimary: Color = Color.white
    let ToolBarNewColorActiveSecondary: Color = Color.blue
    let ToolBarNewColorUnActivePrimary: Color = Color.white
    let ToolBarNewColorUnActiveSecondary: Color = Color.red
    
    let ToolBarDeleteImageActive: String = "trash"
    let ToolBarDeleteImageUnActive: String = "trash.slash"
    let ToolBarDeleteColorActivePrimary: Color = Color.blue
    let ToolBarDeleteColorActiveSecondary: Color = Color.blue
    let ToolBarDeleteColorUnActivePrimary: Color = Color.red
    let ToolBarDeleteColorUnActiveSecondary: Color = Color.red
    
    let ToolbarContextImage: String = "list.bullet.circle"
    let ToolbarContextColorActivePrimary: Color = Color.white
    let ToolbarContextColorActiveSecondary: Color = Color.blue
    let ToolbarContextColorUnActivePrimary: Color = Color.white
    let ToolbarContextColorUnActiveSecondary: Color = Color.red
    
    // Section Canvas
    let CanvasLockedColor: Color = Color(hex: 0x585858).opacity(1)
    let CanvasUnLockedColor: Color = Color.blue
    
    
    
    //tree navigation
    let NavigationTreeAddEntryImage: String = "list.clipboard"
    let NavigationTreeAddEntryImagePrimaryColor: Color = Color.white
    let NavigationTreeAddEntryImageSecondaryColor: Color = Color.blue
    
    let NavigationTreeSettingImage: String = "gear"
    let NavigationTreeSettingImagePrimaryColor: Color = Color.blue
    let NavigationTreeSettingImageSecondaryColor: Color = Color.blue
    
    let NavigationTreeDisclosureYearGradientStart = Color(hex: 0x222222).opacity(1)
    let NavigationTreeDisclosureYearGradientEnd = Color(hex: 0x2e2e2e).opacity(1)
    
    
    let NavigationTreeFont: String = "Roboto-MediumItalic"
    let NavigationTreeFontSize: CGFloat = 20
    let NavigationTreeFontColor: Color = Color.blue
    
    let NavigationTreeSubFont: String = "Roboto-MediumItalic"
    let NavigationTreeSubFontSize: CGFloat = 15
    let NavigationTreeSubFontColor: Color = Color.white
    
    // background color for selected row
    let NavigationTreeSelectedRowColor: Color = Color(hex: 0x476f95).opacity(1)
    
    //clear button for textfield
    let ClearButtonImage: String = "x.square.fill"//"multiply.circle.fill"
    let ClearButtonColorActivePrimary: Color = Color.white
    let ClearButtonColorActiveSecondary: Color = Color.blue
    
    
    
    //Picker for ProcessType
    let ProcessTypeFont: String = "Roboto-MediumItalic"
    let ProcessTypeFontHight: CGFloat = 25
    let ProcessTypeFontColor: Color = Color.blue
    let ProcessTypeBackgroundColor: Color = Color.clear
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

