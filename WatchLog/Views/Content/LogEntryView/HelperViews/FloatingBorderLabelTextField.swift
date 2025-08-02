//
//  FloatingBorderLabelTextField.swift
//  WatchLog
//
//  Created by Marcus Hörning on 28.07.25.
//

import SwiftUI

struct FloatingBorderLabelTextField: View {
    var placeholder: String
    @Binding var textfieldContent: String
    var config: TextFieldFloatingConfiguration
    
    @Environment(\.appStyles) var appStyles
    
    init(_ placeholder: String, textfieldContent: Binding<String>, config: TextFieldFloatingConfiguration) {
        self.placeholder = placeholder
        _textfieldContent = textfieldContent
        self.config = config
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if !placeholder.isEmpty {
                Text(placeholder)
                    .font(.system(self.textfieldContent.isEmpty ? .title2 : .title3, design: .rounded))
                    .foregroundColor(self.textfieldContent.isEmpty || config.isLocked ? .watchLogFont.opacity(0.5) : .watchLogFont.opacity(1))
                    .padding(.horizontal)
                    .background(.watchLogViewBackground)
                    .offset(y: config.textfieldType == .singleLine ? self.textfieldContent.isEmpty ? 0 : -30 : self.textfieldContent.isEmpty ? 0 : -82)
                    .scaleEffect(self.textfieldContent.isEmpty ? 1 : 0.9, anchor: .topLeading)
            }
            
            FloatingTextField(text: $textfieldContent, config: config, hint: "")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.textfieldContent.isEmpty || config.isLocked ? .watchLogFont.opacity(0.5) : .watchLogFont, lineWidth: 2)
        )
        .disableAnimations(disableAnimation: config.disableAnimation)
        .animation(.smooth, value: self.textfieldContent)
    }
}

struct FloatingBorderLabelSimulatedTextField: View {
    var placeholder: String
    @State var textfieldContent: String
    var config: TextFieldFloatingConfiguration
    
    @Environment(\.appStyles) var appStyles
    
    init(_ placeholder: String, textfieldContent: String, config: TextFieldFloatingConfiguration) {
        self.placeholder = placeholder
        self.textfieldContent = textfieldContent
        self.config = config
    }
    
    var body: some View {
        FloatingBorderLabelTextField(placeholder, textfieldContent: $textfieldContent, config: config)
    }
}

