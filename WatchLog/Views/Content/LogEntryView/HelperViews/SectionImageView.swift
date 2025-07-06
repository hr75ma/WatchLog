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
            Image(systemName: appStyles.SectionProcessTypeImage)
              .sectionImageStyle(
                primaryColor: appStyles.SectionProcessTypeImagePrimary,
                secondaryColor: appStyles.SSectionProcessTypeImageSecondary)
            //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        case .note:
            Image(systemName: appStyles.SectionNoteImage)
                  .sectionImageStyle(primaryColor: appStyles.SectionNoteImagePrimary, secondaryColor: appStyles.SectionNoteImageSecondary)
                //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
        }
    }
}
