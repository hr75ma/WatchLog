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

    //@State private var selectedCallIn: CallInType.CallInTypeShort = CallInType.CallInTypeShort.EMERGENCY
    @State private var selectedCallInHelper: CallInType.CallInTypeShort = CallInType.CallInTypeShort
        .EMERGENCY
    @State private var tempLocked: Bool = false
    @Namespace private var namespace

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            SectionImageView(sectionType: SectionImageType.callIn)

            VStack(alignment: .leading, spacing: 5) {
                callInSection
            }
        }
        .disabled(logEntry.isLocked)
        .standardSubViewPadding()
        .standardBottomBorder()
    }
}

extension CallInView {
    private var callInSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Eingang")
                .textLabel(textLabelLevel: TextLabelLevel.standard)

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if viewIsReadOnly {
                        ReadOnlyContent()
                    } else {
                        EditableContent()
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 1)) {
                    selectedCallInHelper = logEntry.callIn
                    tempLocked = logEntry.isLocked
                }
            }
        }
        .onChange(of: logEntry.callIn) { _, _ in
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 1)) {
                    selectedCallInHelper = logEntry.callIn
                }
            }
        }
        .onChange(of: logEntry.isLocked) {
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 1)) {
                    tempLocked = logEntry.isLocked
                    selectedCallInHelper = logEntry.callIn
                }
            }
        }
    }

    private func ReadOnlyContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(CallInType.callInTypes[logEntry.callIn]!)
                .sectionSimulatedTextFieldSingleLine(
                    isLocked: logEntry.isLocked
                )
            Spacer()
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                Text(CallInType.callInTypes[logEntry.callIn]!)
                    .sectionSimulatedTextFieldSingleLine(
                        isLocked: logEntry.isLocked
                    )
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .isHidden(!tempLocked, remove: true)
                Spacer()
            }

            customSegmentedPickerView(preselectedIndex: $logEntry.callIn, appStyles: appStyles)
                .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                .isHidden(tempLocked, remove: true)
        }
    }
}
