//
//  ExpandSet.swift
//  WatchLog
//
//  Created by Marcus Hörning on 03.08.25.
//

import Foundation
import SwiftUI

@Observable
public final class ExpandedRows: Identifiable {
    public var id: UUID
    
    public var rows: Set<UUID> = []
    
    init(id: UUID) {
        self.id = id
        self.rows = []
    }
    
    init() {
        self.id = UUID()
        self.rows = []
    }
}

