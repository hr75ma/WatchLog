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
    
    @Published var CallerCanvas: PKDrawing = PKDrawing()
    
    fileprivate func initialValues() {
        EntryTime = Date.now
        
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
        
        CallerCanvas = PKDrawing()
        
    }
    
   // init() {
   //
    //    initialValues()
  //  }
    
    
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
        CallerCanvas = PKDrawing()
        self.objectWillChange.send()
    }
    
    public func new() {
        
        initialValues()
        self.objectWillChange.send()
    }
    
    
    
    
    
    
    
    
    
    
}
