//
//  ViewModify.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

struct TextFieldButtonClearButtonModifier: ViewModifier {
    @Binding var text: String
    @Environment(\.appStyles) var appStyles
    
    func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: appStyles.ClearButtonImage)
                        .frame(width: 10, height: 10, alignment: .center)
                }
                .offset(x: 30)
            }
        }
        
    }
}

extension View {
    func textFieldButtonClearButton(_ text: Binding<String>) -> some View {
        modifier(TextFieldButtonClearButtonModifier(text: text))
            .padding(.leading, 12)
           .padding(.trailing, 45)
           .padding(.vertical, 0)
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
    func textFieldLimitInputLength(text: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(text: text, length: length))
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
    
extension View {
    func textFieldCheckOnNumbers(text: Binding<String>) -> some View {
        self.modifier(TextFieldCheckOnNumbersModifier(text: text))
    }
}



struct SectionTextFieldModifier: ViewModifier {
    let appStyles: StylesLogEntry
    @Binding var text: String
    let isLocked: Bool
    let numberOfCharacters: Int
    let textFieldFont: String
    let textFieldHeight: CGFloat
    
    func body(content: Content) -> some View {
            content
            .textFieldButtonClearButton($text)
            .font(Font.custom(textFieldFont, size: textFieldHeight))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: false, vertical: true)
            .textFieldLimitInputLength(text: $text, length: numberOfCharacters)
//            .overlay(
//                                Button(action: {
//                                    text = ""
//                                }) {
//                                    Image(systemName: "xmark.circle.fill")
//                                        .opacity(text.isEmpty ? 0 : 1).padding()
//                                }
//                                .padding(),
//                                alignment: .trailing
//                            )
            
            .animation(.easeInOut(duration: 1),  value: isLocked)
            .autocorrectionDisabled(true)
            .disabled(isLocked)
                }
    }

extension View {
    func sectionTextField(appStyles: StylesLogEntry, text: Binding<String>, isLocked: Bool, numberOfCharacters:Int) -> some View {
        self.modifier(SectionTextFieldModifier(appStyles: appStyles, text: text, isLocked: isLocked, numberOfCharacters: numberOfCharacters, textFieldFont: appStyles.TextFieldFont, textFieldHeight: appStyles.TextFieldHeight))
    }
}

extension View {
    func sectionTextFieldSubSection(appStyles: StylesLogEntry, text: Binding<String>, isLocked: Bool, numberOfCharacters:Int) -> some View {
        self.modifier(SectionTextFieldModifier(appStyles: appStyles, text: text, isLocked: isLocked, numberOfCharacters: numberOfCharacters, textFieldFont: appStyles.TextFieldFont, textFieldHeight: appStyles.TextFieldHeight2))
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



