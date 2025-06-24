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
    
    let picker: PKToolPicker
    
    init(canvas: Binding<PKCanvasView>) {
        self._canvas = canvas
        self.picker = .init()
        
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
    
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .black
        canvas.tool = PKInkingTool(.pencil, color: .darkText, width: 15)
        canvas.becomeFirstResponder()
        
        return canvas
}
  
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(uiView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
}

