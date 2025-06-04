//
//  SplashView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI

struct SplashView: View {
    @State var showSplashContent: Bool = true
    
    
    var body: some View {
        
        HStack {
            if self.showSplashContent {
                SplashContent()
            } else {
                ContentView()
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
