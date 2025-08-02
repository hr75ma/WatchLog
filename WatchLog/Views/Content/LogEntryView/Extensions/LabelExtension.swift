//
//  LabelExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

enum TextLabelLevel: CaseIterable, Codable {
    case section
    case standard
    case sub
}

private struct LabelFormatterStyle: ViewModifier {
    let isLocked: Bool
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.sectionLabelFont, size: appStyles.sectionLabelFontSize))
            .foregroundStyle(isLocked ? .watchLogLocked : .watchLogFont)
            .frame(width: 170, height: appStyles.sectionLabelFontSize, alignment: .leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            .lineSpacing(0)
    }
}

private struct TextLabelModifier: ViewModifier {
    let textLabelLevel: TextLabelLevel
    let isDimmend: Bool
    let disableAnimation: Bool

    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .font(textLabelLevel == TextLabelLevel.section ? Font.custom(appStyles.sectionLabelFont, size: appStyles.sectionLabelFontSize) :
                 
                textLabelLevel == TextLabelLevel.standard ? .system(size: appStyles.labelFontSize) :
                    
                    textLabelLevel == TextLabelLevel.sub ? .system(size: appStyles.labelFontSizeSub) : .largeTitle
            )
            .frame(height: textLabelLevel == TextLabelLevel.section ? appStyles.sectionLabelFontSize :
                    
                    textLabelLevel == TextLabelLevel.standard ? appStyles.labelFontSize :
                        
                    textLabelLevel == TextLabelLevel.sub ? appStyles.labelFontSizeSub : 35

            )
            .fontWeight(textLabelLevel != TextLabelLevel.section ? .regular : nil)
            .fontWidth(textLabelLevel != TextLabelLevel.section ? .standard : nil)
            .fontDesign(textLabelLevel != TextLabelLevel.section ? .rounded : nil)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .foregroundStyle(isDimmend ? .watchLogFont.opacity(0.5) : .watchLogFont.opacity(1))
            .disableAnimations(disableAnimation: disableAnimation)
            .animation(.smooth, value: isDimmend)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
    }
}

struct NavigationTitleModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            //.font(Font.custom(appStyles.navigationTitleFont, size: appStyles.navigationTitleFontSize))
            .font(.system(size: appStyles.navigationTitleFontSize, weight: .light, design: .rounded))
            .foregroundStyle(.watchLogFont)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

extension Text {
    func labelStyle(isLocked: Bool) -> some View {
        modifier(LabelFormatterStyle(isLocked: isLocked))
    }

    func textLabel(textLabelLevel: TextLabelLevel, isDimmend: Bool = false, disableAnimation: Bool = false) -> some View {
        modifier(TextLabelModifier(textLabelLevel: textLabelLevel, isDimmend: isDimmend, disableAnimation: disableAnimation))
    }

    func navigationTitleModifier() -> some View {
        modifier(NavigationTitleModifier())
    }
}
