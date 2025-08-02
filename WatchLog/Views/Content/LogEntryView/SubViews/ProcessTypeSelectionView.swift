//
//  ProcessTypeView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

//
//  AccidentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct ProcessTypeSelectionView: View {
    @Bindable var logEntry: WatchLogEntry
    let viewIsReadOnly: Bool

    @Environment(\.appStyles) var appStyles

    @State private var selectedProcessHelper: ProcessingType = ProcessingType.UNKNOWN

    @State private var sortedByValue = ProcessType.processTypes
    @State private var tempLocked: Bool = false
    @Namespace private var namespace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionTitle(sectionTitleType: .event)

            VStack(alignment: .leading, spacing: 0) {
                Form {
                    processSelectionView
                        .standardInputPadding()
                }
                .formStyle(.columns)

                .task {
                    if viewIsReadOnly {
                        selectedProcessHelper = logEntry.processTypeDetails.processTypeShort

                    } else {
                        withAnimation(.smooth) {
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                            tempLocked = logEntry.isLocked
                        }
                    }
                }
                .onChange(of: logEntry.processTypeDetails.processTypeShort) { oldValue, newValue in
                    if viewIsReadOnly {
                        selectedProcessHelper = logEntry.processTypeDetails.processTypeShort

                    } else {
                        withAnimation(.smooth) {
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                            if oldValue != logEntry.processTypeDetails.processTypeShort {
                                logEntry.processTypeDetails.clear()
                                logEntry.processTypeDetails.processTypeShort = newValue
                            }
                        }
                    }
                }
                .onChange(of: logEntry.isLocked) {
                    if !viewIsReadOnly {
                        withAnimation(.smooth) {
                            tempLocked = logEntry.isLocked
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                        }
                    }
                }

                processSubViews
                    .standardInputPadding()
            }
            .standardSectionContentPadding()
        }
        .frame(maxWidth: .infinity)
        .standardBottomBorder()
    }
}

extension ProcessTypeSelectionView {
    private var processSelectionView: some View {
        HStack(alignment: .top, spacing: 0) {
            if viewIsReadOnly {
                ReadOnlyContent()
            } else {
                EditableContent()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var processSubViews: some View {
        HStack {
            switch selectedProcessHelper {
            case ProcessingType.VU:
                ProcessTypeSubVUView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.VU != selectedProcessHelper, remove: true)
            case ProcessingType.VUW:
                ProcessTypeSubVUWView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.VUW != selectedProcessHelper, remove: true)
            case ProcessingType.KV:
                ProcessTypeSubKVView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.KV != selectedProcessHelper, remove: true)
            case ProcessingType.DAUF:
                ProcessTypeSubDAUFView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.DAUF != selectedProcessHelper, remove: true)
            case ProcessingType.TRUNK:
                ProcessTypeSubTRUNKView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.TRUNK != selectedProcessHelper, remove: true)
            case ProcessingType.VKKO:
                ProcessTypeSubVKKOView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessingType.VKKO != selectedProcessHelper, remove: true)
            default:
                EmptyView()
            }
        }
    }
}

extension ProcessTypeSelectionView {
    private func ReadOnlyContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.processTypeDetails.processTypeShort.localized.stringKey!, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked,))
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                FloatingBorderLabelSimulatedTextField("", textfieldContent: logEntry.processTypeDetails.processTypeShort.localized.stringKey!, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
            }

            customProcessingTypePickerView(preselectedIndex: $logEntry.processTypeDetails.processTypeShort, appStyles: appStyles)
                .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                .containerRelativeFrame(.horizontal,
                                        count: 2,
                                        span: 1,
                                        spacing: 0, alignment: .topLeading)
                .standardLastInputViewPadding()
                .isHidden(tempLocked, remove: true)
        }
    }
}

// #Preview {
//    ProcessTypeView()
// }
