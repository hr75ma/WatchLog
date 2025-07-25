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

final class StylesLogEntry: Sendable {
    static let shared = StylesLogEntry()

    private init() {}

    // global
    let standardInnerFrameBorderWidth: CGFloat = 3
    let standardCornerRadius: Double = 20

    // standard toggle
    let standardToggleIsActiveImage: String = "checkmark.rectangle"
    let standardToggleIsUnactiveImage: String = "rectangle"

    let labelFont: String = "digital-7"
    // let labelFont: String = "digital display tfb"
    let labelFontSize: CGFloat = 35
    let labelFontSizeSub: CGFloat = 30

    let glowingColorSetLocked: [Color] = [.watchLogGlowing1, .watchLogGlowing2, .watchLogGlowing1]
    let glowingColorSetNew: [Color] = [.watchLogGlowing3, .watchLogGlowing2, .watchLogGlowing3]
    let glowingColorSetEditing: [Color] = [.watchLogGlowing2, .watchLogGlowing4, .watchLogGlowing2]
    let glowingBlurRadius: Double = 18
    let glowingAnimationDuration: Double = 2

    let textFieldHeight: CGFloat = 40
    let textFieldSubHeight: CGFloat = 35

    // clear button for textfield
    let clearButtonImage: String = "xmark.circle.fill"
    let clearButtonSize: CGFloat = 20

    // navigation view section
    let navigationAddImage: String = "plus.circle"
    let navigationSettingImage: String = "gear.circle"
    let navigationMenuImage: String = "ellipsis.circle"
    let navigationItemImageSize: CGFloat = 25
    let navigationItemAnimationDuration: Double = 2

    let navigationTitleFont: String = "digital-7"
    let navigationTitleFontSize: CGFloat = 30

    let navigationRowAnimationDuration: Double = 0.75
    let navigationRowGradientOpacityStart: Double = 0.5
    let navigationRowGradientOpacityEnd: Double = 1

    // progession section
    let navigationRefreshProgressionFont: String = "digital-7"
    let navigationRefreshProgressionFontSize: CGFloat = 35
    let navigationRefreshProgressionRefreshFontSize: CGFloat = 25

    let progressionFont: String = "digital-7"
    let progressionFontSize: CGFloat = 35
    let progressionRefreshFontSize: CGFloat = 25

    // logboogEntryView
    let logTimeFont: String = "digital-7"
    let logTimeFontSize: CGFloat = 40

    let lockImageIsLocked: String = "lock.rotation"
    let lockImageIsUnLocked: String = "lock.open.rotation"

    // section image
    let sectionCallInImage: String = "arrow.down.message"
    let sectionCallerImage: String = "waveform.and.person.filled"
    let sectionEventTypeImage: String = "exclamationmark.triangle"
    let sectionNoteImage = "message.badge.waveform"

    let segmentedCallInFontSize: CGFloat = 25

    // callin section
    let callInFontSize: CGFloat = 25
    let callInFieldHeight: CGFloat = 30

    // canvas
    let canvasSize: CGFloat = 2000
    let canvasMinimumZoomScale: CGFloat = 0.25
    let canvasMaximumZoomScale: CGFloat = 10

    // ToolbarItem
    let eraserImageActive: String = "eraser"
    let saveImageActive: String = "square.and.arrow.down"
    let newImageActive: String = "plus"
    let deleteImageActive: String = "trash"
}
