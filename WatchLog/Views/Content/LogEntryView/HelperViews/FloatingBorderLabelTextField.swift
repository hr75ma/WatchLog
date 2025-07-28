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
    var isLocked: Bool
    var disableAnimation: Bool
    var config: Config
    
    @Environment(\.appStyles) var appStyles
    
    init(_ placeholder: String, textfieldContent: Binding<String>, isLocked: Bool, disableAnimation: Bool, config: Config) {
        self.placeholder = placeholder
        _textfieldContent = textfieldContent
        self.isLocked = isLocked
        self.disableAnimation = disableAnimation
        self.config = config
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if !placeholder.isEmpty {
                Text(placeholder)
                    .font(.system(self.textfieldContent.isEmpty ? .title2 : .title3, design: .rounded))
                    .foregroundColor(.watchLogFont.opacity(0.5))
                    .padding(.horizontal)
                    .background(Color.black)
                    .if(config.textfieldType == .singleLine) { content in
                        content
                            .offset(y: self.textfieldContent.isEmpty ? 0 : -30)
                    }
                    .if(config.textfieldType == .multiLine) { content in
                        content
                            .offset(y: self.textfieldContent.isEmpty ? 0 : -82)
                    }
                    .scaleEffect(self.textfieldContent.isEmpty ? 1 : 0.9, anchor: .topLeading)
            }
            
            LimitedIndicatorTextFieldFloating(config: config, hint: "", text: $textfieldContent, isLocked: isLocked, disableAnimation: disableAnimation)
        }
        .animation(.smooth, value: self.textfieldContent)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(self.textfieldContent.isEmpty ? .watchLogFont.opacity(0.5) : .watchLogFont, lineWidth: 2)
        )
    }
}

struct FloatingBorderLabelSimulatedTextField: View {
    var placeholder: String
    @State var textfieldContent: String
    var isLocked: Bool
    var disableAnimation: Bool
    var config: Config
    
    @Environment(\.appStyles) var appStyles
    
    init(_ placeholder: String, textfieldContent: String, isLocked: Bool, disableAnimation: Bool, config: Config) {
        self.placeholder = placeholder
        self.textfieldContent = textfieldContent
        self.isLocked = isLocked
        self.disableAnimation = disableAnimation
        self.config = config
    }
    
    
    var body: some View {
        FloatingBorderLabelTextField(placeholder, textfieldContent: $textfieldContent, isLocked: isLocked, disableAnimation: disableAnimation, config: config)
    }
}

