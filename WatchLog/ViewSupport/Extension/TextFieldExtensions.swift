//
//  ViewModify.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String
    @FocusState var isFocused: Bool
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .overlay {
                if isFocused && !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: appStyles.ClearButtonImage)
                                .frame(width: 18, height: 18, alignment: .center)
                        }
                        .foregroundStyle(appStyles.ClearButtonColorActivePrimary, appStyles.ClearButtonColorActiveSecondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}





struct TextFieldLimitModifer: ViewModifier {
    @Binding var text: String
    var length: Int

    func body(content: Content) -> some View {
            content
                .onChange(of: $text.wrappedValue) { old, new in
                    text = String($text.wrappedValue.prefix(length))
                }
    }
}

extension View {
    func limitInputLength(text: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(text: text, length: length))
    }
}

struct TextFieldCheckOnNumbers: ViewModifier {
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
    
extension View {
    func checkOnNumbers(text: Binding<String>) -> some View {
        self.modifier(TextFieldCheckOnNumbers(text: text))
    }
}








extension Text {
    
    func SectionTextFieldSimulatedSingleLine(_ appStyles: StylesLogEntry, isLocked: Bool) -> some View {
        self
            .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: true, vertical: true)
            //.textContentType(.telephoneNumber)
            
    }
    
    func SectionTextFieldSecondSimulatedSingleLine(_ appStyles: StylesLogEntry, isLocked: Bool) -> some View {
        self
            .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight2))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: true, vertical: true)
            //.textContentType(.telephoneNumber)
    }
    
    func SectionTextLabelSecond(_ appStyles: StylesLogEntry) -> some View {
      self
        .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight2))
        .foregroundStyle(appStyles.GeneralTextColor)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .fixedSize(horizontal: false, vertical: true)

    }
    
    
    func TextLabel(font: String, fontSize: CGFloat, fontColor: Color) -> some View {
        self
            .font(Font.custom(font, size: fontSize))
            .foregroundStyle(fontColor)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            }
    
    func SectionTextLabel(_ appStyles: StylesLogEntry) -> some View {
        self
            .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight))
            .foregroundStyle(appStyles.GeneralTextColor)
            .frame(width: 120, height: appStyles.TextFieldHeight, alignment: .topLeading)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
    }
    
    func SectionTextLabelForToggle(_ appStyles: StylesLogEntry) -> some View {
        self
            .font(Font.custom(appStyles.LabelFont, size: appStyles.LabelFontSize2))
            .foregroundStyle(appStyles.GeneralTextColor)
            .frame(height: appStyles.TextFieldHeight, alignment: .center)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
    }
}

extension TextField {
    
    
    
    func SectionTextFieldSingleLine(_ appStyles: StylesLogEntry, isLocked: Bool) -> some View {
        self
            .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: false, vertical: true)
            .textContentType(.telephoneNumber)
            .animation(.easeInOut(duration: 1),  value: isLocked)
    }
    
    func SectionTextFieldSingleLine(_ appStyles: StylesLogEntry) -> some View {
        self
            .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: false, vertical: true)
            .textContentType(.telephoneNumber)
    }
    
    func SectionTextFieldSingleLineSecond(_ appStyles: StylesLogEntry)
      -> some View
    {
      self
        .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight2))
        .textInputAutocapitalization(.characters)
        .lineLimit(1)
        .foregroundStyle(appStyles.GeneralTextColor)
        .background(appStyles.TextfieldBackgroundColor)
        .fixedSize(horizontal: false, vertical: true)
        .textContentType(.telephoneNumber)
    }

    func SectionTextFieldSingleLineSecond(
      _ appStyles: StylesLogEntry, isLocked: Bool
    )
      -> some View
    {
      self
        .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight2))
        .textInputAutocapitalization(.characters)
        .lineLimit(1)
        .foregroundStyle(appStyles.GeneralTextColor)
        .background(
          isLocked
            ? appStyles.TextfieldBackgroundColorLocked
            : appStyles.TextfieldBackgroundColorUnLocked
        )
        .fixedSize(horizontal: false, vertical: true)
        .textContentType(.telephoneNumber)
        .animation(.easeInOut(duration: 1), value: isLocked)
    }
}


