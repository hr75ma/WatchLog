//
//  CallInView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.06.25.
//

import SwiftUI

struct CallInView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool

    @Environment(\.appStyles) var appStyles

    @State private var selectedCallInHelper: InComingCallType = InComingCallType.emergency
    @State public var tempLocked: Bool
    @Namespace private var namespace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionTitle(sectionTitleType: SectionTitleType.callIn)

            VStack(alignment: .leading, spacing: 0) {

                    EditableContent()
                        .standardInputPadding()
            }
            .standardSectionContentPadding()
            .onAppear {
                if !viewIsReadOnly {
                    withAnimation(.smooth) {
                        selectedCallInHelper = logEntry.callIn
                        tempLocked = logEntry.isLocked
                    }
                }
            }
            .onChange(of: logEntry.callIn) { _, _ in
                if !viewIsReadOnly {
                    withAnimation(.smooth) {
                        selectedCallInHelper = logEntry.callIn
                    }
                }
            }
            .onChange(of: logEntry.isLocked) { _, _ in
                if !viewIsReadOnly {
                    withAnimation(.smooth) {
                        tempLocked = logEntry.isLocked
                        selectedCallInHelper = logEntry.callIn
                    }
                }
            }
        }
        .disabled(logEntry.isLocked)
        .standardBottomBorder()
    }
}

extension CallInView {
    private var callInSection: some View {
        VStack(alignment: .leading, spacing: 0) {
                EditableContent()
        }
 
    }



    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.callIn.localized.stringKey!, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .isHidden(!tempLocked, remove: true)

            } else {
                customSegmentedPickerView(preselectedIndex: $logEntry.callIn, appStyles: appStyles)
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .isHidden(tempLocked, remove: true)
            }
        }
    }
}
