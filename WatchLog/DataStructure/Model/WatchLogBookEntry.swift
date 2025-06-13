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
    
    @Relationship(deleteRule: .cascade) var processDetails: WatchLogBookProcessTypeDetails?
    
    
    
    
    //var processDetails: WatchLogBookProcessTypeDetails
    
    var LogDate: Date

    var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
    var CallerDOB: Date?

    //var AccientInjured: Bool = false
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    //var isAccient: Bool = false
    
    var isInjured: Bool = false
    
    
    var isLocked: Bool = false
    var processTypeShort: ProcessType.ProcessTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

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
        
        
        
        isLocked = LogEntry.isLocked
        
        drawingData =  LogEntry.pkDrawingData.dataRepresentation()
        
        watchLogBookDay = day
        
        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.precessTypeDetails)
        
        
    }
    
    init(LogEntry: WatchLogEntry) {
        
        uuid = LogEntry.uuid
        LogDate = LogEntry.EntryTime
        
        CallerName = LogEntry.CallerName
        CallerNumber = LogEntry.CallerNumber
        CallerAdress = LogEntry.CallerAdress
        CallerDOB = LogEntry.getDateFromDOB()
        
        
        
        isLocked = LogEntry.isLocked
        
        drawingData =  LogEntry.pkDrawingData.dataRepresentation()
        
        watchLogBookDay = WatchLogBookDay()
        
        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.precessTypeDetails)
    }
    
    init() {
        
        uuid = UUID()
        LogDate = .now
        
        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = Date()
        
       // isAccient = false
       // AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        isInjured = false
        
        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
        
        isLocked = false
        
        drawingData = Data()
        
        watchLogBookDay = WatchLogBookDay()
        
        processDetails = WatchLogBookProcessTypeDetails()
    }
    
    init(uuid: UUID) {
        
        self.uuid = uuid
        LogDate = .now
        
        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = nil
        
        //isAccient = false
        //AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        isInjured = false
        
        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
        
        isLocked = false
        
        drawingData = Data()
        
        watchLogBookDay = WatchLogBookDay()
        
        processDetails = WatchLogBookProcessTypeDetails()
        
    }
    
    func update(LogEntry: WatchLogEntry) {
        
        uuid = LogEntry.uuid
        LogDate = LogEntry.EntryTime
        
        CallerName = LogEntry.CallerName
        CallerNumber = LogEntry.CallerNumber
        CallerAdress = LogEntry.CallerAdress
        CallerDOB = LogEntry.getDateFromDOB()
        
        processDetails!.AccientHitAndRun = LogEntry.precessTypeDetails.AccientHitAndRun
        processDetails!.AccientLicensePlate01 = LogEntry.precessTypeDetails.AccientLicensePlate01
        processDetails!.AccientLicensePlate02 = LogEntry.precessTypeDetails.AccientLicensePlate02
        processDetails!.isAnimaleLiving = LogEntry.precessTypeDetails.isAnimaleLiving
        processDetails!.isInjured = LogEntry.precessTypeDetails.isInjured
        processDetails!.processTypeShort = LogEntry.precessTypeDetails.processTypeShort
        
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
