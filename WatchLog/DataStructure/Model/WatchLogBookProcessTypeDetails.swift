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
    var AccientHitAndRun: Bool = false
    var AccientLicensePlate01: String = ""
    var AccientLicensePlate02: String = ""
    var AlcoholConsumed: Bool = false

    var isInjured: Bool = false

    var isAnimaleLiving: Bool = false

    init() {
        uuid = UUID()

        processTypeShort = ProcessType.ProcessTypeShort.UNKNOWN

        // var AccientInjured: Bool = false
        AccientHitAndRun = false
        AccientLicensePlate01 = ""
        AccientLicensePlate02 = ""
        AlcoholConsumed = false

        isInjured = false

        isAnimaleLiving = false
    }

    init(watchLogProcessTypeDetails: WatchLogProcessTypeDetails) {
        uuid = watchLogProcessTypeDetails.uuid

        processTypeShort = watchLogProcessTypeDetails.processTypeShort

        // var AccientInjured: Bool = false
        AccientHitAndRun = watchLogProcessTypeDetails.AccientHitAndRun
        AccientLicensePlate01 = watchLogProcessTypeDetails.AccientLicensePlate01
        AccientLicensePlate02 = watchLogProcessTypeDetails.AccientLicensePlate02
        AlcoholConsumed = watchLogProcessTypeDetails.AlcoholConsumed

        isInjured = watchLogProcessTypeDetails.isInjured

        isAnimaleLiving = watchLogProcessTypeDetails.isAnimaleLiving
    }
}
