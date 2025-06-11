//
//  WatchLogBookYEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import SwiftUI
import SwiftData
import PencilKit

@Model
class WatchLogBookEntry: Identifiable, Hashable {
    #Unique<WatchLogBookEntry>([\.uuid, \.LogDate])
    
    @Attribute(.unique) var uuid: UUID
    
    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookDay.watchLogBookEntries) var watchLogBookDay: WatchLogBookDay?
    
    var LogDate: Date

    var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
    var CallerDOB: Date?

    var AccientInjured: Bool = false
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    var isAccient: Bool = false
    var isLocked: Bool = false
    var processTypeShort: ProcessTypeShort = ProcessTypeShort.UNKNOWN

    private var drawingData: Data = Data()
    var drawing: PKDrawing {
            get {
                (try? PKDrawing(data: drawingData)) ?? PKDrawing()
            }
            
            set {
                drawingData = newValue.dataRepresentation()
            }
        }
    
   
    init(LogEntry: WatchLogEntry, day: WatchLogBookDay) {
        
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
        
        processTypeShort = LogEntry.processTypeShort
        
        isLocked = LogEntry.isLocked
        
        drawingData =  LogEntry.pkDrawingData.dataRepresentation()
        
        watchLogBookDay = day
    }
    
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
        
        processTypeShort = LogEntry.processTypeShort
        
        isLocked = LogEntry.isLocked
        
        drawingData =  LogEntry.pkDrawingData.dataRepresentation()
        
        watchLogBookDay = WatchLogBookDay()
    }
    
    init() {
        
        uuid = UUID()
        LogDate = .now
        
        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = Date()
        
        isAccient = false
        AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        processTypeShort = ProcessTypeShort.UNKNOWN
        
        isLocked = false
        
        drawingData = Data()
        
        watchLogBookDay = WatchLogBookDay()
    }
    
    init(uuid: UUID) {
        
        self.uuid = uuid
        LogDate = .now
        
        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = nil
        
        isAccient = false
        AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        processTypeShort = ProcessTypeShort.UNKNOWN
        
        isLocked = false
        
        drawingData = Data()
        
        watchLogBookDay = WatchLogBookDay()
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
        
        processTypeShort = LogEntry.processTypeShort
        
        isLocked = true
        
        drawingData = LogEntry.pkDrawingData.dataRepresentation()
    }
    
    func getDOBFromDate() -> String {
        if(self.CallerDOB != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "de_DE_POSIX")
            dateFormatter.dateFormat = "dd.MM.YYYY"
            return dateFormatter.string(from: self.CallerDOB!)
        }
        return ""
      }
    
    

}
