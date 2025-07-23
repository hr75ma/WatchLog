//
//  DBSaveError.swift
//  WatchLog
//
//  Created by Marcus Hörning on 23.07.25.
//

import Foundation
import SwiftUI
import SwiftData

public enum DBSavingError: Error {
    case entry
}

extension DBSavingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .entry:
            return "Der Wachucheintrag konnte nicht gespeichert werden."
        }
    }
}
