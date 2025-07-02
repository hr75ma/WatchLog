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

extension DisclosureGroup {
    
    private func disclosureGroupStyleGeneral(_ appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(appStyles.navigationTreeFontColor)
            .accentColor(appStyles.navigationTreeColor)
            .tint(appStyles.navigationTreeColor)
            //.listRowBackground(appStyles.navigationTreeRowColor)
            .listRowSeparator(.automatic)
            .listRowSeparatorTint(appStyles.navigationTreeRowSeparatorColor)
    }
    
    
    func disclosureGroupStyleYear(_ appStyles: StylesLogEntry) -> some View {
        self
            .disclosureGroupStyleGeneral(appStyles)
            .font(.title)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .listRowBackground(appStyles.navigationTreeRowColor)
            
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
            .listRowBackground(isSelectedRow ? appStyles.navigationTreeSelectedRowColor : appStyles.navigationTreeRowColor)
    }
}


extension Text {
    
    
    func navigationTreeLinkLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(isSeletecedItem ? appStyles.navigationTreeSelectedItemFontColor : appStyles.navigationTreeFontColor)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }

    func navigationTreeLinkSubLabelStyle(isSeletecedItem: Bool, appStyles: StylesLogEntry) -> some View {
        self
            .foregroundStyle(isSeletecedItem ? appStyles.navigationTreeSelectedItemFontColor : appStyles.navigationTreeFontColor)
            .font(.callout)
            .fontWeight(.medium)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            
    }
}



