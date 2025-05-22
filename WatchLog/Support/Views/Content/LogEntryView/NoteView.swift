//
//  NoteView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI
import PencilKit


struct NoteView: View {
  @Binding var DrawData: Data
  @Binding var drawing: PKDrawing
  @Binding var toolPickerShows: Bool
  @State var savedDrawing: PKDrawing?

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
        Image(systemName: "phone.bubble.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 40, height: 40)
          .symbolRenderingMode(.monochrome)
          .symbolVariant(.fill)
          .foregroundStyle(.blue)
          .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

        Button {
          withAnimation(.bouncy()) {
            drawing = PKDrawing()
            DrawData = drawing.dataRepresentation()
          }

        } label: {
          Image(systemName: "clear.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .symbolRenderingMode(.monochrome)
            .symbolVariant(.fill)
            .foregroundStyle(.blue)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }

        Button("save") {
          DrawData = drawing.dataRepresentation()
        }

        Button("load") {
          drawing = (try? PKDrawing(data: DrawData)) ?? PKDrawing()
        }

        Spacer()

      }
      //.border(.green)
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10))

      HStack(alignment: .top, spacing: 0) {
        CanvasView(drawing: $drawing, toolPickerShows: $toolPickerShows)
        //.border(.green)
      }
      //.border(.red)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10))
    }

    .overlay(
      Rectangle()
        .frame(height: 0)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
  }
}
