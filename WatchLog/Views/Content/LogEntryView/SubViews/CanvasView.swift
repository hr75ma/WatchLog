//
//  CancasTestView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.06.25.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var drawing: PKDrawing
    @Binding var readOnly: Bool
    @Environment(\.appStyles) var appStyles
      @Environment(\.colorScheme) var colorScheme
    
    let picker: PKToolPicker
    
    init(canvas: Binding<PKCanvasView>, drawing: Binding<PKDrawing>, readOnly: Binding<Bool>) {
        self._canvas = canvas
        self.picker = .init()
        self._drawing = drawing
        self._readOnly = readOnly
        
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
    
        //canvas.drawingPolicy = .pencilOnly
        canvas.backgroundColor = colorScheme == .dark ? appStyles.canvasBackgroundColorDark : appStyles.canvasBackgroundColorLight
        canvas.tool = PKInkingTool(.pencil, color: .darkText, width: 15)
        
        if readOnly {
            picker.setVisible(false, forFirstResponder: canvas)
            //canvas.isUserInteractionEnabled = false
            canvas.isDrawingEnabled = false
        } else {
            //picker.setVisible(false, forFirstResponder: canvas)
            //canvas.isUserInteractionEnabled = false
            canvas.isDrawingEnabled = true
        }
        
        // Set the coordinator as the canvas's delegate
        canvas.delegate = context.coordinator
        
        canvas.contentSize = CGSize(width: appStyles.canvasSize, height: appStyles.canvasSize)
        
        // for zooming
        canvas.minimumZoomScale = appStyles.canvasMinimumZoomScale
        canvas.maximumZoomScale = appStyles.canvasMaximumZoomScale
        
        canvas.becomeFirstResponder()
        
        return canvas
}
  
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(uiView)
        picker.setVisible(true, forFirstResponder: uiView)
        
        canvas.backgroundColor = colorScheme == .dark ? appStyles.canvasBackgroundColorDark : appStyles.canvasBackgroundColorLight
        
        
        if readOnly {
            picker.setVisible(false, forFirstResponder: canvas)
            //canvas.isUserInteractionEnabled = false
            canvas.isDrawingEnabled = false
        } else {
            picker.setVisible(true, forFirstResponder: canvas)
            //canvas.isUserInteractionEnabled = false
            canvas.isDrawingEnabled = true
        }
        
        if drawing != canvas.drawing {
            canvas.drawing = drawing
        }
        
        //print("update")
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
    
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: Binding<PKDrawing>
        
        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing.wrappedValue = canvasView.drawing
        }
    }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(drawing: $drawing)
        }
}



