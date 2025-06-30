//
//  SplashView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI
import TipKit

struct SplashView: View {
    @State var showSplashContent: Bool = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        HStack {
            if self.showSplashContent {
                SplashContent()
            } else {
                ContentView()
                    .task {
                        //try? Tips.resetDatastore()
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                        
                        //try? Tips.showAllTipsForTesting()
                    }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.showSplashContent = false
                }
            }
        }
        
    }
}

#Preview {
    SplashView()
}
