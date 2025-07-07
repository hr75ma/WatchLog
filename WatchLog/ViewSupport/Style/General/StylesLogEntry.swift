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
    
    let standardBlurRadius: CGFloat = 10
    let standardInnerFrameBorderWidth:CGFloat = 4
    
    let labelFont: String = "digital-7"
    let labelFontSize: CGFloat = 35
    let labelFontSizeSub: CGFloat = 30
    
    let glowingColorSetLocked: [Color] = [.watchLogGlowing1, .watchLogGlowing2, .watchLogGlowing1]
    let glowingColorSetNew: [Color] = [.watchLogGlowing3, .watchLogGlowing2, .watchLogGlowing3]
    let glowingColorSetEditing: [Color] = [.watchLogGlowing2, .watchLogGlowing4, .watchLogGlowing2]

    
    let textFieldHeight: CGFloat = 40
    let textFieldSubHeight: CGFloat = 35
    
    
    //clear button for textfield
    let clearButtonImage: String = "xmark.circle.fill"
    let clearButtonSize: CGFloat = 20
    
    //navigation view section
    
    
    
    let navigationTreeAddEntryImage: String = "plus"
    
    let navigationTreeSettingImage: String = "gear"
    
    
    let navigationRefreshProgressionFont: String = "digital-7"
    let navigationRefreshProgressionFontSize: CGFloat = 35
    let navigationRefreshProgressionRefreshFontSize: CGFloat = 25
    
    //progession section
    let progressionFont: String = "digital-7"
    let progressionFontSize: CGFloat = 35
    let progressionRefreshFontSize: CGFloat = 25
    
    //logboogEntryView
    let logTimeFont: String = "digital-7"
    let logTimeFontSize: CGFloat = 40
    
    let lockImageIsLocked: String = "lock.rotation"
    let lockImageIsUnLocked: String = "lock.open.rotation"
    
    //callin section
    let sectionCallInImage: String = "arrow.down.message"
    
    //caller data section
    let sectionCallerImage: String = "waveform.and.person.filled"
    
    
    //event section
    let sectionEventTypeImage: String = "exclamationmark.triangle"

    
    //note section
    let sectionNoteImage = "message.badge.waveform"
    
    
    //standard toggle
    let standardToggleIsActiveImage: String = "checkmark.rectangle"
    let standardToggleIsUnactiveImage: String = "rectangle"
    
    //call in
    let segmentedCallInFontSize: CGFloat = 25
    
    
    
    
    //logTime section
    let LabelFont: String = "digital-7"
    let LabelFontSize: CGFloat = 35
    let LabelFontSizeSub: CGFloat = 30
    
    
    //callin section
    let callInFontSize: CGFloat = 25
    let callInFieldHeight: CGFloat = 30
    
    //canvas
    let canvasSize: CGFloat = 2000
    let canvasMinimumZoomScale: CGFloat = 0.25
    let canvasMaximumZoomScale: CGFloat = 10
    
    
     

    
    
    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
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
}

