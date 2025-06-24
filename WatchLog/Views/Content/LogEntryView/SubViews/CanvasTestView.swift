//
//  CancasTestView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 24.06.25.
//

import SwiftUI
import PencilKit

struct CanvasTestView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var drawing: PKDrawing
    
    let picker: PKToolPicker
    
    init(canvas: Binding<PKCanvasView>, drawing: Binding<PKDrawing>) {
        self._canvas = canvas
        self.picker = .init()
        self._drawing = drawing
        
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
    
        //canvas.drawingPolicy = .pencilOnly
        canvas.backgroundColor = .black
        canvas.tool = PKInkingTool(.pencil, color: .darkText, width: 15)
        
        // Set the coordinator as the canvas's delegate
        canvas.delegate = context.coordinator
        
        canvas.contentSize = CGSize(width: 2000, height: 2000)
        
        // for zooming
        canvas.minimumZoomScale = 0.5
        canvas.maximumZoomScale = 10
        
        canvas.becomeFirstResponder()
        
        return canvas
}
  
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(uiView)
        picker.setVisible(true, forFirstResponder: uiView)
        
        if drawing != canvas.drawing {
            canvas.drawing = drawing
        }
        
        print("update")
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



