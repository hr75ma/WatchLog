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

  var AccientInjured: Bool = false
  var AccientHitAndRun: Bool = false
  var AccientLicensePlate01: String = ""
  var AccientLicensePlate02: String = ""
  var isAccient: Bool = false
  var isLocked: Bool = false

  var drawingData: Data = Data()
    
  var pkDrawingData: PKDrawing = PKDrawing()


    
  init () {
      EntryTime = Date.now
      uuid = UUID()
      drawingData = Data()
      pkDrawingData = PKDrawing()
    }
    
    init (uudi: UUID) {
        EntryTime = Date.now
        uuid = uudi
        drawingData = Data()
        pkDrawingData = PKDrawing()
      }
    
    init(WatchLookBookEntry: WatchLogBookEntry) {
        
        uuid = WatchLookBookEntry.uuid
          
        EntryTime = WatchLookBookEntry.LogDate

        CallerName = WatchLookBookEntry.CallerName
        CallerNumber = WatchLookBookEntry.CallerNumber
        CallerAdress = WatchLookBookEntry.CallerAdress
        CallerDOB =    WatchLookBookEntry.getDOBFromDate()

        AccientInjured = WatchLookBookEntry.AccientInjured
        AccientHitAndRun = WatchLookBookEntry.AccientHitAndRun
        AccientLicensePlate01 = WatchLookBookEntry.AccientLicensePlate01
        AccientLicensePlate02 = WatchLookBookEntry.AccientLicensePlate02
        isAccient = WatchLookBookEntry.isAccient
        isLocked = WatchLookBookEntry.isLocked

        drawingData = WatchLookBookEntry.drawingData
        pkDrawingData = try! PKDrawing(data: WatchLookBookEntry.drawingData)
        
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

    isAccient = false
    AccientInjured = false
    AccientHitAndRun = false
    AccientLicensePlate01 = ""
    AccientLicensePlate02 = ""

    drawingData = Data()
    pkDrawingData = PKDrawing()
  }

  public func new() {

    initialValues()
  }
    
    
  
    
  public func getDateFromDOB() -> Date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.YYYY"
      if !self.CallerDOB.isEmpty {
          return dateFormatter.date(from: self.CallerDOB)!
      } else {
          return Date.now
      }
      
        
    }

}
