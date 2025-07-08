//
//  NavigatationTreeStyles.swift
//  WatchLog
//
//  Created by Marcus Hörning on 02.07.25.
//

import Foundation
import SwiftUI

extension List {
    func listStyleGeneral() -> some View {
        
        self
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
    }
}

extension NavigationSplitView {
    
     func navigationSplitViewStyles(_ appStyles: StylesLogEntry) -> some View {
        self
             .accentColor(.watchLogNavigationBarItem)
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
        self
            
            .font(.title2)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }
    
    func disclosureGroupStyleDay(_ appStyles: StylesLogEntry) -> some View {
        self
            .font(.title3)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
    }
    
}

struct SelectedRowBackgroundColor: ViewModifier {
    let isSelectedRow: Bool
    @Environment(\.colorScheme) var colorScheme
    
  func body(content: Content) -> some View {
    
      if isSelectedRow {
          content
              .listRowBackground(colorScheme == .dark ? LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(0.5), Color.watchLogNavigationTreeSelectedRow.opacity(1)], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.watchLogNavigationTreeSelectedRow.opacity(1), Color.watchLogNavigationTreeSelectedRow.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
      } else {
          content
                .listRowBackground(colorScheme == .dark ? LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(0.5), Color.watchLogNavigationTreeRow.opacity(1)], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Color.watchLogNavigationTreeRow.opacity(1), Color.watchLogNavigationTreeRow.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
      }
  }
}

extension Button {
    
    func selectedRowBackgroundColor(isSelectedRow: Bool) -> some View {
        modifier(SelectedRowBackgroundColor(isSelectedRow: isSelectedRow))
      }
}


extension Text {
    
    
    func navigationTreeLinkLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }

    func navigationTreeLinkSubLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(isSeletecedItem ? .watchLogNavigationTreeSelectedItemFont : .watchLogNavigationTreeFont)
            .font(.callout)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
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



