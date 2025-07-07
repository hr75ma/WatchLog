//
//  SectionImageView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.07.25.
//
import SwiftUI


enum SectionImageType: Int, CaseIterable {
    case callIn
    case callerData
    case event
    case note
}


struct SectionImageView: View {
    let sectionType: SectionImageType
    @Environment(\.appStyles) var appStyles
    
    var body: some View {
        
        switch sectionType {
        case .callIn:
            Image(systemName: appStyles.sectionCallInImage)
                .sectionImageStyle(primaryColor: .watchLogSectionCallInImagePrimary, secondaryColor: .watchLogSectionCallInImageSecondary)
            //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: true)
        case .callerData:
            Image(systemName: appStyles.sectionCallerImage)
              .sectionImageStyle(
                primaryColor: .watchLogSectionCallerImagePrimary,
                secondaryColor: .watchLogSectionCallerImageSecondary)
              //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        case .event:
            Image(systemName: appStyles.sectionEventTypeImage)
              .sectionImageStyle(
                primaryColor: .watchLogSectionEventTypeImagePrimary,
                secondaryColor: .watchLogSectionEventTypeImageSecondary)
            //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        case .note:
            Image(systemName: appStyles.sectionNoteImage)
                .sectionImageStyle(primaryColor: .watchLogSectionNoteImagePrimary, secondaryColor: .watchLogSectionNoteImageSecondary)
                //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        }
    }
}
