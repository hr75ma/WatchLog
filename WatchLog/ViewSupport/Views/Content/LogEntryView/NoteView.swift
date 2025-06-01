//
//  NoteView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI
import PencilKit


struct NoteView: View {
  @Bindable var WatchLog: WatchLogEntry
  //@Binding var DrawData: Data
  @Binding var drawing: PKDrawing
  @Binding var toolPickerShows: Bool
  @State var savedDrawing: PKDrawing?
    
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
          Image(systemName: GeneralStyles.SectionNoteImage)
              .SectionImageStyle(GeneralStyles)
      }
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10))

      HStack(alignment: .top, spacing: 0) {
          CanvasView(drawing: $drawing, toolPickerShows: $toolPickerShows)
              
          
      }
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          
            .stroke(WatchLog.isLocked ? GeneralStyles.CanvasLockedColor : GeneralStyles.CanvasUnLockedColor, lineWidth: 1)
          
      )
      .animation(.easeInOut(duration: 1),  value: WatchLog.isLocked)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
      
    }

    .overlay(
      Rectangle()
        .frame(height: 0)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}
