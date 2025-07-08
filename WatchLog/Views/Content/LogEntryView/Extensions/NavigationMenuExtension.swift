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
}

struct NavigationMenuLabelView: View {
    let menuItemType: MenuType
    @Environment(\.appStyles) var appStyles
    
    var body: some View {
        
        switch menuItemType {
        case .new:
            Label("Neues Log", systemImage: appStyles.newImageActive)
                  .navigationMenuUndestructiveModifier()
        case .save:
            Label("Log Speichern", systemImage: appStyles.saveImageActive)
                  .navigationMenuUndestructiveModifier()
        case .delete:
            Label("Log Löschen", systemImage: appStyles.deleteImageActive)
                  .navigationMenuDestructiveModifier()
        case .clear:
            Label("Log leeren", systemImage: appStyles.eraserImageActive)
                  .navigationMenuDestructiveModifier()
            
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
        self.modifier(NavigationMenuDestructiveModifier())
    }
    
    fileprivate func navigationMenuUndestructiveModifier() -> some View {
        self.modifier(NavigationMenuUndestructiveModifier())
    }
}






extension Image {
    
    func navigationMenuSymbolModifier() -> some View {
      self
            .symbolRenderingMode(.palette)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30, alignment: .center)
            .foregroundStyle(
              .watchLogToolBarContextColorActivePrimary, .watchLogToolBarContextColorActiveSecondary
            )
            .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6))
    }
}




