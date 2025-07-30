//
//  ExpandContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 25.07.25.
//

import Foundation
import SwiftUI

@Observable
final class ExpandContainer:  Equatable, Identifiable {
    public var id: UUID
    public var entryID: UUID?
    public var dayID: UUID?
    public var monthID: UUID?
    public var yearID: UUID?
    
    init(id: UUID) {
        self.id = id
    }
    
    init(entryID: UUID, dayID: UUID? = nil, monthID: UUID? = nil, yearID: UUID? = nil) {
        self.id = UUID()
        self.entryID = entryID
        self.dayID = dayID
        self.monthID = monthID
        self.yearID = yearID
    }
    
    init(watchLogBookEntry: WatchLogBookEntry) {
        self.id = UUID()
        self.entryID = watchLogBookEntry.id
        self.dayID = watchLogBookEntry.watchLogBookDay!.id
        self.monthID = watchLogBookEntry.watchLogBookDay!.watchLogBookMonth!.id
        self.yearID = watchLogBookEntry.watchLogBookDay!.watchLogBookMonth!.watchLogBookYear!.id
    }

    init() {
        id = UUID()
    }
    
    static func == (lhs: ExpandContainer, rhs: ExpandContainer) -> Bool {
        return lhs.entryID == rhs.entryID && lhs.dayID == rhs.dayID && lhs.monthID == rhs.monthID && lhs.yearID == rhs.yearID
    }
}
