//
//  ProgressionView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 29.06.25.
//

import SwiftUI

struct ProgressionView: View {
    @Environment(\.appStyles) var appStyles
    
    var body: some View {
        
        HStack {
            
            ProgressView {
                HStack {
                    Text("Lade Logs...")
                        .ProgressionTextLabel(appStyles: appStyles)
                }
            }
            .progressViewStyle(.circular)
            .controlSize(.extraLarge)
            .tint(appStyles.progressionColor)
        }
        .presentationDetents([.large])
        .presentationBackground(.clear)
        .background(Color.clear)
    }
}

#Preview {
    ProgressionView()
}
