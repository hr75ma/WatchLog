//
//  Blursetting.swift
//  WatchLog
//
//  Created by Marcus Hörning on 29.06.25.
//

import Foundation
import SwiftUI

@Observable
final class BlurSetting {
   public var isBlur: Bool = false
    public let animationDuration: Double = 0.3
    public let blurRadius: CGFloat = 10
    
    public init() {}
}
