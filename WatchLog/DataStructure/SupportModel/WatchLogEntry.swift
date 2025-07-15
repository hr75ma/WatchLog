//
//  LogEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.05.25.
//

import Foundation
import PencilKit
import SwiftUI

@Observable
class WatchLogEntry {
    var uuid: UUID

    var isNewEntryLog = true

    var EntryTime: Date

    var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
    var CallerDOB: Date?


    var CallIn = CallInType.CallInTypeShort.EMERGENCY

    var processTypeDetails: WatchLogProcessTypeDetails = WatchLogProcessTypeDetails()

    var isLocked: Bool = false

    // var drawingData: Data = Data()

    var pkDrawingData: PKDrawing = PKDrawing()

    init() {
        EntryTime = Date.now
        uuid = UUID()
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(uudi: UUID) {
        EntryTime = Date.now
        uuid = uudi
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(watchLookBookEntry: WatchLogBookEntry) {
        uuid = watchLookBookEntry.uuid

        EntryTime = watchLookBookEntry.LogDate

        CallerName = watchLookBookEntry.CallerName
        CallerNumber = watchLookBookEntry.CallerNumber
        CallerAdress = watchLookBookEntry.CallerAdress
        CallerDOB = watchLookBookEntry.CallerDOB

        CallIn = watchLookBookEntry.CallIn

        processTypeDetails = WatchLogProcessTypeDetails(
            processTypeDetails: watchLookBookEntry.processDetails!)

        isLocked = watchLookBookEntry.isLocked

        // drawingData = WatchLookBookEntry.drawingData
        pkDrawingData = watchLookBookEntry.drawing

        isNewEntryLog = false
    }

    fileprivate func initialValues() {
        EntryTime = Date.now
        uuid = UUID()
        clear()
        processTypeDetails = WatchLogProcessTypeDetails()
    }

    public func clear() {
        CallerName = ""
        CallerNumber = ""
        CallerAdress = ""
        CallerDOB = nil

        CallIn = .EMERGENCY

        isLocked = false
        isNewEntryLog = false

        // processTypeDetails = WatchLogProcessTypeDetails()

        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    public func new() {
        initialValues()
    }
}
