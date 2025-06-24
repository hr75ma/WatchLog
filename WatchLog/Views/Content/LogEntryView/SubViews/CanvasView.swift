//
//  File.swift
//  WatchLog
//
//  Created by Marcus Hörning on 16.05.25.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var toolPickerShows: Bool

    
    private let canvasView = PKCanvasView()
    private let toolPicker = PKToolPicker()
    
 
    
    func makeUIView(context: Context) -> PKCanvasView {
        // Allow finger drawing
        canvasView.drawingPolicy = .pencilOnly
        
        // Set the coordinator as the canvas's delegate
        canvasView.delegate = context.coordinator
        
        canvasView.contentSize = CGSize(width: 2000, height: 2000)
        
        // for zooming
                canvasView.minimumZoomScale = 1
                canvasView.maximumZoomScale = 10

        
        // Make the tool picker visible or invisible depending on toolPickerShows
        toolPicker.setVisible(toolPickerShows, forFirstResponder: canvasView)
        
        
        // Make the canvas respond to tool changes
        toolPicker.addObserver(canvasView)
        
        // Make the canvas active -- first responder
        if toolPickerShows {
            canvasView.becomeFirstResponder()
        }
        
        
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        // Called when SwiftUI updates the view, (makeUIView(context:) called when creating the view.)
        // For example, called when toolPickerShows is toggled:
        // so hide or show tool picker
        
        // Also called when users of CanvasView change the drawing propety
        // so update the canvas view's drawing if necessary
        if drawing != canvasView.drawing {
            canvasView.drawing = drawing
        }

        
        toolPicker.setVisible(toolPickerShows, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
       
        
        if toolPickerShows {
            //DispatchQueue.main.async {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
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

extension CanvasView {
    

}

extension PKDrawing {
    mutating func scale(in frame: CGRect) {
        var scaleFactor:CGFloat = 0
        
        if self.bounds.width != frame.width {
            scaleFactor = frame.width / self.bounds.width
        } else if self.bounds.height != frame.height {
            scaleFactor = frame.height / self.bounds.height
        }
        
        let trasform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        self.transform(using: trasform)
    }
}
