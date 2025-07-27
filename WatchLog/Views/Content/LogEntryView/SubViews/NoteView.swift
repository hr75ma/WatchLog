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
    @Binding var drawing: PKDrawing
    @Binding var toolPickerShows: Bool
    @State var savedDrawing: PKDrawing?
    let viewIsReadOnly: Bool

    @State var canvasview: PKCanvasView = PKCanvasView()

    @Environment(\.appStyles) var appStyles

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    SectionImageView(sectionType: SectionImageType.note)
                    
                    Text("Notiz")
                        .textLabel(textLabelLevel: TextLabelLevel.section)
                    Spacer()
                }

                HStack(alignment: .top, spacing: 0) {
                    CanvasView(canvas: $canvasview, drawing: $drawing, readOnly: $logEntry.isLocked)
                }
                .canvasBorder(isLocked: logEntry.isLocked)
                .disableAnimations(disableAnimation: viewIsReadOnly)
                .animation(.smooth(duration: 1), value: logEntry.isLocked)
            }
            .containerRelativeFrame([.vertical], alignment: .topLeading)
            .standardSubViewPadding()
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        // .disabled(logEntry.isLocked)
    }
}
