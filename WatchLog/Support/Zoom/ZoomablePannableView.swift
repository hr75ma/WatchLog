//
//  ZoomView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.05.25.
//

import Foundation

import SwiftUI

struct ZoomablePannableView<Content: View>: View {
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero

    let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            content()
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = CGSize(
                                width: initialOffset.width + gesture.translation.width,
                                height: initialOffset.height + gesture.translation.height
                            )
                        }
                        .onEnded { _ in
                            initialOffset = offset
                        }
                        .simultaneously(with: MagnificationGesture()
                            .onChanged { value in
                                scale = max(1.0, value)
                            }
                            .onEnded { _ in
                                scale = max(1.0, scale)
                            }
                        )
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        scale = 1.0
                        offset = .zero
                        initialOffset = .zero
                    }
                }
                .animation(.easeInOut, value: scale)
        }
    }
}
