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

extension DisclosureGroup {
    
    private func disclosureGroupStyleGeneral(_ appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(.watchLogNavigationTreeFont)
            .accentColor(.watchLogNavigationTree)
            .tint(.watchLogNavigationTree)
            .listRowSeparator(.automatic)
            .listRowSeparatorTint(.watchLogNavigationTreeRowSeparator)
    }
    
    
    func disclosureGroupStyleYear(_ appStyles: StylesLogEntry) -> some View {
        self
            .disclosureGroupStyleGeneral(appStyles)
            .font(.title)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .listRowBackground(Color.watchLogNavigationTreeRow)
            
    }
    
    func disclosureGroupStyleMonth(_ appStyles: StylesLogEntry) -> some View {
        self
            .disclosureGroupStyleGeneral(appStyles)
            .font(.title2)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }
    
    func disclosureGroupStyleDay(_ appStyles: StylesLogEntry) -> some View {
        self
            .disclosureGroupStyleGeneral(appStyles)
            .font(.title3)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }
    
}

extension Button {
    
    func selectedRowBackgroundColor(isSelectedRow: Bool, _ appStyles: StylesLogEntry) -> some View {
        self
            .listRowBackground(isSelectedRow ? Color.watchLogNavigationTreeSelectedRow : Color.watchLogNavigationTreeRow)
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



