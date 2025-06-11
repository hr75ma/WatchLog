//
//  DisplayedLogEntryID.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

@Observable
final public class DisplayedLogEntryID: Identifiable {
    public var id: UUID = UUID()
    
    init(id: UUID) {
        self.id = id
    }
    
    init() {
        self.id = UUID()
    }
}
