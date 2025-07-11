//
//  DisplayedLogEntryID.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.06.25.
//

import Foundation
import SwiftUI

@Observable
public final class DisplayedLogEntryID: Identifiable {
    public var id: UUID = UUID()
    public var dayId: UUID = UUID()
    public var monthId: UUID = UUID()
    public var yearId: UUID = UUID()
    public var bookId: UUID = UUID()

    init(id: UUID) {
        self.id = id
    }

    init() {
        id = UUID()
    }
}
