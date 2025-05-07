import SwiftData
//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import SwiftUI
import PencilKit

#Preview{
  ContentViewTest()
}

struct ContentViewTest: View {
    @State var canvas = PKCanvasView()
    @State var drawing = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pen
    
    @State var nameText: String = ""

  var body: some View {
    VStack {
        VStack(alignment: .leading) {
            
            DateAndTimeView()
            
           CallerView(nameText: $nameText)
            
            AccidentView()
            
            
            NoteView(canvas: $canvas, drawing: $drawing, type: $type)
            
            
            
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: .infinity,
          alignment: .topLeading)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.blue, lineWidth: 4)
        )
      }
      .padding(20)
      .containerRelativeFrame([.horizontal, .vertical], alignment: .topLeading)

  }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var drawing: Bool
    @Binding var type: PKInkingTool.InkType
    let toolPicker = PKToolPicker()

    var ink : PKInkingTool {
         PKInkingTool(type, color: UIColor(Color.black))
    }
    
    var eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        toolPicker.addObserver(canvas)
        toolPicker.setVisible(true, forFirstResponder: canvas)
        
        //canvas.tool = drawing ? ink : eraser
        canvas.becomeFirstResponder()
        canvas.backgroundColor = .clear
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        //uiView.tool = drawing ? ink : eraser
    }
}




struct DateAndTimeView: View {
    var body: some View {
        HStack(alignment: .center) {
            Text("Monday")
                .font(.title)
            Spacer()
            Text("Date")
                .font(.title)
            Spacer()
            Text("Time")
                .font(.title)
            
        }
        .border(.cyan)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct CallerView: View {
    @Binding var nameText: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "phone.arrow.down.left.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .symbolRenderingMode(.monochrome)
                .symbolVariant(.fill)
                .foregroundStyle(.blue)
            
            
            
            VStack(alignment: .center) {
                HStack {
                    Text("Name")
                        .frame(width: 150, height: 30, alignment: .leading)
                        .border(.red)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        
                    
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $nameText)
                        .font(.title)


                    Spacer()
                    Text("Phone")
                        .font(.title)
                    
                    Text("123456")
                        .font(.title)
                }
                HStack {
                    Text("Adresse")
                        .font(.title)
                    
                    Text("Mustermann")
                        .font(.title)
                    Spacer()
                    Text("VU")
                        .font(.title)
                    Text("VU")
                        .font(.title)
                }
                
            }
            
            
        }
        .border(.cyan)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct AccidentView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "car.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .symbolRenderingMode(.monochrome)
                .symbolVariant(.fill)
                .foregroundStyle(.blue)
            
            
            //.frame(width: 50, height: 50)
            
            VStack(alignment: .center) {
                HStack {
                    Text("ON01")
                        .font(.title)
                }
                HStack {
                    Text("Name")
                        .font(.title)
                    
                    Text("Mustermann")
                        .font(.title)
                    Spacer()
                    Text("Kennzeichen")
                        .font(.title)
                    
                    Text("123456")
                        .font(.title)
                }
                
                HStack {
                    Text("ON02")
                        .font(.title)
                }
                
                HStack {
                    Text("Name")
                        .font(.title)
                    
                    Text("Mustermann")
                        .font(.title)
                    Spacer()
                    Text("Kennzeichen")
                        .font(.title)
                    
                    Text("123456")
                        .font(.title)
                }
                
            }
            
        }
        .border(.cyan)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct NoteView: View {
    @Binding var canvas: PKCanvasView
    @Binding var drawing: Bool
    @Binding var type: PKInkingTool.InkType
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "phone.bubble.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .symbolRenderingMode(.monochrome)
                .symbolVariant(.fill)
                .foregroundStyle(.blue)
            
            
            //.frame(width: 50, height: 50)
            
            
            CanvasView(canvas: $canvas, drawing: $drawing, type: $type)
                .border(.cyan)
        }
        .border(.cyan)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
