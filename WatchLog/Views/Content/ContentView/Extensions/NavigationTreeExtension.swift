//
//  NavigatationTreeStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 02.07.25.
//

import Foundation
import SwiftUI

enum TextLevel: Int, CaseIterable, Codable {
    case standard
    case sub
}

extension List {
    func listStyleGeneral() -> some View {
        scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
    }
}

extension NavigationSplitView {
    func navigationSplitViewStyles(_ appStyles: StylesLogEntry) -> some View {
        accentColor(.watchLogNavigationBarItem)
            .symbolRenderingMode(.palette)
            .symbolEffect(.scale)
            .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(appStyles.navigationItemAnimationDuration))
    }
}

struct DisclosureGroupStyleYearModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .foregroundStyle(.watchLogNavigationTreeFont)
            .accentColor(.watchLogNavigationTree)
            .tint(.watchLogNavigationTree)
            .listRowSeparator(.automatic)
            .listRowSeparatorTint(.watchLogNavigationTreeRowSeparator)
            .font(.title)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)

            .listRowBackground(colorScheme == .dark ? LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(0.5), Color.watchLogNavigationTreeRow.opacity(1)], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(1), Color.watchLogNavigationTreeRow.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
    }
}

extension DisclosureGroup {
    func disclosureGroupStyleYearModifier() -> some View {
        modifier(DisclosureGroupStyleYearModifier())
    }

    func disclosureGroupStyleMonth(_ appStyles: StylesLogEntry) -> some View {
        font(.title2)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
    }

    func disclosureGroupStyleDay(_ appStyles: StylesLogEntry) -> some View {
        font(.title3)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
    }
}

struct SelectedRowBackgroundColor: ViewModifier {
    let isSelectedRow: Bool
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        let isSelectedDarkGradient = LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(0.5), Color.watchLogNavigationTreeSelectedRow.opacity(1)], startPoint: .leading, endPoint: .trailing)
        let isSelectedLightGradient = LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(1), Color.watchLogNavigationTreeSelectedRow.opacity(0.5)], startPoint: .leading, endPoint: .trailing)

        let notSelectedDarkGradient = LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(0.5), Color.watchLogNavigationTreeRow.opacity(1)], startPoint: .leading, endPoint: .trailing)
        let notSelectedLightGradient = LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(1), Color.watchLogNavigationTreeRow.opacity(0.5)], startPoint: .leading, endPoint: .trailing)

        content
            .listRowBackground(isSelectedRow ? colorScheme == .dark ? isSelectedDarkGradient : isSelectedLightGradient : colorScheme == .dark ? notSelectedDarkGradient : notSelectedLightGradient)
            .animation(.easeInOut(duration: 1), value: isSelectedRow)
    }
}

extension Button {
    func selectedRowBackgroundColor(isSelectedRow: Bool) -> some View {
        modifier(SelectedRowBackgroundColor(isSelectedRow: isSelectedRow))
    }
}

extension Rectangle {
    func selectedRowBackgroundAnimation(isSelectedRow: Bool, colorScheme: ColorScheme, appStyles: StylesLogEntry) -> some View {
        fill(isSelectedRow ? colorScheme == .dark ? LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(appStyles.navigationRowGradientOpacityStart), Color.watchLogNavigationTreeSelectedRow.opacity(appStyles.navigationRowGradientOpacityEnd)], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(appStyles.navigationRowGradientOpacityEnd), Color.watchLogNavigationTreeSelectedRow.opacity(appStyles.navigationRowGradientOpacityStart)], startPoint: .leading, endPoint: .trailing) : colorScheme == .dark ? LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(appStyles.navigationRowGradientOpacityStart), Color.watchLogNavigationTreeRow.opacity(appStyles.navigationRowGradientOpacityEnd)], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(appStyles.navigationRowGradientOpacityEnd), Color.watchLogNavigationTreeRow.opacity(appStyles.navigationRowGradientOpacityStart)], startPoint: .leading, endPoint: .trailing))
            .animation(.easeInOut(duration: appStyles.navigationRowAnimationDuration), value: isSelectedRow)
    }
}

struct NavigationTreeButtonLabelStyle: ViewModifier {
    let isSeletecedItem: Bool

    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .animation(.easeInOut(duration: appStyles.navigationItemAnimationDuration).speed(5), value: isSeletecedItem)
    }
}

struct NavigationTreeButtonSubLabelStyle: ViewModifier {
    let isSeletecedItem: Bool

    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.callout)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .animation(.easeInOut(duration: appStyles.navigationItemAnimationDuration).speed(5), value: isSeletecedItem)
    }
}

extension Text {
    func navigationTreeButtonLabelStyle(isSeletecedItem: Bool) -> some View {
        modifier(NavigationTreeButtonLabelStyle(isSeletecedItem: isSeletecedItem))
    }

    func navigationTreeButtonSubLabelStyle(isSeletecedItem: Bool) -> some View {
        modifier(NavigationTreeButtonSubLabelStyle(isSeletecedItem: isSeletecedItem))
    }

    func navigationTreeLinkLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .animation(.easeInOut(duration: appStyles.navigationItemAnimationDuration).speed(5), value: isSeletecedItem)
    }

    func navigationTreeLinkSubLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.callout)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .animation(.easeInOut(duration: appStyles.navigationItemAnimationDuration).speed(6), value: isSeletecedItem)
    }
}

struct NavigationBarBackground: ViewModifier {
    @Environment(\.appStyles) var appStyles
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.watchLogViewBackground)
    }
}

extension View {
    func navigationBarBackground() -> some View {
        modifier(NavigationBarBackground())
    }
}
