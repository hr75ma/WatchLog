//
//  LogEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.05.25.
//

import Foundation
import SwiftUI

open class WatchLogEntry : ObservableObject{
    
    public var EntryTime: Date = Date.now
    
    @Published var CallerName: String = ""
    @Published var CallerNumber: String = ""
    @Published var CallerAdress: String = ""
    @Published var CallerDOB: String = ""
    @Published var CallerInformation: String = ""
    @Published var AccientInjured: Bool = false
    @Published var AccientHitAndRun: Bool = false
    @Published var AccientLicensePlate01: String = ""
    @Published var AccientLicensePlate02: String = ""
    
    
    
    
    
    
    
    
    
}
