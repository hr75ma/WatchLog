//
//  ToggleView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.07.25.
//

import SwiftUI

enum ToogleType: Int, CaseIterable {
    case standard
    case sub
}

struct ToggleView: View {
    @Binding var toggleValue: Bool
    let isLocked: Bool
    let toggleType: ToogleType
    @Environment(\.appStyles) var appStyles

    var body: some View {
        switch toggleType {
        case .standard:
            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .toggleStyle(
                    standardToggleStyleImage(isLocked: isLocked)
                )
                .frame(height: appStyles.labelFontSize)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        case .sub:
            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .toggleStyle(
                    standardToggleStyleImage(isLocked: isLocked)
                )
                .frame(height: appStyles.textFieldSubHeight, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}
