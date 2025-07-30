//
//  RemoteContainerLogEntryView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 15.07.25.
//

import SwiftUI

enum RemoteSignal: CaseIterable, Codable {
    case save
    case delete
    case undefined
}

@Observable
class RemoteContainerLogEntryViewModel: Identifiable {
    public var id: UUID
    public var signale: RemoteSignal
    
    init() {
        id = UUID()
        signale = .undefined
    }
}
