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
    let standardLockedColor: Color = Color.red
    let standardBlurFactor: CGFloat = 10
    let standardFrameColor: Color = Color.blue
    let standardInnerFrameBorderWidth:CGFloat = 4
    let standardBackgroundColor: Color = Color.black
    
    let labelFont: String = "digital-7"
    let labelFontSize: CGFloat = 35
    let labelFontSizeSub: CGFloat = 30
    
    let glowingColorSetLocked: [Color] = [.red, .blue, .red]
    let glowingColorSetNew: [Color] = [.green, .blue, .green]
    let glowingColorSetEditing: [Color] = [.blue, .teal, .blue]

    
    let textFieldHeight: CGFloat = 40
    let textFieldSubHeight: CGFloat = 35
    let textFieldBackgroundColor: Color = Color(.systemGray5)
    let textFieldBackgroundColorLocked: Color = Color(.systemGray6)
    let textFieldBackgroundColorUnLocked: Color = Color(.systemGray5)
    
    //clear button for textfield
    let clearButtonImage: String = "xmark.circle.fill"
    let clearButtonColorActivePrimary: Color = Color.white
    let clearButtonColorActiveSecondary: Color = Color.blue
    let clearButtonSize: CGFloat = 20
    
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
    let progressionColor: Color = .white
    let progressionFont: String = "digital-7"
    let progressionFontSize: CGFloat = 35
    let progressionRefreshFontSize: CGFloat = 25
    
    //logboogEntryView
    let logTimeFont: String = "digital-7"
    let logTimeFontSize: CGFloat = 40
    
    let lockImageIsLocked: String = "lock.rotation"
    let lockImageIsUnLocked: String = "lock.open.rotation"
    let lockColorIsLockedPrimary: Color = Color.red
    let lockColorIsLockedSecondary: Color = Color.red
    let lockColorIsUnLockedPrimary: Color = Color.green
    let lockColorIsUnLockedSecondary: Color = Color.green
    
    
    //callin section
    let sectionCallInImage: String = "arrow.down.message"
    let sectionCallInImagePrimary: Color = Color.white
    let sectionCallInImageSecondary: Color = Color.blue
    
    //caller data section
    let sectionCallerImage: String = "waveform.and.person.filled"
    let sectionCallerImagePrimary: Color = Color.white
    let sectionCallerImageSecondary: Color = Color.blue
    
    //event section
    let sectionEventTypeImage: String = "exclamationmark.triangle"
    let sectionEventTypeImagePrimary: Color = Color.white
    let sectionEventTypeImageSecondary: Color = Color.blue
    
    //note section
    let sectionNoteImage = "message.badge.waveform"
    let sectionNoteImagePrimary: Color = Color.white
    let sectionNoteImageSecondary: Color = Color.blue
    
    //standard toggle
    let standardToggleIsActiveImage: String = "checkmark.rectangle"
    let standardToggleIsUnactiveImage: String = "rectangle"
    let standardToggleIsActivePrimary: Color = Color.green
    let standardToggleIsActiveSecondary: Color = Color.blue
    let standardToggleIsUnactivePrimary: Color = Color.blue
    let standardToggleIsUnactiveSecondary: Color = Color.blue
    let standardToogleIsLockedColor: Color = Color.blue
    
    //call in
    let selectedCallInColor: Color = Color.white
    let segmentedCallInFontSize: CGFloat = 25
    
    // section Canvas
    let canvasLockedColor: Color = Color.red
    let canvasUnLockedColor: Color = Color.blue
    
    
    //logTime section
    let LabelFont: String = "digital-7"
    let LabelFontSize: CGFloat = 35
    let LabelFontSizeSub: CGFloat = 30
    
    let processTypeFontColor: Color = Color.blue
    let ProcessTypeBackgroundColor: Color = Color.clear
    
    let callInFontSize: CGFloat = 25
    let callInFieldHeight: CGFloat = 30
     

    
    
    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
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

