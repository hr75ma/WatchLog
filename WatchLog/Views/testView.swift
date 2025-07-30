//
//  testView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 14.07.25.
//

import SwiftUI

struct testView: View {
    var body: some View {
        
        VStack {
            Image(.placeholder)
        }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Eintrag")
                       // .navigationTitleModifier()
                }

            }
            .toolbarBackground(.visible, for: .automatic)
    }
}

#Preview {
    testView()
}
