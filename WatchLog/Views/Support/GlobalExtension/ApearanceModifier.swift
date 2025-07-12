//
//  ApearanceModifier.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.07.25.
//

import SwiftUI

public struct AppearanceUpdate: ViewModifier {
    @EnvironmentObject private var appSettings: AppSettings

    public func body(content: Content) -> some View {
        content
            .preferredColorScheme(appSettings.currentTheme.colorScheme)
    }
}

public extension View {
    func appearanceUpdate() -> some View {
        modifier(AppearanceUpdate())
    }
}

public struct AppSetting {
    public enum Appearance: Int, CaseIterable {
        case automatic
        case light
        case dark

        public var colorScheme: ColorScheme? {
            switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            case .automatic:
                return ColorScheme(.unspecified)
            }
        }
    }
}

public final class AppSettings: ObservableObject {
    @MainActor public static let shared = AppSettings()

    @AppStorage("currentAppearance") public var currentTheme: AppSetting.Appearance = .automatic
}
