//
//  ToggleView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 09.05.25.
//

import SwiftUI

struct ToggleView: View {
        let text: LocalizedStringKey
        @Binding var isOn: Bool
        // -------------- New in Step 2
        private var circleOffset: CGFloat {
            isOn ? 11 : -11
        }
        var body: some View {
            HStack {
                Text(text)
                Spacer()
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(isOn ? .orange : .accentColor)
                    .frame(width: 51,
                           height: 31)
                    .overlay(
                        Circle()
                            .frame(width: 25,
                                   height: 25)
                            .foregroundColor(.white)
                            .padding(3)
                            .overlay(
                                Image(systemName: isOn ? "checkmark" : "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .font(.title.weight(.bold))
                                    .frame(width: 10,
                                           height: 10)
                                    .foregroundColor(isOn ? .orange : .accentColor)
                            )
                            .offset(x: circleOffset)
                    )
                    // -------------- New in Step 4
                    .animation(.linear(duration: 0.15), value: isOn)
                    .onTapGesture { isOn.toggle() }
            }
        }
    }
