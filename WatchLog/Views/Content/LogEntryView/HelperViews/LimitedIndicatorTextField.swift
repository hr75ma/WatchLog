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
    
    
    var body: some View {
        // VStack(alignment: config.progressConfig.alignment, spacing: 12) {
        ZStack(alignment: .trailing) {
            if config.textfieldType == .singleLine {
                TextField(hint, text: $text)
                    .if(config.textfieldLevel == TextFieldLevel.standard) { view in
                        view.textFieldIndicatorFloating(text: $text, config: config)
                    }
                    .if(config.textfieldLevel == TextFieldLevel.sub) { view in
                        view.textFieldIndicatorFloating(text: $text, config: config)
                    }
            } else {
                if config.textfieldType == .multiLine {
                    TextField(hint, text: $text, axis: .vertical)
                        .if(config.textfieldLevel == TextFieldLevel.standard) { view in
                            view.textFieldIndicatorFloating(text: $text, config: config)
                        }
                        .if(config.textfieldLevel == TextFieldLevel.sub) { view in
                            view.textFieldIndicatorFloating(text: $text, config: config)
                        }
                    
                }
            }
        }
    }
            
}

