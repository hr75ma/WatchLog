//
//  LogBookEntryStyle.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.07.25.
//

import Foundation
import SwiftUI

extension View {
    // Hide or show a view based on a boolean value.
    //
    // Example for hiding while reclaiming space:
    //
    //     Text("Label")
    //         .isHidden(true)
    //
    // Example for hiding, but leaving a gap where the hidden item was:
    //
    //     Text("Label")
    //         .isHidden(true, remove: false)
    //
    // - Parameters:
    //   - hidden: whether to hide the view.
    //   - remove: whether you want to reclaim the space taken by the hidden view.
//    @ViewBuilder func isHidden(_ isHidden: Bool, remove: Bool = true) -> some View {
//        if remove {
//            if !isHidden {
//                self
//            }
//        } else {
//            opacity(isHidden ? 0 : 1)
//        }
//    }
    @ViewBuilder func isHidden(_ isHidden: Bool, remove: Bool = true) -> some View {
        if isHidden {
            if !remove {
                hidden()
            }
        } else {
            self
        }
    }
}

// general section
extension View {
    func standardSectionPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
    }

    func standardSectionContentPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 70, bottom: 20, trailing: 20))
    }

    func standardInputPadding() -> some View {
        padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
    }

    func timeSectionPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }

    func standardAdditionalTopPadding() -> some View {
        padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }

    func standardSubSectionContentPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
    }

    func standardBottomBorder() -> some View {
        modifier(StandardBottomBorder())
    }

    func canvasBorder(isLocked: Bool) -> some View {
        modifier(CanvasBorder(isLocked: isLocked))
    }

    func standardScrollViewPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    func zeroViewPadding() -> some View {
        padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    func standardLogEntryViewPadding() -> some View {
        padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
    }

    func standardViewBackground() -> some View {
        modifier(StandardViewBackground())
    }

    func blurring(blurSetting: BlurSetting) -> some View {
        blur(radius: blurSetting.isBlur ? blurSetting.blurRadius : 0)
            .animation(.smooth(duration: blurSetting.animationDuration), value: blurSetting.isBlur)
    }
}

struct StandardViewBackground: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .background(.watchLogViewBackground)
    }
}

struct StandardBottomBorder: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .frame(height: appStyles.standardInnerFrameBorderWidth) // Border thickness
                    .foregroundColor(.watchLogFrameBorder), alignment: .bottom)
            .clipShape(.rect(cornerRadius: 20))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct CanvasBorder: ViewModifier {
    let isLocked: Bool
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        isLocked ? .watchLogLocked : .watchLogFrameBorder, lineWidth: appStyles.canvasBorderLineWidth)
            )
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 0))
    }
}

struct TextFormatterStyle: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.logTimeFont, size: appStyles.logTimeFontSize))
            .foregroundStyle(.watchLogFont)
        // .contentTransition(.numericText())
    }
}

extension Text {
    @MainActor func logTimeStyleAndAnimation() -> some View {
        modifier(TextFormatterStyle())
    }
}

// locked section
