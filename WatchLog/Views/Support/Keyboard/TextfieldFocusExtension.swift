//
//  TextfieldFocusExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 25.07.25.
//

import Foundation
import SwiftUI

struct FocusKey: EnvironmentKey, PreferenceKey {
    static func reduce(value: inout FocusedTextfield?, nextValue: () -> FocusedTextfield?) {
        value = nextValue() ?? value
    }
    
    static let defaultValue: FocusedTextfield? = nil
}
