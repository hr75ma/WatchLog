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
    @Published var GeneralBackgroundColor:Color = Color.white
    @Published var GeneralInnerFrameColor:Color = Color.blue
    @Published var GeneralInnerFrameBorderWidth:CGFloat = 4
    
    //toogle
    @Published var ToogleIsActiveColor: Color = Color.red
    @Published var ToogleIsUnActiveColor: Color = Color.green
    
    //locking Section
    @Published var LockImageisLocked: String = "pencil.and.list.clipboard"
    @Published var LockImageisUnLocked: String = "pencil.and.list.clipboard"
    @Published var LockColorIsLockedPrimary: Color = Color.red
    @Published var LockColorIsLockedSecondary: Color = Color.red
    @Published var LockColorIsUnLockedPrimary: Color = Color.blue
    @Published var LockColorIsUnLockedSecondary: Color = Color.blue
    
    
    //Accident Secttion
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
    
    @Published var ToolBarNewImageActive: String = "list.bullet.clipboard"
    @Published var ToolBarNewImageUnActive: String = "list.bullet.clipboard"
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
    
    
    
    
    //Note
    @Published var SectionNoteImage = "phone.bubble.fill"
    
    //tree navigation
    @Published var NavigationTreeAddEntryImage = "list.clipboard"
    
    @Published var NavigationTreeImagePrimaryColor = Color.white
    @Published var NavigationTreeImageSecondaryColor = Color.blue
    
    
    
    
    
    
    
    
    
    
    
    
}
