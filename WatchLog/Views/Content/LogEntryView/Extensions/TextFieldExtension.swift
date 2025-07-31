//
//  TextFieldExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

enum TextFieldType: CaseIterable, Codable {
    case singleLine
    case multiLine
}

enum TextFieldLevel: CaseIterable, Codable {
    case standard
    case sub
}

enum NumericTextInputMode: CaseIterable, Codable {
    case number
    case decimal
}

// globals
extension View {
    fileprivate func textFieldButtonClearButtonModifier(text: Binding<String>, isLocked: Bool, isShowing: Bool = true) -> some View {
        modifier(TextFieldButtonClearButtonModifier(text: text, isLocked: isLocked, isShowing: isShowing))
            .padding(.leading, 5)
            .padding(.trailing, 45)
            .padding(.vertical, 0)
    }

    fileprivate func textFieldIndicatorAndClearModifier(text: Binding<String>, config: TextFieldFloatingConfiguration) -> some View {
        modifier(TextFieldIndicatorAndClearModifier(text: text, config: config))
            .padding(.leading, 5)
            .padding(.trailing, 45)
            .padding(.vertical, 0)
    }

    fileprivate func textFieldLimitInputLength(text: Binding<String>, length: Int) -> some View {
        modifier(TextFieldLimitModifer(text: text, length: length))
    }

    fileprivate func innerPadding() -> some View {
        modifier(InnerPaddingModifier())
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .padding(.vertical, 0)
    }
}

fileprivate struct TextFieldButtonClearButtonModifier: ViewModifier {
    @Binding var text: String
    let isLocked: Bool
    let isShowing: Bool
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !text.isEmpty && !isLocked && isShowing {
                Button {
                    text = ""
                } label: {
                    Image(systemName: appStyles.clearButtonImage)
                        .resizable()
                        .frame(
                            width: appStyles.clearButtonSize, height: appStyles.clearButtonSize,
                            alignment: .center)
                        .foregroundStyle(.watchLogClearButtonImagePrimary, .watchLogClearButtonImageSecondary)
                }
                .offset(x: 30)
            }
        }
        // .animation(.smooth, value: isLocked)
        // .animation(.smooth, value: isShowing)
    }
}

fileprivate struct TextFieldIndicatorAndClearModifier: ViewModifier {
    @Binding var text: String
    var config: TextFieldFloatingConfiguration
    @Environment(\.appStyles) var appStyles
    @FocusState private var isKeyboardShowing: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            if !config.isLocked && !text.isEmpty && config.withClearButton {
                HStack(alignment: .top, spacing: 0) {
                    
                    if config.progressConfig.showsRing {
                        ZStack(alignment: .trailing) {
                            Circle()
                                .stroke(.ultraThinMaterial, lineWidth: 4)
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(progressColor.gradient, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                                .animation(.smooth, value: progressColor)
                                .animation(.smooth, value: progress)
                        }
                        .frame(width: 23, height: 23)
                    }
                    if config.progressConfig.showsText {
                        Text("\(text.count)/\(config.limit)")
                            .foregroundStyle(progressColor.gradient)
                    }
                }
                .overlay(
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: appStyles.clearButtonImage)
                            .resizable()
                            .frame(
                                width: appStyles.clearButtonSize, height: appStyles.clearButtonSize,
                                alignment: .center)
                            .foregroundStyle(.watchLogClearButtonImagePrimary, .watchLogClearButtonImageSecondary)
                    }
                    // .offset(x: 30)
                )
                .offset(x: 30)
                //.animation(.smooth, value: config.isLocked)
                //.animation(.smooth, value: !text.isEmpty)
            }
        }

        .focused($isKeyboardShowing)
        .onChange(of: text, initial: true) { _, newValue in
            guard !config.allowsExcessTyping else { return }
            guard let newValueLastChar = newValue.last else { return }
            if config.textfieldType == .multiLine {
                if newValueLastChar == "\n" {
                    isKeyboardShowing = false
                }
            }
            text = String(text.prefix(config.limit))
        }
    }

    var progress: CGFloat {
        return max(min(CGFloat(text.count) / CGFloat(config.limit), 1), 0)
    }

    var progressColor: Color {
        return withAnimation { progress < 0.6 ? .watchLogClearButtonIndicatorStart : progress == 1.0 ? .watchLogClearButtonIndicatorEnd : .watchLogClearButtonIndicatorMiddle }
    }
}

