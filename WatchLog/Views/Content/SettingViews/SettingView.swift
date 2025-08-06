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
    @Environment(LogEntryViewModel.self) var viewModel
    //@EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(ClosedEventFilter.self) var closedEventFilter
    
    
    @AppStorage("currentAppearance") private var appearanceSelection: AppSetting.Appearance = .dark

    var body: some View {
        @Bindable var closedFilter = closedEventFilter
        
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
            .frame(width: 450, height: 30)
            .padding(EdgeInsets(top: 0, leading: 0, bottom:50, trailing: 0))
            
            Picker(selection: $closedFilter.closedFilter) {
                ForEach(ClosedEventFilterType.allCases, id:\.self) { eventFilter in
                 
                    Text(eventFilter.localized)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            } label: {
                Text("Offene Ereignisse markieren")
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 450, height: 30)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
            Text(closedEventFilter.closedFilter.localized)
            
            Button {
                Task {
                    await viewModel.deleteLogBook()
                }
            } label: {
                Text("Datenbank löschen")
                    .font(.title3)
                    .foregroundStyle(.watchLogFont)
            }
        }
        .appearanceUpdate()
    }
}

#Preview {
    SettingView()
        .environment(\.appStyles, StylesLogEntry.shared)
}
