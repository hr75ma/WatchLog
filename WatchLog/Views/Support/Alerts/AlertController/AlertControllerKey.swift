//
//  AlertControllerKey.swift
//
//
//  Created by Alex Nagy on 29.04.2024.
//

import SwiftUI

public struct AlertControllerKey: @preconcurrency EnvironmentKey {
    @MainActor public static let defaultValue = AlertController()
}
