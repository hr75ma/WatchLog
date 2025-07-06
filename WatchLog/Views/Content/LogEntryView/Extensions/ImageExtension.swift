//
//  ImageExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 01.06.25.
//
import SwiftUI

enum SectionImageType: Int, CaseIterable {
    case callIn
    case callerData
    case event
    case note
}


struct ViewSectionImage: View {
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










extension Image {

  func ToolbarImageStyle() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .symbolRenderingMode(.monochrome)
      .symbolVariant(.fill)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }

  func sectionImageStyle(primaryColor: Color, secondaryColor: Color) -> some View {
    self.resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 40, height: 40)
      .symbolVariant(.circle)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
      .foregroundStyle(primaryColor, secondaryColor)
  }

}
