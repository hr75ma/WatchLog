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
      .foregroundStyle(isLocked ? .watchLogLocked : .watchLogFont)
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
      .foregroundStyle(.watchLogFont)
      .frame(width: 120, height: appStyles.labelFontSize, alignment: .topLeading)
      .multilineTextAlignment(.leading)
      .lineLimit(1)
      .fixedSize(horizontal: true, vertical: true)
  }
}

struct SubSectionTextLabelModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
  
    func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.labelFont, size: appStyles.labelFontSizeSub))
      .foregroundStyle(.watchLogFont)
      .frame(height: appStyles.labelFontSizeSub, alignment: .topLeading)
      .lineLimit(1)
      .fixedSize(horizontal: false, vertical: true)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
  }
}

struct SubSectionTextLabelWidthModifier: ViewModifier {
  let width: CGFloat
  @Environment(\.appStyles) var appStyles
  
  func body(content: Content) -> some View {
    content
          .font(Font.custom(appStyles.labelFont, size: appStyles.labelFontSizeSub))
          .foregroundStyle(.watchLogFont)
          .frame(width: width, height: appStyles.labelFontSizeSub, alignment: .topLeading)
          .lineLimit(1)
          .fixedSize(horizontal: false, vertical: true)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
  }
}

struct PickerTextModifier: ViewModifier {
  @Environment(\.appStyles) var appStyles
  
  func body(content: Content) -> some View {
    content
          .font(.title)
          .fontWeight(.semibold)
          .fontWidth(.standard)
          .fontDesign(.rounded)
          .foregroundStyle(.watchLogProcessionTypeFont)
  }
}

struct NavigationTitleModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
  func body(content: Content) -> some View {
    content
      .font(Font.custom(appStyles.navigationTitleFont, size: appStyles.navigationTitleFontSize))
      .foregroundStyle(.watchLogFont)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

extension Text {
func labelStyle(isLocked: Bool) -> some View {
    modifier(LabelFormatterStyle(isLocked: isLocked))
  }
    
    func sectionTextLabel() -> some View {
      self.modifier(SectionTextLabelModifier())
    }
    
    func subSectionTextLabel() -> some View {
      self.modifier(SubSectionTextLabelModifier())
    }
    
    func subSectionTextWidthLabel(width: CGFloat) -> some View {
        self.modifier(SubSectionTextLabelWidthModifier(width: width))
    }
    
    func pickerTextModifier() -> some View {
        self.modifier(PickerTextModifier())
    }
    
    func navigationTitleModifier() -> some View {
        self.modifier(NavigationTitleModifier())
    }
}


