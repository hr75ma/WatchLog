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
    
    var remoteSignalContainer: RemoteContainerLogEntryViewModel = RemoteContainerLogEntryViewModel()

    var isNewEntryLog = true

    var logDate: Date

    var callerName: String = ""
    var callerNumber: String = ""
    var callerAdress: String = ""
    var callerDOB: Date?

    var callIn = CallInType.CallInTypeShort.EMERGENCY

    var processTypeDetails: WatchLogProcessTypeDetails = WatchLogProcessTypeDetails()

    var isLocked: Bool = true

    // var drawingData: Data = Data()

    var pkDrawingData: PKDrawing = PKDrawing()

    init() {
        logDate = Date.now
        uuid = UUID()
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(uudi: UUID) {
        logDate = Date.now
        uuid = uudi
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(watchLookBookEntry: WatchLogBookEntry) {
        remoteSignalContainer = RemoteContainerLogEntryViewModel()
        
        uuid = watchLookBookEntry.uuid

        logDate = watchLookBookEntry.LogDate

        callerName = watchLookBookEntry.CallerName
        callerNumber = watchLookBookEntry.CallerNumber
        callerAdress = watchLookBookEntry.CallerAdress
        callerDOB = watchLookBookEntry.CallerDOB

        callIn = watchLookBookEntry.CallIn

        processTypeDetails = WatchLogProcessTypeDetails(
            processTypeDetails: watchLookBookEntry.processDetails!)

        isLocked = watchLookBookEntry.isLocked

        // drawingData = WatchLookBookEntry.drawingData
        pkDrawingData = watchLookBookEntry.drawing

        isNewEntryLog = false
    }

    fileprivate func initialValues() {
        logDate = Date.now
        uuid = UUID()
        clear()
        processTypeDetails = WatchLogProcessTypeDetails()
    }

    public func clear() {
        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .EMERGENCY

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
