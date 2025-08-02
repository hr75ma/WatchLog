//
//  NavigationMenuExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.07.25.
//

import SwiftUI

enum MenuType: Int, CaseIterable {
    case new
    case save
    case delete
    case clear
    case edit
    case section
}

enum ImageColorationType: Int, CaseIterable {
    case monochrome
    case palette
}

struct NavigationMenuLabelView: View {
    let menuItemType: MenuType
    @Environment(\.appStyles) var appStyles
    
    var body: some View {
        switch menuItemType {
        case .new:
            Label("Neues Log", systemImage: appStyles.navigationAddImage)
                .navigationMenuUndestructiveModifier()
        case .save:
            Label("Speichern", systemImage: appStyles.saveImageActive)
                .navigationMenuUndestructiveModifier()
        case .delete:
            Label("Löschen", systemImage: appStyles.deleteImageActive)
                .navigationMenuDestructiveModifier()
        case .clear:
            Label("Log leeren", systemImage: appStyles.eraserImageActive)
                .navigationMenuDestructiveModifier()
        case .edit:
            Label("Log editieren", systemImage: appStyles.saveImageActive)
                .navigationMenuUndestructiveModifier()
        case .section:
            Label("Log editieren", systemImage: appStyles.saveImageActive)
                .navigationMenuUndestructiveModifier()
        }
    }
}

private struct NavigationMenuDestructiveModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .symbolRenderingMode(.palette)
            .foregroundStyle(
                .watchLogDestructive, .watchLogDestructive
            )
            .labelStyle(.titleAndIcon)
    }
}

private struct NavigationMenuUndestructiveModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .symbolRenderingMode(.palette)
            .foregroundStyle(
                .watchLogUndestructive, .watchLogUndestructive
            )
            .labelStyle(.titleAndIcon)
    }
}

extension Label {
    fileprivate func navigationMenuDestructiveModifier() -> some View {
        modifier(NavigationMenuDestructiveModifier())
    }

    fileprivate func navigationMenuUndestructiveModifier() -> some View {
        modifier(NavigationMenuUndestructiveModifier())
    }
}

extension Image {
    @MainActor func navigationToolBarSymbolModifier(colorationType: ImageColorationType, appStyles: StylesLogEntry) -> some View {
        symbolRenderingMode(.palette)
            .resizable()
            .scaledToFit()
            .frame(width: appStyles.navigationItemImageSize, height: appStyles.navigationItemImageSize, alignment: .center)
            .foregroundStyle(colorationType == .monochrome ? .watchLogToolbarColorPrimary : colorationType == .palette ? .watchLogToolbarColorAccent : .watchLogToolbarColorPrimary, colorationType == .monochrome ? .watchLogToolbarColorPrimary : colorationType == .palette ? .watchLogToolbarColorPrimary : .watchLogToolbarColorPrimary)
        
        
               
//            .if(colorationType == .monochrome) { view in
//                view
//                    .foregroundStyle(
//                        .watchLogToolbarColorPrimary, .watchLogToolbarColorPrimary)
//            }
//            .if(colorationType == .palette) { view in
//                view
//                    .foregroundStyle(
//                        .watchLogToolbarColorAccent, .watchLogToolbarColorPrimary)
//            }
            .symbolEffect(.pulse.wholeSymbol, options: .nonRepeating)
    }
}

struct globalMenuStyle: MenuStyle {
    @Environment(\.appStyles) var appStyles
    
    func makeBody(configuration: Configuration) -> some View {
            Menu(configuration)
                .background(.red)
        }
}
