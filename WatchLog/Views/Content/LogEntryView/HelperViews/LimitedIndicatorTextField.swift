//
//  LimitedIndicatorTextField.swift
//  WatchLog
//
//  Created by Marcus Hörning on 10.07.25.
//

import SwiftUI

struct LimitedIndicatorTextField: View {
    // Configuration
    var config: Config
    var hint: String
    @Binding var text: String
    let isLocked: Bool

    @Environment(\.appStyles) var appStyles

    // view properties
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
        // VStack(alignment: config.progressConfig.alignment, spacing: 12) {
        ZStack(alignment: .trailing) {
            TextField(hint, text: $text, axis: .vertical)
                .if(config.textfieldLevel == TextFieldLevel.standard) { view in
                    view.textFieldIndicator(text: $text, isLocked: isLocked, textfieldType: config.textfieldType, appStyles: appStyles)
            }
                .if(config.textfieldLevel == TextFieldLevel.sub) { view in
                    view.subTextFieldIndicator(text: $text, isLocked: isLocked, textfieldType: config.textfieldType, appStyles: appStyles)
            }
           
                .focused($isKeyboardShowing)
                .onChange(of: text, initial: true) { _, _ in
                    guard !config.allowsExcessTyping else { return }
                    text = String(text.prefix(config.limit))
                }

//            //progress bar - text indicator
            HStack(alignment: .top, spacing: 0) {
                if config.progressConfig.showsRing && !isLocked && !text.isEmpty {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 4)

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor.gradient, lineWidth: 4)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.linear(duration: 0.25), value: progressColor)
                    }
                    .frame(width: 23, height: 23)
                }

                if config.progressConfig.showsText {
                    Text("\(text.count)/\(config.limit)")
                        .foregroundStyle(progressColor.gradient)
                }
            }
            .offset(x: -14)
            .animation(.easeOut(duration: 0.5), value: isLocked)
            .animation(.easeOut(duration: 0.5), value: !text.isEmpty)
        }
    }

    var progress: CGFloat {
        return max(min(CGFloat(text.count) / CGFloat(config.limit), 1), 0)
    }

    var progressColor: Color {
        return withAnimation { progress < 0.6 ? config.tint : progress == 1.0 ? .red : .orange }
    }

    // textfield config
    struct Config {
        var textfieldType: TextFieldType
        var textfieldLevel: TextFieldLevel
        var limit: Int
        var tint: Color = .blue
        var autoResizes: Bool = false
        var allowsExcessTyping: Bool = false
        var progressConfig: ProgressConfig = .init()
    }

    struct ProgressConfig {
        var showsRing: Bool = true
        var showsText: Bool = false
        var alignment: HorizontalAlignment = .trailing
    }
}
