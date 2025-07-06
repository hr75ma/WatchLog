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
         
          SectionImageView(sectionType: .note)
          
          Text("Notiz")
              .sectionTextLabel()
          
      }
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10))

      HStack(alignment: .top, spacing: 0) {
          //CanvasView(drawing: $drawing, toolPickerShows: $toolPickerShows)
          CanvasView(canvas: $canvasview, drawing: $drawing)

              
          
      }
      .canvasBorder(isLocked: logEntry.isLocked)
      .animation(.easeInOut(duration: 1),  value: logEntry.isLocked)
    }
    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    .containerRelativeFrame([.vertical], alignment: .topLeading)
    .disabled(logEntry.isLocked)
  }
}

