//
//  NonClosedEventContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.08.25.
//

import Foundation
import SwiftUI

@Observable
final class NonClosedEventContainer {
    public var id: UUID = UUID()
    
    public var nonClosedEvents: Set<UUID> = []

    public init() {}
}
