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
    
    //global
    let standardFontColor: Color = .blue
    let standardBlurFactor: CGFloat = 10
    
    
    
    
    //navigation view section
    let standardNavigationBarItemColor: Color = .blue
    
    let navigationTreeColor: Color = .blue
    let navigationTreeFontColor: Color = .blue
    let navigationTreeRowColor: Color = Color(.systemGray6)
    let navigationTreeSelectedItemFontColor: Color = .white
    let navigationTreeSelectedRowColor: Color = .blue
    let navigationTreeRowSeparatorColor: Color = Color(.systemGray4)
    
    let navigationTreeAddEntryImage: String = "plus"
    let navigationTreeAddEntryImagePrimaryColor: Color = Color.blue
    let navigationTreeAddEntryImageSecondaryColor: Color = Color.blue
    
    let navigationTreeSettingImage: String = "gear"
    let navigationTreeSettingImagePrimaryColor: Color = Color.blue
    let navigationTreeSettingImageSecondaryColor: Color = Color.blue
    
    let navigationRefreshProgressionColor: Color = .black
    let navigationRefreshProgressionFont: String = "digital-7"
    let navigationRefreshProgressionFontSize: CGFloat = 35
    let navigationRefreshProgressionRefreshFontSize: CGFloat = 25
    
    
    
    
    
    //progession section
    let ProcessTypeFont: String = "Roboto-MediumItalic"
    let ProcessTypeFontSize: CGFloat = 25
    let ProcessTypeFontHight: CGFloat = 25
    let ProcessTypeFontColor: Color = Color.blue
    let ProcessTypeBackgroundColor: Color = Color.clear
    
    let progressionColor: Color = .white
    let progressionFont: String = "digital-7"
    let progressionFontSize: CGFloat = 35
    let progressionRefreshFontSize: CGFloat = 25
    
    //logboogEntryView
    let logTimeFont: String = "digital-7"
    let logTimeFontSize: CGFloat = 40
    
    
    
    
    
    let LabelFont: String = "digital-7"
    let LabelFontSize: CGFloat = 35
    let LabelFontSizeSub: CGFloat = 35
    
    
    //logTime section
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    let NavigationTreeDisclosureYearGradientStart = Color(hex: 0x222222).opacity(1)
    let NavigationTreeDisclosureYearGradientEnd = Color(hex: 0x2e2e2e).opacity(1)
    

    
    let callInFontSize: CGFloat = 25
    let callInFieldHeight: CGFloat = 30
    
    
     
    let glowingColorSetLocked: [Color] = [.red, .blue, .red]
    let glowingColorSetNew: [Color] = [.green, .blue, .green]
    let glowingColorSetEditing: [Color] = [.blue, .teal, .blue]
    
    
    let TextfieldBackgroundColor: Color = Color(hex: 0x272727)
    let TextfieldBackgroundColorLocked: Color = Color(hex: 0x0a0a0a)
    let TextfieldBackgroundColorUnLocked: Color = Color(hex: 0x1d1d1d)
    
    let TextFieldFontHeight: CGFloat = 32
    
    let GeneralToggleIsActiveImage: String = "checkmark.rectangle"
    let GeneralToggleIsUnactiveImage: String = "rectangle"
    let GeneralToggleIsActivePrimary: Color = Color.green
    let GeneralToggleIsActiveSecondary: Color = Color.blue
    let GeneralToggleIsUnactivePrimary: Color = Color.blue
    let GeneralToggleIsUnactiveSecondary: Color = Color.blue
    
    

    
    let TextFieldFont: String = "Roboto-MediumItalic"
    let TextFieldFontSize: CGFloat = 28
    let TextFieldFontSubSize: CGFloat = 30
    let TextFieldHeight: CGFloat = 35
    let TextFieldHeightSub: CGFloat = 30
    
    
    
    let SectionCallInImage: String = "arrow.down.message"
    let SectionCallInImagePrimary: Color = Color.white
    let SectionCallInImageSecondary: Color = Color.blue
    
    let SectionCallerImage: String = "waveform.and.person.filled"
    let SectionCallerImagePrimary: Color = Color.white
    let SectionCallerImageSecondary: Color = Color.blue
    
    let SectionProcessTypeImage: String = "exclamationmark.triangle"
    let SectionProcessTypeImagePrimary: Color = Color.white
    let SSectionProcessTypeImageSecondary: Color = Color.blue
    
    //let SectionNoteImage = "phone.bubble.fill"
    let SectionNoteImage = "message.badge.waveform"
    let SectionNoteImagePrimary: Color = Color.white
    let SectionNoteImageSecondary: Color = Color.blue
    
    //generale layouts
    let isLockedColor: Color = Color.red
    let isUnLockedColor: Color = Color.blue
    
    let GeneralTextColor:Color = Color.blue
    let GeneralPickerTextColor:Color = Color.white
    let GeneralBackgroundColor:Color = Color.black
    let GeneralInnerFrameColor:Color = Color.blue
    let GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    let ToogleIsLockedColor: Color = Color.blue
    
    //Locking Section
    let LockImageisLocked: String = "lock.rotation"
    let LockImageisUnLocked: String = "lock.open.rotation"
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
    
    let ToolBarNewImageActive: String = "plus"
    let ToolBarNewImageUnActive: String = "plus"
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
    
    let ToolbarContextImage: String = "ellipsis.circle"
    let ToolbarContextColorActivePrimary: Color = Color.white
    let ToolbarContextColorActiveSecondary: Color = Color.blue
    let ToolbarContextColorUnActivePrimary: Color = Color.white
    let ToolbarContextColorUnActiveSecondary: Color = Color.red
    
    // Section Canvas
    let CanvasLockedColor: Color = Color(hex: 0x585858).opacity(1)
    let CanvasUnLockedColor: Color = Color.blue
    
    
    
    //tree navigation
   
    

    
    
    let NavigationTreeFont: String = "Roboto-MediumItalic"
    let NavigationTreeFontSize: CGFloat = 20
    let NavigationTreeFontColor: Color = Color.blue
    
    let NavigationTreeSubFont: String = "Roboto-MediumItalic"
    let NavigationTreeSubFontSize: CGFloat = 15
    let NavigationTreeSubFontColor: Color = Color.white
    
    // background color for selected row
    let NavigationTreeSelectedRowColor: Color = Color(hex: 0x476f95).opacity(1)
    
    //clear button for textfield
    let ClearButtonImage: String = "xmark.circle.fill"//"multiply.circle.fill"
    let ClearButtonColorActivePrimary: Color = Color.white
    let ClearButtonColorActiveSecondary: Color = Color.blue
    let ClearButtonSize: CGFloat = 20
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