fileprivate struct TextFieldLimitModifer: ViewModifier {
    @Binding var text: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: $text.wrappedValue) { _, _ in
                text = String($text.wrappedValue.prefix(length))
            }
    }
}

fileprivate struct NumericTextInputFieldViewModifier: ViewModifier {
    @Binding var text: String
    let mode: NumericTextInputMode

    func body(content: Content) -> some View {
        content
            .keyboardType(mode == .number ? .numberPad : .decimalPad)
            .onChange(of: text) { _, newValue in
                let decimalSeparator = Locale.current.decimalSeparator ?? "."
                let numbers = "1234567890\(mode == .decimal ? decimalSeparator : "")"
                if newValue.components(separatedBy: decimalSeparator).count - 1 > 1 {
                    text = String(newValue.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0) }
                    if filtered != newValue {
                        text = filtered
                    }
                }
            }
    }
}

fileprivate struct InnerPaddingModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
                .background(.clear)
        }
        .background(.clear)
    }
}

// -----------------------------------------------------------

extension View {
    func numericTextInputField(_ mode: NumericTextInputMode = .number, text: Binding<String>) -> some View {
        modifier(NumericTextInputFieldViewModifier(text: text, mode: mode))
    }

    func textFieldIndicatorFloating(
        text: Binding<String>, config: TextFieldFloatingConfiguration) -> some View {
        modifier(
            TextFieldIndicatorFloating(
                text: text, config: config))
    }

    func subTextFieldIndicatorFloating(
        text: Binding<String>, config: TextFieldFloatingConfiguration) -> some View {
        modifier(
            TextFieldIndicatorFloating(
                text: text, config: config))
    }
}

struct TextFieldIndicatorFloating: ViewModifier {
    @Binding var text: String
    var config: TextFieldFloatingConfiguration

    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .textFieldIndicatorAndClearModifier(text: $text, config: config)
            .font(config.textfieldLevel == .standard ? .title : .title2)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .if(config.textfieldType == TextFieldType.singleLine) { view in
                view.lineLimit(1)
                    .frame(height: config.textfieldLevel == .standard ? appStyles.textFieldHeight : appStyles.textFieldSubHeight)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .if(config.textfieldType == TextFieldType.multiLine) { view in
                view.lineLimit(4, reservesSpace: true)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(.watchLogFont)
//            .background(
//                isLocked
//                    ? .watchLogTextfieldBackgoundLocked : .watchLogTextfieldBackgroundUnlocked
//            )
            .background(Color.clear)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(config.textfieldAutoCapitalization)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .disableAnimations(disableAnimation: config.disableAnimation)
            // .disableAnimations(disableAnimation: isLocked)
            .animation(.smooth, value: config.isLocked)
            .disabled(config.isLocked)
    }
}

// ---------------------------------------------------------------------------------------------

extension Text {
    func sectionSimulatedTextFieldSingleLine(isLocked: Bool) -> some View {
        modifier(
            SectionSimulatedTextFieldSingleLineModifier(isLocked: isLocked))
    }
}

fileprivate struct SectionSimulatedTextFieldSingleLineModifier: ViewModifier {
    let isLocked: Bool
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .innerPadding()
            .lineLimit(1)
            .foregroundStyle(.watchLogFont)
            .background(
                isLocked
                    ? .watchLogTextfieldBackgoundLocked : .watchLogTextfieldBackgroundUnlocked
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .fixedSize(horizontal: true, vertical: true)
    }
}
