//
//  WatchLogBookYEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//

import SwiftUI
import SwiftData

@Model
class WatchLogBookEntry: Identifiable {
    #Unique<WatchLogBookEntry>([\.uuid, \.LogDate])
    
    @Attribute(.unique) var uuid: UUID
    
    var LogDate: Date

    var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
    var CallerDOB: Date

    var AccientInjured: Bool = false
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    var isAccient: Bool = false
    var isLocked: Bool = false

    var drawingData: Data
    
    
    init(LogEntry: WatchLogEntry) {
        
        uuid = LogEntry.uuid
        LogDate = LogEntry.EntryTime
        
        CallerName = LogEntry.CallerName
        CallerNumber = LogEntry.CallerNumber
        CallerAdress = LogEntry.CallerAdress
        CallerDOB = LogEntry.getDateFromDOB()
        
        isAccient = LogEntry.isAccient
        AccientInjured = LogEntry.AccientInjured
        AccientHitAndRun = LogEntry.AccientHitAndRun
        AccientLicensePlate01 = LogEntry.AccientLicensePlate01
        AccientLicensePlate02 = LogEntry.AccientLicensePlate02
        
        isLocked = true
        
        drawingData = LogEntry.drawingData
    }
    
    func update(LogEntry: WatchLogEntry) {
        
        uuid = LogEntry.uuid
        LogDate = LogEntry.EntryTime
        
        CallerName = LogEntry.CallerName
        CallerNumber = LogEntry.CallerNumber
        CallerAdress = LogEntry.CallerAdress
        CallerDOB = LogEntry.getDateFromDOB()
        
        isAccient = LogEntry.isAccient
        AccientInjured = LogEntry.AccientInjured
        AccientHitAndRun = LogEntry.AccientHitAndRun
        AccientLicensePlate01 = LogEntry.AccientLicensePlate01
        AccientLicensePlate02 = LogEntry.AccientLicensePlate02
        
        isLocked = true
        
        drawingData = LogEntry.drawingData
    }
    
    

}
