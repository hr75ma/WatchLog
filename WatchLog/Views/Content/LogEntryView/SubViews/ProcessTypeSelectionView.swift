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

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: appStyles.SectionProcessTypeImage)
        .SectionImageStyle(appStyles)

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top, spacing: 0) {

          Text("Vorgangsart")
            .SectionTextLabelForToggle(appStyles)
            .frame(alignment: .topLeading)

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
          .frame(width: .infinity ,height: 150)
          .clipped()
          .pickerStyle(.wheel)
          .background(LogEntry.isLocked ? appStyles.TextfieldBackgroundColorLocked : appStyles.TextfieldBackgroundColorUnLocked)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          .animation(.easeInOut(duration: 1),  value: LogEntry.isLocked)
        }
        .onAppear {
          withAnimation {
            print("animation onappear")
            selectedProcess = LogEntry.processTypeDetails.processTypeShort
            selectedProcessHelper = selectedProcess
          }
        }
        .onChange(of: selectedProcess) { oldValue, newValue in
          withAnimation {
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
          withAnimation {
            print("animation onchange uuid")
            selectedProcess = LogEntry.processTypeDetails.processTypeShort
            selectedProcessHelper = selectedProcess
          }
        }
        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))

        VStack {
          ProcessTypeSubVUView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.VU != selectedProcessHelper, remove: true)
          ProcessTypeSubKVView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.KV != selectedProcessHelper, remove: true)
          ProcessTypeSubVUWView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.VUW != selectedProcessHelper, remove: true)
          ProcessTypeSubTRUNKView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.TRUNK != selectedProcessHelper, remove: true)
          ProcessTypeSubVKKOView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.VKKO != selectedProcessHelper, remove: true)
          ProcessTypeSubDAUFView(LogEntry: LogEntry)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .isHidden(ProcessType.ProcessTypeShort.DAUF != selectedProcessHelper, remove: true)
            

        }
        //.transition(.scale.animation(.easeInOut(duration: 3)))
        //.transition(AnyTransition.scale.animation(.easeInOut(duration: 1)))
        .animation(.easeInOut(duration: 0.5), value: selectedProcessHelper)

      }

    }
    .disabled(LogEntry.isLocked)
    //.border(.brown)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
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
