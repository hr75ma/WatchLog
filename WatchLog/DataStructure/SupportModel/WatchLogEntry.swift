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
    var id: UUID
    
    var remoteSignalContainer: RemoteContainerLogEntryViewModel = RemoteContainerLogEntryViewModel()

    var isNewEntryLog = true

    var logDate: Date

    var callerName: String = ""
    var callerNumber: String = ""
    var callerAdress: String = ""
    var callerDOB: Date?

    var callIn: InComingCallType = InComingCallType.emergency

    var processTypeDetails: WatchLogProcessTypeDetails = WatchLogProcessTypeDetails()

    var isLocked: Bool = false

    var pkDrawingData: PKDrawing = PKDrawing()

    init() {
        logDate = Date.now
        id = UUID()
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(uudi: UUID) {
        logDate = Date.now
        id = uudi
        // drawingData = Data()
        pkDrawingData = PKDrawing()
    }

    init(watchLookBookEntry: WatchLogBookEntry) {
        remoteSignalContainer = RemoteContainerLogEntryViewModel()
        
        id = watchLookBookEntry.id

        logDate = watchLookBookEntry.logDate

        callerName = watchLookBookEntry.callerName
        callerNumber = watchLookBookEntry.callerNumber
        callerAdress = watchLookBookEntry.callerAdress
        callerDOB = watchLookBookEntry.callerDOB

        callIn = watchLookBookEntry.callIn

        processTypeDetails = WatchLogProcessTypeDetails(
            processTypeDetails: watchLookBookEntry.processDetails!)

        isLocked = watchLookBookEntry.isLocked

        pkDrawingData = watchLookBookEntry.drawing

        isNewEntryLog = false
    }

    fileprivate func initialValues() {
        logDate = Date.now
        id = UUID()
        clear()
        processTypeDetails = WatchLogProcessTypeDetails()
    }

    public func clear() {
        callerName = ""
        callerNumber = ""
        callerAdress = ""
        callerDOB = nil

        callIn = .emergency

        isLocked = false
        isNewEntryLog = false

        pkDrawingData = PKDrawing()
    }

    public func new() {
        initialValues()
    }
}
