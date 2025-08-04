//
//  WatchLogBookYEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.05.25.
//
import Foundation
import PencilKit
import SwiftData
import SwiftUI

@Model
class WatchLogBookEntry: Identifiable, Hashable {
    #Unique<WatchLogBookEntry>([\.id])

    @Attribute(.unique) var id: UUID

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookDay.watchLogBookEntries) var watchLogBookDay: WatchLogBookDay?

    @Relationship(deleteRule: .cascade) var processDetails: WatchLogBookProcessTypeDetails?

    var logDate: Date
    
    var callerName: String = ""
    var callerNumber: String = ""
    var callerAdress: String = ""
    var callerDOB: Date?

    
    var callIn: InComingCallType = InComingCallType.emergency

    var isLocked: Bool = false
    var isClosed: Bool = false
    
    private var drawingData: Data = Data()
    var drawing: PKDrawing {
        get {
            (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }

        set {
            drawingData = newValue.dataRepresentation()
        }
    }
    
        func getWatchLogEntry() -> WatchLogEntry {
            return WatchLogEntry(watchLookBookEntry: self)
    
        }

    init(LogEntry: WatchLogEntry, day: WatchLogBookDay) {
        id = LogEntry.id
        logDate = LogEntry.logDate

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

        isLocked = LogEntry.isLocked
        isClosed = LogEntry.isClosed

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = day

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init(LogEntry: WatchLogEntry) {
        id = LogEntry.id
        logDate = LogEntry.logDate

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

        isLocked = LogEntry.isLocked
        isClosed = LogEntry.isClosed

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init() {
        id = UUID()
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .emergency

        isLocked = false
        isClosed = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    init(uuid: UUID) {
        self.id = uuid
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .emergency

        isLocked = false
        isClosed = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    func clear() {
        id = id
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .emergency

        //processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        isLocked = false
        isClosed = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    func update(LogEntry: WatchLogEntry) {
        id = LogEntry.id
        logDate = LogEntry.logDate
        

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

        processDetails!.accientHitAndRun = LogEntry.processTypeDetails.AccientHitAndRun
        processDetails!.accientLicensePlate01 = LogEntry.processTypeDetails.AccientLicensePlate01
        processDetails!.accientLicensePlate02 = LogEntry.processTypeDetails.AccientLicensePlate02
        processDetails!.isAnimaleLiving = LogEntry.processTypeDetails.isAnimaleLiving
        processDetails!.isInjured = LogEntry.processTypeDetails.isInjured
        processDetails!.processTypeShort = LogEntry.processTypeDetails.processTypeShort
        processDetails!.alcoholConsumed = LogEntry.processTypeDetails.AlcoholConsumed

        isLocked = true
        isClosed = LogEntry.isClosed

        drawingData = LogEntry.pkDrawingData.dataRepresentation()
    }

//    func getDOBFromDate() -> String {
//        if(self.CallerDOB != nil) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "de_DE_POSIX")
//            dateFormatter.dateFormat = "dd.MM.YYYY"
//            return dateFormatter.string(from: self.CallerDOB!)
//        }
//        return ""
//      }
}
