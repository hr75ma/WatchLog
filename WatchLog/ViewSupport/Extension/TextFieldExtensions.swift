//
//  ViewModify.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI



extension View {
    func textFieldButtonClearButton(_ text: Binding<String>) -> some View {
        modifier(TextFieldButtonClearButtonModifier(text: text))
            .padding(.leading, 12)
           .padding(.trailing, 45)
           .padding(.vertical, 0)
    }
    
    func textFieldLimitInputLength(text: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(text: text, length: length))
    }
    
    func textFieldCheckOnNumbers(text: Binding<String>) -> some View {
        self.modifier(TextFieldCheckOnNumbersModifier(text: text))
    }
    
    func sectionTextField(appStyles: StylesLogEntry, text: Binding<String>, isLocked: Bool, numberOfCharacters:Int) -> some View {
        self.modifier(SectionTextFieldModifier(appStyles: appStyles, text: text, isLocked: isLocked, numberOfCharacters: numberOfCharacters, textFieldFont: appStyles.TextFieldFont, textFieldHeight: appStyles.TextFieldHeight))
    }
    
    func sectionTextFieldSubSection(appStyles: StylesLogEntry, text: Binding<String>, isLocked: Bool, numberOfCharacters:Int) -> some View {
        self.modifier(SectionTextFieldModifier(appStyles: appStyles, text: text, isLocked: isLocked, numberOfCharacters: numberOfCharacters, textFieldFont: appStyles.TextFieldFont, textFieldHeight: appStyles.TextFieldHeight2))
    }
    
    func sectionTextFieldSimulated(appStyles: StylesLogEntry, text: Binding<String>, isLocked: Bool, numberOfCharacters:Int) -> some View {
        self.modifier(SectionTextFieldSimulatedModifier(appStyles: appStyles, text: text, isLocked: isLocked, numberOfCharacters: numberOfCharacters, textFieldFont: appStyles.TextFieldFont, textFieldHeight: appStyles.TextFieldHeight))
    }
}


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
            .animation(.easeInOut(duration: 1),  value: isLocked)
            .autocorrectionDisabled(true)
            .disabled(isLocked)
                }
    }

struct SectionTextFieldSimulatedModifier: ViewModifier {
    let appStyles: StylesLogEntry
    @Binding var text: String
    let isLocked: Bool
    let numberOfCharacters: Int
    let textFieldFont: String
    let textFieldHeight: CGFloat
    
    func body(content: Content) -> some View {
            content
            .font(Font.custom(textFieldFont, size: textFieldHeight))
            .lineLimit(1)
            .foregroundStyle(appStyles.GeneralTextColor)
            .background(isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
            .fixedSize(horizontal: false, vertical: true)
            .textFieldLimitInputLength(text: $text, length: numberOfCharacters)
            .animation(.easeInOut(duration: 1),  value: isLocked)
            .autocorrectionDisabled(true)
            .disabled(isLocked)
                }
    }







extension View {
    
    func sectionTextLabel(appStyles: StylesLogEntry) -> some View {
        self.modifier(SectionTextLabelModifier(appStyles: appStyles))
    }
    
    func sectionTextLabelSub(appStyles: StylesLogEntry, width: CGFloat=0) -> some View {
            self.modifier(SectionTextLabelSubModifier(appStyles: appStyles))
    }
    
    func sectionTextLabelSubWidth(appStyles: StylesLogEntry) -> some View {
            self.modifier(SectionTextLabelSubModifierWidth(appStyles: appStyles, width: 215))
    }
}


struct SectionTextLabelModifier: ViewModifier {
    let appStyles: StylesLogEntry
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight))
            .foregroundStyle(appStyles.GeneralTextColor)
            .frame(width: 120, height: appStyles.TextFieldHeight, alignment: .topLeading)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
    }
}

extension View {

}

struct SectionTextLabelSubModifier: ViewModifier {
    let appStyles: StylesLogEntry
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight2))
            .frame(height: appStyles.TextFieldHeight2, alignment: .topLeading)
            .foregroundStyle(appStyles.GeneralTextColor)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            
        }
    }

struct SectionTextLabelSubModifierWidth: ViewModifier {
    let appStyles: StylesLogEntry
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight2))
            .frame(height: appStyles.TextFieldHeight2, alignment: .topLeading)
            .frame(width: width, height: appStyles.TextFieldHeight2, alignment: .topLeading)
            .foregroundStyle(appStyles.GeneralTextColor)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            
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
    
    func TextLabel(font: String, fontSize: CGFloat, fontColor: Color) -> some View {
        self
            .font(Font.custom(font, size: fontSize))
            .foregroundStyle(fontColor)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
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



