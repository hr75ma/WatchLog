//
//  ProgressionStyle.swift
//  WatchLog
//
//  Created by Marcus Hörning on 03.07.25.
//

import Foundation
import SwiftUI

extension ContentView {
    func refreshProgressionBehavior(_ appStyles: StylesLogEntry) {
        // UIRefreshControl.appearance().tintColor = UIColor(appStyles.navigationRefreshProgressionColor)
        UIRefreshControl.appearance().attributedTitle = NSAttributedString(
            string: "Aktualisiere...",
            attributes: [
                NSAttributedString.Key.font: UIFont(
                    name: appStyles.navigationRefreshProgressionFont, size: appStyles.navigationRefreshProgressionRefreshFontSize)!,
            ])
    }
}

extension View {
    func ProgressionTextLabel(appStyles: StylesLogEntry) -> some View {
        modifier(
            ProgressionTextLabelModifier(appStyles: appStyles))
    }
}

struct ProgressionTextLabelModifier: ViewModifier {
    let appStyles: StylesLogEntry
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.progressionFont, size: appStyles.progressionFontSize))
            .foregroundStyle(.watchLogProgression)
    }
}
