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
  @Bindable var LogEntry: WatchLogEntry
  @Environment(\.appStyles) var appStyles

  @State private var selectedProcess: ProcessType.ProcessTypeShort = ProcessType.ProcessTypeShort
    .UNKNOWN
  @State private var selectedProcessHelper: ProcessType.ProcessTypeShort = ProcessType
    .ProcessTypeShort
    .UNKNOWN

  @State private var sortedByValue = ProcessType.processTypes
    
    @State private var tempLocked: Bool = false

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: appStyles.SectionProcessTypeImage)
        .SectionImageStyle(appStyles)
        .symbolRenderingMode(.palette)
        .foregroundStyle(appStyles.SectionProcessTypeImagePrimary, appStyles.SSectionProcessTypeImageSecondary)
        

//      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top, spacing: 0) {
            
            Text("Vorgangsart")
                .SectionTextLabelForToggle(appStyles)
                .frame(alignment: .topLeading)
            
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack{
                    Text(ProcessType.processTypes[LogEntry.processTypeDetails.processTypeShort]!)
                        .SectionTextFieldSecondSimulatedSingleLine(appStyles, isLocked: LogEntry.isLocked)
                        .isHidden(!tempLocked, remove: true)
                        //.animation(.easeInOut(duration: 1), value: LogEntry.isLocked)
                    
                    Picker("", selection: $selectedProcess) {
                        ForEach(
                            Array(
                                ProcessType.processTypes.sorted { (first, second) -> Bool in
                                    return first.value < second.value
                                }), id: \.key
                        ) { key, value in
                            Text(value).tag(key)
                                .font(Font.custom(appStyles.ProcessTypeFont, size: appStyles.ProcessTypeFontHight))
                                .foregroundStyle(appStyles.ProcessTypeFontColor)
                        }
                    }
                    .frame(width: 400 ,height: 150)
                    .clipped()
                    .contentShape(Rectangle())
                    .pickerStyle(.wheel)
                    .background(LogEntry.isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .isHidden(tempLocked, remove: true)
                    //.animation(.easeInOut(duration: 1), value: !LogEntry.isLocked)
                    
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                HStack {
                    switch selectedProcessHelper {
                    case ProcessType.ProcessTypeShort.VU:
                        ProcessTypeSubVUView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.VU != selectedProcessHelper, remove: true)
                    case .VUW:
                        ProcessTypeSubVUWView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.VUW != selectedProcessHelper, remove: true)
                    case .KV:
                        ProcessTypeSubKVView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.KV != selectedProcessHelper, remove: true)
                    case .DAUF:
                        ProcessTypeSubDAUFView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.DAUF != selectedProcessHelper, remove: true)
                    case .TRUNK:
                        ProcessTypeSubTRUNKView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.TRUNK != selectedProcessHelper, remove: true)
                    case .VKKO:
                        ProcessTypeSubVKKOView(LogEntry: LogEntry)
                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                          .isHidden(ProcessType.ProcessTypeShort.VKKO != selectedProcessHelper, remove: true)
                    default:
                        EmptyView()
                    }
                
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
          withAnimation(.easeInOut(duration: 1)) {
            print("animation onappear")
            selectedProcess = LogEntry.processTypeDetails.processTypeShort
            selectedProcessHelper = selectedProcess
              tempLocked = LogEntry.isLocked
          }
        }
        .onChange(of: selectedProcess) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 1)) {
            selectedProcessHelper = selectedProcess
            print("animation onchange")

            if newValue != LogEntry.processTypeDetails.processTypeShort {
              LogEntry.processTypeDetails.clear()
              LogEntry.processTypeDetails.processTypeShort = newValue
              print(LogEntry.processTypeDetails.processTypeShort)
            }
          }
        }
        .onChange(of: LogEntry.uuid) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 1)) {
            print("animation onchange uuid")
            selectedProcess = LogEntry.processTypeDetails.processTypeShort
            selectedProcessHelper = selectedProcess
          }
        }
        .onChange(of: LogEntry.isLocked) {
          withAnimation(.easeInOut(duration: 1)) {
            tempLocked = LogEntry.isLocked
          }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    //.disabled(LogEntry.isLocked)
    .frame(maxWidth: .infinity)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
    .overlay(
      Rectangle()
        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}

//#Preview {
//    ProcessTypeView()
//}
