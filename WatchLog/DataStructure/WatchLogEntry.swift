//
//  LogEntry.swift
//  WatchLog
//
//  Created by Marcus Hörning on 08.05.25.
//

import Foundation
import SwiftUI
import PencilKit

open class WatchLogEntry : ObservableObject{
    
    @Published var EntryTime: Date = Date.now
    
    @Published var CallerName: String = ""
    @Published var CallerNumber: String = ""
    @Published var CallerAdress: String = ""
    @Published var CallerDOB: String = ""
    @Published var CallerInformation: String = ""
    @Published var AccientInjured: Bool = false
    @Published var AccientHitAndRun: Bool = false
    @Published var AccientLicensePlate01: String = ""
    @Published var AccientLicensePlate02: String = ""
    @Published var isAccient: Bool = false
    @Published var isLocked: Bool = false
    
    @Published  var drawingData: Data = Data()
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
