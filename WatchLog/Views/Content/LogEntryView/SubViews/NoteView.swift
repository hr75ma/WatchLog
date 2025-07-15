//
//  NoteView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import PencilKit
import SwiftUI

struct NoteView: View {
    @Bindable var logEntry: WatchLogEntry
    @Binding var toolPickerShows: Bool
    @State var savedDrawing: PKDrawing?

    @State var canvasview: PKCanvasView = PKCanvasView()

    @Environment(\.appStyles) var appStyles

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                SectionImageView(sectionType: .note)

                Text("Notiz")
                    .textLabel(textLabelLevel: TextLabelLevel.standard)
                Spacer()
            }
            .standardSubViewPadding()

            HStack(alignment: .top, spacing: 0) {
                CanvasView(canvas: $canvasview, drawing: $logEntry.pkDrawingData, readOnly: $logEntry.isLocked)
            }
            .canvasBorder(isLocked: logEntry.isLocked)
            .animation(.easeInOut(duration: 1), value: logEntry.isLocked)
        }
        .containerRelativeFrame([.vertical], alignment: .topLeading)
        // .disabled(logEntry.isLocked)
    }
}
