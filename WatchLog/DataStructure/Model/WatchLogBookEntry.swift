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
    #Unique<WatchLogBookEntry>([\.uuid, \.LogDate])

    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookDay.watchLogBookEntries) var watchLogBookDay: WatchLogBookDay?

    @Relationship(deleteRule: .cascade) var processDetails: WatchLogBookProcessTypeDetails?

    // var processDetails: WatchLogBookProcessTypeDetails

    var LogDate: Date
    
    var saveMarker: UUID?

    var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
    var CallerDOB: Date?

    var CallIn: CallInType.CallInTypeShort = CallInType.CallInTypeShort.EMERGENCY

    // var AccientInjured: Bool = false
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    // var isAccient: Bool = false

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
    
        func getWatchLogEntry() -> WatchLogEntry {
            return WatchLogEntry(watchLookBookEntry: self)
    
        }

    init(LogEntry: WatchLogEntry, day: WatchLogBookDay) {
        uuid = LogEntry.uuid
        LogDate = LogEntry.logDate

        CallerName = LogEntry.callerName
        CallerNumber = LogEntry.callerNumber
        CallerAdress = LogEntry.callerAdress
        CallerDOB = LogEntry.callerDOB

        CallIn = LogEntry.callIn

        isLocked = LogEntry.isLocked

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = day

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init(LogEntry: WatchLogEntry) {
        uuid = LogEntry.uuid
        LogDate = LogEntry.logDate

        CallerName = LogEntry.callerName
        CallerNumber = LogEntry.callerNumber
        CallerAdress = LogEntry.callerAdress
        CallerDOB = LogEntry.callerDOB

        CallIn = LogEntry.callIn

        isLocked = LogEntry.isLocked

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init() {
        uuid = UUID()
        LogDate = .now

        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = nil

        CallIn = .EMERGENCY

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

        CallIn = .EMERGENCY

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

    func clear() {
        uuid = uuid
        LogDate = .now

        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = nil

        CallIn = .EMERGENCY

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

    func update(LogEntry: WatchLogEntry) {
        uuid = LogEntry.uuid
        LogDate = LogEntry.logDate
        

        CallerName = LogEntry.callerName
        CallerNumber = LogEntry.callerNumber
        CallerAdress = LogEntry.callerAdress
        CallerDOB = LogEntry.callerDOB

        CallIn = LogEntry.callIn

        processDetails!.AccientHitAndRun = LogEntry.processTypeDetails.AccientHitAndRun
        processDetails!.AccientLicensePlate01 = LogEntry.processTypeDetails.AccientLicensePlate01
        processDetails!.AccientLicensePlate02 = LogEntry.processTypeDetails.AccientLicensePlate02
        processDetails!.isAnimaleLiving = LogEntry.processTypeDetails.isAnimaleLiving
        processDetails!.isInjured = LogEntry.processTypeDetails.isInjured
        processDetails!.processTypeShort = LogEntry.processTypeDetails.processTypeShort
        processDetails!.AlcoholConsumed = LogEntry.processTypeDetails.AlcoholConsumed

        isLocked = true

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
