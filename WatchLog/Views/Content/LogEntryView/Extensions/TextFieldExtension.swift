//
//  TextFieldExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI


extension View {

  func textFieldButtonClearButton(text: Binding<String>, isLocked: Bool) -> some View {
    modifier(TextFieldButtonClearButtonModifier(text: text, isLocked: isLocked))
      .padding(.leading, 5)
      .padding(.trailing, 45)
      .padding(.vertical, 0)
  }

  func textFieldLimitInputLength(text: Binding<String>, length: Int) -> some View {
    self.modifier(TextFieldLimitModifer(text: text, length: length))
  }

  func textFieldCheckOnNumbers(text: Binding<String>) -> some View {
    self.modifier(TextFieldCheckOnNumbersModifier(text: text))
  }
}

extension TextField {
    

  func sectionTextField(
    text: Binding<String>, isLocked: Bool, numberOfCharacters: Int, appStyles: StylesLogEntry
  ) -> some View {
    self.modifier(
      SectionTextFieldModifier(
        text: text, isLocked: isLocked,
        numberOfCharacters: numberOfCharacters, textFieldHeight: appStyles.textFieldHeight))
  }
    
    func sectionTextFieldMultiline(
      text: Binding<String>, isLocked: Bool, numberOfCharacters: Int, appStyles: StylesLogEntry
    ) -> some View {
      self.modifier(
        SectionTextFieldMultilineModifier(
          text: text, isLocked: isLocked,
          numberOfCharacters: numberOfCharacters))
    }
}


struct SectionTextFieldModifier: ViewModifier {
  @Binding var text: String
  let isLocked: Bool
  let numberOfCharacters: Int
  let textFieldHeight: CGFloat
  @Environment(\.appStyles) var appStyles

  func body(content: Content) -> some View {
    content
      .textFieldButtonClearButton(text: $text, isLocked: isLocked)
      .font(.title)
      .fontWeight(.semibold)
      .fontWidth(.standard)
      .fontDesign(.rounded)
      .frame(height: textFieldHeight)
      .lineLimit(1)
      .foregroundStyle(appStyles.standardFontColor)
      .background(
        isLocked
          ? appStyles.textFieldBackgroundColorLocked : appStyles.textFieldBackgroundColorUnLocked
      )
      .fixedSize(horizontal: false, vertical: true)
      .textFieldLimitInputLength(text: $text, length: numberOfCharacters)
      .animation(.easeInOut(duration: 1), value: isLocked)
      .autocorrectionDisabled(true)
      .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      .disabled(isLocked)
  }
}

struct SectionTextFieldMultilineModifier: ViewModifier {
  @Binding var text: String
  let isLocked: Bool
  let numberOfCharacters: Int
  @Environment(\.appStyles) var appStyles

  func body(content: Content) -> some View {
    content
      .textFieldButtonClearButton(text: $text, isLocked: isLocked)
      .font(.title)
      .fontWeight(.semibold)
      .fontWidth(.standard)
      .fontDesign(.rounded)
      .lineLimit(4, reservesSpace: true)
      .foregroundStyle(appStyles.standardFontColor)
      .background(
        isLocked
          ? appStyles.textFieldBackgroundColorLocked : appStyles.textFieldBackgroundColorUnLocked
      )
      .fixedSize(horizontal: false, vertical: false)
      .textFieldLimitInputLength(text: $text, length: numberOfCharacters)
      .animation(.easeInOut(duration: 1), value: isLocked)
      .autocorrectionDisabled(true)
      .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      .disabled(isLocked)
  }
}








struct TextFieldButtonClearButtonModifier: ViewModifier {
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
