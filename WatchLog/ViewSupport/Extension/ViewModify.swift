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
    
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
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
