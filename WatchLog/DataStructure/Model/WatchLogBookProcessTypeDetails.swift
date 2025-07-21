//
//  ProcessTypeDetails.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class WatchLogBookProcessTypeDetails: Identifiable, Hashable {
    #Unique<WatchLogBookProcessTypeDetails>([\.uuid])

    @Attribute(.unique) var uuid: UUID

    @Relationship(deleteRule: .nullify, inverse: \WatchLogBookEntry.processDetails) var watchLogBookEntry: WatchLogBookEntry?

    var processTypeShort: ProcessType.ProcessTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

    // var AccientInjured: Bool = false
    var accientHitAndRun: Bool = false
    var accientLicensePlate01: String = ""
    var accientLicensePlate02: String = ""
    var alcoholConsumed: Bool = false

    var isInjured: Bool = false

    var isAnimaleLiving: Bool = false

    init() {
        uuid = UUID()

        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        // var AccientInjured: Bool = false
        accientHitAndRun = false
        accientLicensePlate01 = ""
        accientLicensePlate02 = ""
        alcoholConsumed = false

        isInjured = false

        isAnimaleLiving = false
    }

    init(watchLogProcessTypeDetails: WatchLogProcessTypeDetails) {
        uuid = watchLogProcessTypeDetails.uuid

        processTypeShort = watchLogProcessTypeDetails.processTypeShort

        // var AccientInjured: Bool = false
        accientHitAndRun = watchLogProcessTypeDetails.AccientHitAndRun
        accientLicensePlate01 = watchLogProcessTypeDetails.AccientLicensePlate01
        accientLicensePlate02 = watchLogProcessTypeDetails.AccientLicensePlate02
        alcoholConsumed = watchLogProcessTypeDetails.AlcoholConsumed

        isInjured = watchLogProcessTypeDetails.isInjured

        isAnimaleLiving = watchLogProcessTypeDetails.isAnimaleLiving
    }
}
