//
//  FetchError.swift
//  WatchLog
//
//  Created by Marcus Hörning on 23.07.25.
//

import Foundation
import SwiftUI
import SwiftData

public enum DBFetchError: Error {
    case book
    case year
    case month
    case day
    case entry
}

extension DBFetchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .book:
            return "Das Wachbuch konnte nicht geladen."
        case .year:
            return "Fehler beim Laden des Jahreseintrags."
        case .month:
            return "Fehler beim Laden des Monatseintrags."
        case .day:
            return "Fehler beim Laden des Tageseintrags."
        case .entry:
            return "Fehler beim Laden des Wachbucheintrags."
        }
    }
}


