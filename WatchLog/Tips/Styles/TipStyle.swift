//
//  TipStyle.swift
//  WatchLog
//
//  Created by Marcus Hörning on 29.06.25.
//

import SwiftUI
import TipKit

struct TipStylerTest: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            if let image = configuration.image {
                image
                    .font(.title2)
                    .foregroundStyle(.green)
            }
            if let title = configuration.title {
                title
                    .bold()
                    .font(.headline)
                    .textCase(.uppercase)
            }
            if let message = configuration.message {
                message
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .backgroundStyle(.thinMaterial)
        .overlay(alignment: .topTrailing) {
            // Close Button
            Image(systemName: "multiply")
                .font(.title2)
                .alignmentGuide(.top) { $0[.top] - 5 }
                .alignmentGuide(.trailing) { $0[.trailing] + 5 }
                .foregroundStyle(.secondary)
                .onTapGesture {
                    // Invalidate Reason
                    configuration.tip.invalidate(reason: .tipClosed)
                }
        }
        .padding()
    }
}

struct TipStyler: TipViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        if let title = configuration.title {
            title
                .bold()
                .font(.headline)
                .textCase(.uppercase)
        }
        if let message = configuration.message {
            message
                .foregroundStyle(.secondary)
        }
    }
}
