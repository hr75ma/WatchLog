//
//  CallInView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.06.25.
//

import SwiftUI

struct CallInView: View {
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles

    @State private var selectedCallIn: CallInType.CallInTypeShort = CallInType.CallInTypeShort
        .EMERGENCY
    @State private var selectedCallInHelper: CallInType.CallInTypeShort = CallInType.CallInTypeShort
        .EMERGENCY
    @State private var selectedCallInAsString: String = CallInType.callInTypes[
        CallInType.CallInTypeShort.EMERGENCY]!
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
                    if tempLocked {
                        Text(selectedCallInAsString)
                            .sectionSimulatedTextFieldSingleLine(
                                isLocked: logEntry.isLocked
                            )
                            .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                            .isHidden(!tempLocked, remove: true)
                        Spacer()
                    }

                    customSegmentedPickerView(preselectedIndex: $selectedCallIn, appStyles: appStyles)
                        .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                        .isHidden(tempLocked, remove: true)
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                selectedCallIn = logEntry.CallIn
                selectedCallInHelper = selectedCallIn
                tempLocked = logEntry.isLocked
            }
        }
        .onChange(of: selectedCallIn) { _, _ in
            withAnimation(.easeInOut(duration: 1)) {
                logEntry.CallIn = selectedCallIn
                selectedCallInHelper = selectedCallIn
                selectedCallInAsString = CallInType.callInTypes[logEntry.CallIn]!
            }
        }
        .onChange(of: logEntry.uuid) {
            _, _ in
            withAnimation(.easeInOut(duration: 1)) {
                selectedCallIn = logEntry.CallIn
                selectedCallInHelper = selectedCallIn
            }
        }
        .onChange(of: logEntry.isLocked) {
            withAnimation(.easeInOut(duration: 1)) {
                tempLocked = logEntry.isLocked
                selectedCallInHelper = selectedCallIn
                selectedCallInAsString = CallInType.callInTypes[logEntry.CallIn]!
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
