//
//  UUIDContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.06.25.
//

import Foundation
import SwiftUI

final class UUIDContainer: ObservableObject {
    @Published var uuid: UUID = UUID()
}
