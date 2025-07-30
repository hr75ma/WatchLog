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

// globals
extension View {
    fileprivate func textFieldButtonClearButton(text: Binding<String>, isLocked: Bool) -> some View {
        modifier(TextFieldButtonClearButtonModifier(text: text, isLocked: isLocked))
            .padding(.leading, 5)
            .padding(.trailing, 45)
            .padding(.vertical, 0)
    }

    fileprivate func textFieldLimitInputLength(text: Binding<String>, length: Int) -> some View {
        modifier(TextFieldLimitModifer(text: text, length: length))
    }

    func textFieldCheckOnNumbers(text: Binding<String>) -> some View {
        modifier(TextFieldCheckOnNumbersModifier(text: text))
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
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !text.isEmpty && !isLocked {
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

struct TextFieldCheckOnNumbersModifier: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .onChange(of: $text.wrappedValue) { old, new in
                if !new.allSatisfy(\.isNumber) {
                    text = old
                }
            }
    }
}

enum NumericTextInputMode {
    case number
    case decimal
}

struct NumericTextInputFieldViewModifier: ViewModifier {
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

extension View {
    func numericTextInputField(_ mode: NumericTextInputMode = .number, text: Binding<String>) -> some View {
        modifier(NumericTextInputFieldViewModifier(text: text, mode: mode))
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
    func textFieldIndicator(
        text: Binding<String>, isLocked: Bool, disableAnimation: Bool, textfieldType: TextFieldType, appStyles: StylesLogEntry
    ) -> some View {
        modifier(
            TextFieldIndicator(
                text: text, isLocked: isLocked, disableAnimation: disableAnimation, textfieldType: textfieldType, textFieldHeight: appStyles.textFieldHeight, font: Font.title))
    }

    func textFieldIndicatorFloating(
        text: Binding<String>, isLocked: Bool, disableAnimation: Bool, textfieldType: TextFieldType, appStyles: StylesLogEntry
    ) -> some View {
        modifier(
            TextFieldIndicatorFloating(
                text: text, isLocked: isLocked, disableAnimation: disableAnimation, textfieldType: textfieldType, textFieldHeight: appStyles.textFieldHeight, font: Font.title))
    }

    func subTextFieldIndicator(
        text: Binding<String>, isLocked: Bool, disableAnimation: Bool, textfieldType: TextFieldType, appStyles: StylesLogEntry
    ) -> some View {
        modifier(
            TextFieldIndicator(
                text: text, isLocked: isLocked, disableAnimation: disableAnimation,
                textfieldType: textfieldType, textFieldHeight: appStyles.textFieldSubHeight, font: Font.title2))
    }

    func subTextFieldIndicatorFloating(
        text: Binding<String>, isLocked: Bool, disableAnimation: Bool, textfieldType: TextFieldType, appStyles: StylesLogEntry
    ) -> some View {
        modifier(
            TextFieldIndicatorFloating(
                text: text, isLocked: isLocked, disableAnimation: disableAnimation,
                textfieldType: textfieldType, textFieldHeight: appStyles.textFieldSubHeight, font: Font.title2))
    }
}

struct TextFieldIndicator: ViewModifier {
    @Binding var text: String
    let isLocked: Bool
    let disableAnimation: Bool
    let textfieldType: TextFieldType
    let textFieldHeight: CGFloat
    let font: Font
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .textFieldButtonClearButton(text: $text, isLocked: isLocked)
            .font(font)
            .fontWeight(.regular)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .if(textfieldType == TextFieldType.singleLine) { view in
                view.lineLimit(1)
                    .frame(height: textFieldHeight)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .if(textfieldType == TextFieldType.multiLine) { view in
                view.lineLimit(4, reservesSpace: true)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(.watchLogFont)
            .background(
                isLocked
                    ? .watchLogTextfieldBackgoundLocked : .watchLogTextfieldBackgroundUnlocked
            )
            .autocorrectionDisabled(true)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .disableAnimations(disableAnimation: disableAnimation)
            .animation(.smooth(duration: 1), value: isLocked)
            .disabled(isLocked)
    }
}

struct TextFieldIndicatorFloating: ViewModifier {
    @Binding var text: String
    let isLocked: Bool
    let disableAnimation: Bool
    let textfieldType: TextFieldType
    let textFieldHeight: CGFloat
    let font: Font
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .textFieldButtonClearButton(text: $text, isLocked: isLocked)
            .font(font)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .if(textfieldType == TextFieldType.singleLine) { view in
                view.lineLimit(1)
                    .frame(height: textFieldHeight)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .if(textfieldType == TextFieldType.multiLine) { view in
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
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .disableAnimations(disableAnimation: disableAnimation)
            .animation(.smooth(duration: 1), value: isLocked)
            .disabled(isLocked)
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
