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

    @State private var selectedProcessHelper: ProcessType.ProcessTypeShort = ProcessType
        .ProcessTypeShort
        .UNKNOWN

    @State private var sortedByValue = ProcessType.processTypes
    @State private var tempLocked: Bool = false
    @Namespace private var namespace

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            SectionImageView(sectionType: .event)

            VStack {
                HStack(alignment: .top, spacing: 0) {
                    Text("Ereignis")
                        .textLabel(textLabelLevel: TextLabelLevel.standard)
                        .frame(alignment: .topLeading)

                    VStack(alignment: .leading, spacing: 0) {
                        processSelectionView
                    }
                    .frame(maxWidth: .infinity)
                }
                .onAppear {
                    if viewIsReadOnly {
                        selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                        tempLocked = logEntry.isLocked
                    } else {
                        withAnimation(.smooth(duration: 1)) {
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                            tempLocked = logEntry.isLocked
                        }
                    }
                }
                .onChange(of: logEntry.processTypeDetails.processTypeShort) { _, newValue in
                    if viewIsReadOnly {
                        
                        selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                        if newValue != logEntry.processTypeDetails.processTypeShort {
                            logEntry.processTypeDetails.clear()
                            logEntry.processTypeDetails.processTypeShort = newValue
                        }
                        
                    } else {
                    
                        
                        withAnimation(.smooth(duration: 1)) {
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                            if newValue != logEntry.processTypeDetails.processTypeShort {
                                logEntry.processTypeDetails.clear()
                                logEntry.processTypeDetails.processTypeShort = newValue
                            }
                        }
                    }
                }
                .onChange(of: logEntry.isLocked) {
                    
                    if !viewIsReadOnly {
                        
                        withAnimation(.smooth(duration: 1)) {
                            tempLocked = logEntry.isLocked
                            selectedProcessHelper = logEntry.processTypeDetails.processTypeShort
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                processSubViews
            }
        }
        .frame(maxWidth: .infinity)
        .standardSubViewPadding()
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
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    private var processSubViews: some View {
        HStack {
            switch selectedProcessHelper {
            case ProcessType.ProcessTypeShort.VU:
                ProcessTypeSubVUView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.VU != selectedProcessHelper, remove: true)
            case .VUW:
                ProcessTypeSubVUWView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.VUW != selectedProcessHelper, remove: true)
            case .KV:
                ProcessTypeSubKVView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.KV != selectedProcessHelper, remove: true)
            case .DAUF:
                ProcessTypeSubDAUFView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.DAUF != selectedProcessHelper, remove: true)
            case .TRUNK:
                ProcessTypeSubTRUNKView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.TRUNK != selectedProcessHelper, remove: true)
            case .VKKO:
                ProcessTypeSubVKKOView(logEntry: logEntry, viewIsReadOnly: viewIsReadOnly)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(ProcessType.ProcessTypeShort.VKKO != selectedProcessHelper, remove: true)
            default:
                EmptyView()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

extension ProcessTypeSelectionView {
    
    private func ReadOnlyContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            
                Text(ProcessType.processTypes[
                    logEntry.processTypeDetails.processTypeShort]!)
                    .sectionSimulatedTextFieldSingleLine(isLocked: logEntry.isLocked)
                Spacer()
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                Text(ProcessType.processTypes[
                    logEntry.processTypeDetails.processTypeShort]!)
                    .sectionSimulatedTextFieldSingleLine(isLocked: logEntry.isLocked)
                    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                    .isHidden(!tempLocked, remove: true)
                Spacer()
            }

            Picker("", selection: $logEntry.processTypeDetails.processTypeShort) {
                ForEach(
                    Array(
                        ProcessType.processTypes.sorted { first, second -> Bool in
                            first.value < second.value
                        }), id: \.key
                ) { key, value in
                    Text(value)
                        .pickerTextModifier()
                        .tag(key)
                }
            }
            .processPickerWheelStyle()
            .matchedGeometryEffect(id: "lockedEvent", in: namespace)
            .isHidden(tempLocked, remove: true)
            
            
            
        }
    }
}

// #Preview {
//    ProcessTypeView()
// }
