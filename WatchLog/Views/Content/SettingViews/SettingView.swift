//
//  SettingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI

enum ColorMode: Sendable, CaseIterable, Codable {
    case darkMode
    case lightMode
}

struct SettingView: View {
    @Environment(\.appStyles) var appStyles

    @AppStorage("currentAppearance") private var appearanceSelection: AppSetting.Appearance = .dark

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("WatchLog")
                .font(.largeTitle)
                .foregroundStyle(.watchLogFont)
                .contentTransition(.numericText())

            Text("Version 1.2 (Beta)")
                .font(.title)
                .foregroundStyle(.watchLogFont)
                .contentTransition(.numericText())

            Text("by HL")
                .font(.title2)
                .foregroundStyle(.watchLogFont)
                .contentTransition(.numericText())

            Picker(selection: $appearanceSelection) {
                Text("System")
                    .tag(AppSetting.Appearance.automatic)
                Text("Light")
                    .tag(AppSetting.Appearance.light)
                Text("Dark")
                    .tag(AppSetting.Appearance.dark)
            } label: {
                Text("Select Appearance")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 400, height: 30)
        }
        .appearanceUpdate()
    }
}

#Preview {
    SettingView()
        .environment(\.appStyles, StylesLogEntry.shared)
}
