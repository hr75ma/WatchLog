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
    case subWithWidth
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
            .if(textLabelLevel == TextLabelLevel.section) { view in
                view
                    .font(Font.custom(appStyles.sectionLabelFont, size: appStyles.sectionLabelFontSize))
                    .frame(height: appStyles.sectionLabelFontSize, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            .if(textLabelLevel == TextLabelLevel.standard) { view in
                view
                    .font(.system(size: appStyles.labelFontSize))
                    .fontWeight(.regular)
                    .fontWidth(.standard)
                    .fontDesign(.rounded)
                    .frame(height: appStyles.labelFontSize, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            .if(textLabelLevel == TextLabelLevel.sub) { view in
                view
                    .font(.system(size: appStyles.labelFontSizeSub))
                    .fontWeight(.regular)
                    .fontWidth(.standard)
                    .fontDesign(.rounded)
                    .frame(height: appStyles.labelFontSizeSub, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
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

    func textLabel(textLabelLevel: TextLabelLevel, _ isDimmend: Bool = false, _ disableAnimation: Bool = false) -> some View {
        modifier(TextLabelModifier(textLabelLevel: textLabelLevel, isDimmend: isDimmend, disableAnimation: disableAnimation))
    }

    func navigationTitleModifier() -> some View {
        modifier(NavigationTitleModifier())
    }
}
