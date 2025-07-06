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
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if remove {
            if !hidden {
                self
            }
        } else {
            self.opacity(hidden ? 0 : 1)
        }
    }
}

//general section
extension View {
func standardBottomBorder() -> some View {
      modifier(StandardBottomBorder())
    }

    func canvasBorder(isLocked: Bool) -> some View {
        modifier(CanvasBorder(isLocked: isLocked))
        }

  func standardSubViewPadding() -> some View {
    self
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
  }
    
    func standardEventSubViewPadding() -> some View {
       self
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}

struct StandardBottomBorder: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .overlay(
              Rectangle()
                .frame(height: appStyles.standardInnerFrameBorderWidth)  // Border thickness
                .foregroundColor(appStyles.standardFrameColor),  // Border color
              alignment: .bottom
            )
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct CanvasBorder: ViewModifier {
    let isLocked: Bool
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .overlay(
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                  .stroke(isLocked ? appStyles.canvasLockedColor : appStyles.canvasUnLockedColor, lineWidth: 1)
            )
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
    }
}

// logTime section

extension View {
  func timeSectionPadding() -> some View {
    self
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))

  }
}

struct TextFormatterStyle: ViewModifier {
    @Environment(\.appStyles) var appStyles
  func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.logTimeFont, size: appStyles.logTimeFontSize))
      .foregroundStyle(appStyles.standardFontColor)
      .contentTransition(.numericText())
  }
}

extension Text {
  @MainActor func logTimeStyleAndAnimation() -> some View {
    modifier(TextFormatterStyle())
  }
}

//locked section
