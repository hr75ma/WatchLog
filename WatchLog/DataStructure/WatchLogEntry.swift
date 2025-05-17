//
//  LogEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.05.25.
//

import Foundation
import SwiftUI
import PencilKit

@Observable
class WatchLogEntry{
    
    var EntryTime: Date = Date.now
    
     var CallerName: String = ""
    var CallerNumber: String = ""
    var CallerAdress: String = ""
     var CallerDOB: String = ""
     var CallerInformation: String = ""
     var AccientInjured: Bool = false
     var AccientHitAndRun: Bool = false
     var AccientLicensePlate01: String = ""
     var AccientLicensePlate02: String = ""
     var isAccient: Bool = false
     var isLocked: Bool = false
    
      var drawingData: Data = Data()
  //      var drawing: PKDrawing {
   //         get {
   //             (try? PKDrawing(data: drawingData)) ?? PKDrawing()
  ///          }
  //
 //           set {
 //               drawingData = newValue.dataRepresentation()
 //           }
//        }
    
    fileprivate func initialValues() {
        EntryTime = Date.now
        
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
        
        //self.objectWillChange.send()
    }
    
    public func new() {
        
        EntryTime = Date.now
        
        clear()
    }
    
    
    
    
    
    
    
    
    
    
}
