//
//  SectionImageView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.07.25.
//
import SwiftUI

enum SectionTitleType: Int, CaseIterable {
    case callIn
    case callerData
    case event
    case note
}

struct SectionTitle: View {
    let sectionTitleType: SectionTitleType
    @Environment(\.appStyles) var appStyles

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            switch sectionTitleType {
            case .callIn:
                Image(systemName: appStyles.sectionCallInImage)
                    .sectionImageStyle(primaryColor: .watchLogSectionCallInImagePrimary, secondaryColor: .watchLogSectionCallInImageSecondary)
                Text("Eingang")
                    .textLabel(textLabelLevel: TextLabelLevel.section)

            case .callerData:

                Image(systemName: appStyles.sectionCallerImage)
                    .sectionImageStyle(
                        primaryColor: .watchLogSectionCallerImagePrimary,
                        secondaryColor: .watchLogSectionCallerImageSecondary)
                Text("Daten des Mitteilers")
                    .textLabel(textLabelLevel: TextLabelLevel.section)

            case .event:
                Image(systemName: appStyles.sectionEventTypeImage)
                    .sectionImageStyle(
                        primaryColor: .watchLogSectionEventTypeImagePrimary,
                        secondaryColor: .watchLogSectionEventTypeImageSecondary)
                Text("Ereignis")
                    .textLabel(textLabelLevel: TextLabelLevel.section)

            case .note:
                Image(systemName: appStyles.sectionNoteImage)
                    .sectionImageStyle(primaryColor: .watchLogSectionNoteImagePrimary, secondaryColor: .watchLogSectionNoteImageSecondary)
                Text("Mitteilung")
                    .textLabel(textLabelLevel: TextLabelLevel.section)
            }
        }
        .standardSectionPadding()
    }
}
