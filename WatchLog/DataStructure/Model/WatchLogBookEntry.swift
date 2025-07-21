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
    #Unique<WatchLogBookEntry>([\.uuid, \.logDate])

    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookDay.watchLogBookEntries) var watchLogBookDay: WatchLogBookDay?

    @Relationship(deleteRule: .cascade) var processDetails: WatchLogBookProcessTypeDetails?

    var logDate: Date
    
    var callerName: String = ""
    var callerNumber: String = ""
    var callerAdress: String = ""
    var callerDOB: Date?

    var callIn: CallInType.CallInTypeShort = CallInType.CallInTypeShort.EMERGENCY

    // var AccientInjured: Bool = false
    var accientHitAndRun: Bool = false
    var accientLicensePlate01: String = ""
    var accientLicensePlate02: String = ""
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
        logDate = LogEntry.logDate

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

        isLocked = LogEntry.isLocked

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = day

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init(LogEntry: WatchLogEntry) {
        uuid = LogEntry.uuid
        logDate = LogEntry.logDate

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

        isLocked = LogEntry.isLocked

        drawingData = LogEntry.pkDrawingData.dataRepresentation()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails(watchLogProcessTypeDetails: LogEntry.processTypeDetails)
    }

    init() {
        uuid = UUID()
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .EMERGENCY

        // isAccient = false
        // AccientInjured = false
        accientHitAndRun = false
        accientLicensePlate01 = ""
        accientLicensePlate02 = ""

        isInjured = false

        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        isLocked = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    init(uuid: UUID) {
        self.uuid = uuid
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .EMERGENCY

        // isAccient = false
        // AccientInjured = false
        accientHitAndRun = false
        accientLicensePlate01 = ""
        accientLicensePlate02 = ""

        isInjured = false

        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        isLocked = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    func clear() {
        uuid = uuid
        logDate = .now

        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .EMERGENCY

        // isAccient = false
        // AccientInjured = false
        accientHitAndRun = false
        accientLicensePlate01 = ""
        accientLicensePlate02 = ""

        isInjured = false

        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        isLocked = false

        drawingData = Data()

        watchLogBookDay = WatchLogBookDay()

        processDetails = WatchLogBookProcessTypeDetails()
    }

    func update(LogEntry: WatchLogEntry) {
        uuid = LogEntry.uuid
        logDate = LogEntry.logDate
        

        callerName = LogEntry.callerName
        callerNumber = LogEntry.callerNumber
        callerAdress = LogEntry.callerAdress
        callerDOB = LogEntry.callerDOB

        callIn = LogEntry.callIn

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
