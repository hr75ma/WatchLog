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
                Form {
                    callInSection
                }
                .formStyle(.columns)
            }
            .border(.red)
            .standardSectionContentPadding()
        }
        .disabled(logEntry.isLocked)
        //.standardSubViewPadding()
        .standardBottomBorder()
    }
}

extension CallInView {
    private var callInSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewIsReadOnly {
                ReadOnlyContent()
            } else {
                EditableContent()
            }
        }
        .onAppear {
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 0.5)) {
                    selectedCallInHelper = logEntry.callIn
                    // tempLocked = logEntry.isLocked
                }
            }
        }
        .onChange(of: logEntry.callIn) { _, _ in
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 0.5)) {
                    selectedCallInHelper = logEntry.callIn
                }
            }
        }
        .onChange(of: logEntry.isLocked) {
            if !viewIsReadOnly {
                withAnimation(.smooth(duration: 0.5)) {
                    tempLocked = logEntry.isLocked
                    selectedCallInHelper = logEntry.callIn
                }
            }
        }
    }

    private func ReadOnlyContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.callIn.localized.stringKey!, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
                //.standardLastInputViewPadding()
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.callIn.localized.stringKey!, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .standardLastInputViewPadding()
                    .isHidden(!tempLocked, remove: true)

            } else {
                customSegmentedPickerView(preselectedIndex: $logEntry.callIn, appStyles: appStyles)
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .standardLastInputViewPadding()
                    .isHidden(tempLocked, remove: true)
            }
        }
    }
}
