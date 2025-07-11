//
//  SplashContent.swift
//  WatchLog
//
//  Created by Marcus Hörning on 04.06.25.
//

import SwiftUI

struct SplashContent: View {
    @State private var animation = false

    private var image: some View {
        Image("watchLog")
            .resizable()
            .scaledToFit()
            .frame(width: 600, height: 600)
    }

    private let aninmationTimer = Timer
        .publish(every: 1.5, on: .current, in: .common)
        .autoconnect()

    private func launchAnimation() {
        withAnimation(.easeInOut(duration: 1)) {
            animation.toggle()
        }
    }

    var body: some View {
        ZStack {
            image
        }.onReceive(aninmationTimer) { _ in
            launchAnimation()
        }.opacity(animation ? 0 : 1)
    }
}

#Preview {
    SplashContent()
}
