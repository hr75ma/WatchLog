//
//  RemoveError.swift
//  WatchLog
//
//  Created by Marcus Hörning on 23.07.25.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

public enum DBDeleteError: Error {
    case year
    case month
    case day
    case entry
}

extension DBDeleteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .year:
            return "Fehler beim Löschen des Jahreseintrages."
        case .month:
            return "Fehler beim Löschen Monatseintrages."
        case .day:
            return "Fehler beim Löschen Tageseintrages."
        case .entry:
            return "Fehler beim Löschen Wachbucheintrages."
        }
    }
}
