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

  var EntryTime: Date

  var CallerName: String = ""
  var CallerNumber: String = ""
  var CallerAdress: String = ""
  var CallerDOB: String = ""

  //var isAccient: Bool = false
  //var AccientInjured: Bool = false
  var AccientHitAndRun: Bool = false
  var AccientLicensePlate01: String = ""
  var AccientLicensePlate02: String = ""

  var isInjured: Bool = false

  var processTypeShort: ProcessType.ProcessTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
    var precessTypeDetails: WatchLogProcessTypeDetails = WatchLogProcessTypeDetails()

  var isLocked: Bool = false

  //var drawingData: Data = Data()

  var pkDrawingData: PKDrawing = PKDrawing()

  init() {
    EntryTime = Date.now
    uuid = UUID()
    //drawingData = Data()
    pkDrawingData = PKDrawing()
  }

  init(uudi: UUID) {
    EntryTime = Date.now
    uuid = uudi
    //drawingData = Data()
    pkDrawingData = PKDrawing()
  }

  init(watchLookBookEntry: WatchLogBookEntry) {

    uuid = watchLookBookEntry.uuid

    EntryTime = watchLookBookEntry.LogDate

    CallerName = watchLookBookEntry.CallerName
    CallerNumber = watchLookBookEntry.CallerNumber
    CallerAdress = watchLookBookEntry.CallerAdress
    CallerDOB = watchLookBookEntry.getDOBFromDate()

    //AccientInjured = watchLookBookEntry.AccientInjured
    AccientHitAndRun = watchLookBookEntry.AccientHitAndRun
    AccientLicensePlate01 = watchLookBookEntry.AccientLicensePlate01
    AccientLicensePlate02 = watchLookBookEntry.AccientLicensePlate02

    processTypeShort = watchLookBookEntry.processTypeShort
      precessTypeDetails = WatchLogProcessTypeDetails(processTypeDetails: watchLookBookEntry.processDetails!)

    //isAccient = watchLookBookEntry.isAccient

    isInjured = watchLookBookEntry.isInjured

    isLocked = watchLookBookEntry.isLocked

    //drawingData = WatchLookBookEntry.drawingData
    pkDrawingData = watchLookBookEntry.drawing

  }

  fileprivate func initialValues() {
    EntryTime = Date.now
    uuid = UUID()
    clear()
  }

  public func clear() {
    CallerName = ""
    CallerNumber = ""
    CallerAdress = ""
    CallerDOB = ""

    isLocked = false

    //isAccient = false
    //AccientInjured = false
    AccientHitAndRun = false
    AccientLicensePlate01 = ""
    AccientLicensePlate02 = ""

    isInjured = false

    processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
      precessTypeDetails = WatchLogProcessTypeDetails()

    //drawingData = Data()
    pkDrawingData = PKDrawing()
  }

  public func new() {

    initialValues()
  }

  public func getDateFromDOB() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY"
    if !self.CallerDOB.isEmpty {
      return dateFormatter.date(from: self.CallerDOB)!
    } else {
      return nil
    }

  }

}
