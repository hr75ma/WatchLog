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
                .sectionImageStyle(primaryColor: appStyles.sectionCallInImagePrimary, secondaryColor: appStyles.sectionCallInImageSecondary)
            //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: true)
        case .callerData:
            Image(systemName: appStyles.sectionCallerImage)
              .sectionImageStyle(
                primaryColor: appStyles.sectionCallerImagePrimary,
                secondaryColor: appStyles.sectionCallerImageSecondary)
              //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        case .event:
            Image(systemName: appStyles.sectionEventTypeImage)
              .sectionImageStyle(
                primaryColor: appStyles.sectionEventTypeImagePrimary,
                secondaryColor: appStyles.sectionEventTypeImageSecondary)
            //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        case .note:
            Image(systemName: appStyles.sectionNoteImage)
                  .sectionImageStyle(primaryColor: appStyles.sectionNoteImagePrimary, secondaryColor: appStyles.sectionNoteImageSecondary)
                //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        }
    }
}
