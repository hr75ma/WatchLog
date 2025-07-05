//
//  LabelExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

struct LabelFormatterStyle: ViewModifier {
  let isLocked: Bool
    @Environment(\.appStyles) var appStyles
  func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.labelFont, size: appStyles.labelFontSize))
      .foregroundStyle(isLocked ? appStyles.standardLockedColor : appStyles.standardFontColor)
      .frame(width: 170, height: appStyles.labelFontSize, alignment: .leading)
      .lineLimit(1)
      .fixedSize(horizontal: true, vertical: true)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
      .lineSpacing(0)
  }
}

struct SectionTextLabelModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
  func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.labelFont, size: appStyles.labelFontSize))
      .foregroundStyle(appStyles.standardFontColor)
      .frame(width: 120, height: appStyles.labelFontSize, alignment: .topLeading)
      .multilineTextAlignment(.leading)
      .lineLimit(1)
      .fixedSize(horizontal: true, vertical: true)
  }
}

extension Text {
  @MainActor func labelStyle(isLocked: Bool) -> some View {
    modifier(LabelFormatterStyle(isLocked: isLocked))
  }
    
    func sectionTextLabel() -> some View {
      self.modifier(SectionTextLabelModifier())
    }
    
}
