//
//  LimitedIndicatorTextField.swift
//  WatchLog
//
//  Created by Marcus Hörning on 10.07.25.
//

import SwiftUI

struct TextFieldFloatingConfiguration {
    var textfieldType: TextFieldType
    var textfieldLevel: TextFieldLevel
    var textfieldAutoCapitalization: TextInputAutocapitalization = .never
    var limit: Int
    //var tint: Color = .blue
    var autoResizes: Bool = false
    var allowsExcessTyping: Bool = false
    var progressConfig: TextFieldFloatingProgressConfig = .init()
    var withClearButton: Bool = true
    var disableAnimation: Bool = false
    var isLocked: Bool = false
}

struct TextFieldFloatingProgressConfig {
    var showsRing: Bool = true
    var showsText: Bool = false
    var alignment: HorizontalAlignment = .trailing
}

struct LimitedIndicatorTextFieldFloating: View {
    @Binding var text: String
    var config: TextFieldFloatingConfiguration
    var hint: String
    @Environment(\.appStyles) var appStyles
    // view properties
    @FocusState private var isKeyboardShowing: Bool
    
    
    var body: some View {
        // VStack(alignment: config.progressConfig.alignment, spacing: 12) {
        ZStack(alignment: .trailing) {
            if config.textfieldType == .singleLine {
                TextField(hint, text: $text)
                    .if(config.textfieldLevel == TextFieldLevel.standard) { view in
                        view.textFieldIndicatorFloating(text: $text, isLocked: config.isLocked, disableAnimation: config.disableAnimation, textfieldType: config.textfieldType, appStyles: appStyles, autocapitalize: config.textfieldAutoCapitalization, withClearButton: config.withClearButton)
                    }
                    .if(config.textfieldLevel == TextFieldLevel.sub) { view in
                        view.subTextFieldIndicatorFloating(text: $text, isLocked: config.isLocked, disableAnimation: config.disableAnimation, textfieldType: config.textfieldType, appStyles: appStyles, autocapitalize: config.textfieldAutoCapitalization, withClearButton: config.withClearButton)
                    }
                    .focused($isKeyboardShowing)
                    .onChange(of: text, initial: true) { _, _ in
                        guard !config.allowsExcessTyping else { return }
                        text = String(text.prefix(config.limit))
                    }
            } else {
                if config.textfieldType == .multiLine {
                    TextField(hint, text: $text, axis: .vertical)
                        .if(config.textfieldLevel == TextFieldLevel.standard) { view in
                            view.textFieldIndicatorFloating(text: $text, isLocked: config.isLocked, disableAnimation: config.disableAnimation, textfieldType: config.textfieldType, appStyles: appStyles, autocapitalize: config.textfieldAutoCapitalization, withClearButton: config.withClearButton)
                        }
                        .if(config.textfieldLevel == TextFieldLevel.sub) { view in
                            view.subTextFieldIndicatorFloating(text: $text, isLocked: config.isLocked, disableAnimation: config.disableAnimation, textfieldType: config.textfieldType, appStyles: appStyles, autocapitalize: config.textfieldAutoCapitalization, withClearButton: config.withClearButton)
                        }
                        .focused($isKeyboardShowing)
                        .onChange(of: text, initial: true) { _, newValue in
                            guard !config.allowsExcessTyping else { return }
                            guard let newValueLastChar = newValue.last else { return }
                            if newValueLastChar == "\n" {
                                isKeyboardShowing = false
                            }
                            text = String(text.prefix(config.limit))
                        }
                }
            }

//            //progress bar - text indicator
            HStack(alignment: .top, spacing: 0) {
                if config.progressConfig.showsRing && !config.isLocked && !text.isEmpty && config.withClearButton {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 4)

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor.gradient, lineWidth: 4)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.smooth(duration: 0.15), value: progressColor)
                            .animation(.smooth(duration: 0.15), value: progress)
                    }
                    .frame(width: 23, height: 23)
                    .animation(.smooth, value: config.isLocked)
                    .animation(.smooth(duration: 0.5), value: !text.isEmpty)
                }

                if config.progressConfig.showsText {
                    Text("\(text.count)/\(config.limit)")
                        .foregroundStyle(progressColor.gradient)
                }
            }
            .offset(x: -14)
            
        }
    }

    var progress: CGFloat {
        return max(min(CGFloat(text.count) / CGFloat(config.limit), 1), 0)
    }

    var progressColor: Color {
        return withAnimation { progress < 0.6 ? .watchLogClearButtonIndicatorStart : progress == 1.0 ? .watchLogClearButtonIndicatorEnd : .watchLogClearButtonIndicatorMiddle }
    }
}

