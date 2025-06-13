//
//  WatchLogProcessTypeDetails.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import Foundation
import PencilKit
import SwiftUI

@Observable
class WatchLogProcessTypeDetails {
    
    var uuid: UUID
    
    var processTypeShort: ProcessType.ProcessTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
    
    //var AccientInjured: Bool = false
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    //var isAccient: Bool = false
    
    var isInjured: Bool = false
    
    var isAnimaleLiving: Bool = false
    
    init() {
        uuid = UUID()
        
        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
        
        //AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        isInjured = false
        
        isAnimaleLiving = false
    }
    
    init(processTypeDetails: WatchLogBookProcessTypeDetails) {
        
        uuid = processTypeDetails.uuid
        
        processTypeShort = processTypeDetails.processTypeShort
        
        //AccientInjured = false
        AccientHitAndRun = processTypeDetails.AccientHitAndRun
        AccientLicensePlate01 = processTypeDetails.AccientLicensePlate01
        AccientLicensePlate02 = processTypeDetails.AccientLicensePlate02
        
        isInjured = processTypeDetails.isInjured
        
        isAnimaleLiving = processTypeDetails.isInjured
    }
    
    func clear() {
        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN
        
        //AccientInjured = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        
        isInjured = false
        
        isAnimaleLiving = false
    }
    
    
    
    
    
}
