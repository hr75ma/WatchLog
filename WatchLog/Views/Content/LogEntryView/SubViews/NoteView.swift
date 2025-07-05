//
//  NoteView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI
import PencilKit


struct NoteView: View {
  @Bindable var logEntry: WatchLogEntry
  //@Binding var DrawData: Data
  @Binding var drawing: PKDrawing
  @Binding var toolPickerShows: Bool
  @State var savedDrawing: PKDrawing?
  
    @State var canvasview: PKCanvasView = PKCanvasView()
    
    
    @Environment(\.appStyles) var appStyles

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
         
          SectionImage
          
          Text("Notiz")
              .sectionTextLabel()
          
      }
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10))

      HStack(alignment: .top, spacing: 0) {
          //CanvasView(drawing: $drawing, toolPickerShows: $toolPickerShows)
          CanvasView(canvas: $canvasview, drawing: $drawing)

              
          
      }
      .cornerRadius(20)
      .overlay(
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          
            .stroke(logEntry.isLocked ? appStyles.CanvasLockedColor : appStyles.CanvasUnLockedColor, lineWidth: 1)
          
      )
      .animation(.easeInOut(duration: 1),  value: logEntry.isLocked)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
      
    }
    .cornerRadius(20)
    .overlay(
      Rectangle()
        .frame(height: 0)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    .containerRelativeFrame([.vertical], alignment: .topLeading)
    .disabled(logEntry.isLocked)
  }
}

extension NoteView {
    
    private var SectionImage: some View {
      Image(systemName: appStyles.SectionNoteImage)
            .sectionImageStyle(primaryColor: appStyles.SectionNoteImagePrimary, secondaryColor: appStyles.SectionNoteImageSecondary)
          //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
    }
}
