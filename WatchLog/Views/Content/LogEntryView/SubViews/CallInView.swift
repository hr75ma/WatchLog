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
    @State private var selectedCallInHelper: InComingCallType = InComingCallType.emergency
    @State private var tempLocked: Bool = false
    @Namespace private var namespace

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            SectionImageView(sectionType: SectionImageType.callIn)

            VStack(alignment: .leading, spacing: 5) {
                
                Form {
                    callInSection
                }
            .formStyle(.columns)
            }
        }
        .disabled(logEntry.isLocked)
        .standardSubViewPadding()
        .standardBottomBorder()
    }
}

extension CallInView {
    private var callInSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Eingang")
                .textLabel(textLabelLevel: TextLabelLevel.section)

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
            
            FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.callIn.localized.stringKey!, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, tint: .watchLogFont, autoResizes: true))
            
//            
//            
//            Text(logEntry.callIn.localized)
//                .sectionSimulatedTextFieldSingleLine(
//                    isLocked: logEntry.isLocked
//                )
//            Spacer()
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
//                Text(logEntry.callIn.localized)
//                    .sectionSimulatedTextFieldSingleLine(
//                        isLocked: logEntry.isLocked
//                    )
                FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.callIn.localized.stringKey!, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, tint: .watchLogFont, autoResizes: true))
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .isHidden(!tempLocked, remove: true)
            //    Spacer()
            }

            customSegmentedPickerView(preselectedIndex: $logEntry.callIn, appStyles: appStyles)
                .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                .isHidden(tempLocked, remove: true)
        }
    }
}

