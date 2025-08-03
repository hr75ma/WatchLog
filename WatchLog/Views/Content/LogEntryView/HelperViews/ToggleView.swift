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
    let isDimmend: Bool
    let removeAnimation: Bool
    let toggleType: ToogleType
    @Environment(\.appStyles) var appStyles

    var body: some View {
        switch toggleType {
        case .standard:
            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .toggleStyle(
                    standardToggleStyleImage(isLocked: isLocked, isDimmend: isDimmend,  disableAnimation: removeAnimation))
                .frame(height: appStyles.standardToggleSize)

        case .sub:
            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .toggleStyle(
                    standardToggleStyleImage(isLocked: isLocked, isDimmend: isDimmend, disableAnimation: removeAnimation))
                .frame(height: appStyles.textFieldSubHeight, alignment: .center)
        }
    }
}
