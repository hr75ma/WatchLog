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
    
    @State var currentTime: Date = Date()
    
    @ObservedObject var LogEntry: WatchLogEntry = WatchLogEntry()
    
    
    
    

  var body: some View {

    
     // Zoomable {
          
      
          
          ScrollView {
              
              VStack(alignment: .leading, spacing: 0) {
                  
                  DateAndTimeView(currentTime: $LogEntry.EntryTime)
                  
                  CallerView(WatchLog: LogEntry)
                  
                  
                  
                  
                  AccidentView(nameText: $LogEntry.CallerName)
                  
                  
                  NoteView(canvas: $canvas, drawing: $drawing, type: $type)
                      .containerRelativeFrame([.vertical], alignment: .topLeading)
                  
              }
              
              .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading)
              .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 4)
              )
              .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
              
              // .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
          }
          
          //.keyboardAdaptive()
          
          
      //}

     // .initialZoomLevel(.noZoom)
    //.secondaryZoomLevel(.noZoom)
    //.ignoresSafeArea()
      //.keyboardAdaptive()
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
    @Binding var currentTime: Date;
    
    let DisplaySize: CGFloat = 30
    
    let locale = Locale.current
    
    var body: some View {
        HStack(alignment: .center) {
            Text(currentTime.formatted(.dateTime.locale(Locale.current).weekday(.wide)))
                .font(Font.custom("digital-7", size: DisplaySize))
                .foregroundStyle(.blue)
            Spacer()
            Text(currentTime.formatted(.dateTime.day().month(.defaultDigits).year()))
                .font(Font.custom("digital-7", size: DisplaySize))
                .foregroundStyle(.blue)
            Spacer()
            Text(currentTime.formatted(.dateTime.hour().minute().second()))
                .font(Font.custom("digital-7", size: DisplaySize))
                .foregroundStyle(.blue)
            
        }
        //.border(.cyan)
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
        .overlay(
                    Rectangle()
                      .frame(height: 4) // Border thickness
                      .foregroundColor(.blue), // Border color
                      alignment: .bottom
                )
    }
}

struct CallerView: View {
    
    @ObservedObject var WatchLog: WatchLogEntry
    
    let LabelFontHeight: CGFloat = 35
    let TextFieldFontHeight: CGFloat = 32
    //let TextFont: String = "Roboto-MediumItalic"
    let LabelFont: String = "digital-7"
    let TextFieldFont: String = "Roboto-MediumItalic"
    let TextFieldHeight: CGFloat = 40
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "phone.arrow.down.left.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .symbolRenderingMode(.monochrome)
                .symbolVariant(.fill)
                .foregroundStyle(.blue)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            
            VStack(alignment: .leading, spacing: 5) {
                
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Telefon")
                        .font(Font.custom(LabelFont, size: LabelFontHeight))
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: TextFieldHeight, alignment: .leading)
                        .border(.red)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        
                        
                    
                    TextField("123456", text: $WatchLog.CallerNumber)
                        .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
                        //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
                        .textInputAutocapitalization(.characters)
                        .border(.green)
                        .lineLimit(1)
                        .foregroundStyle(.blue)
                        .fixedSize(horizontal: false, vertical: true)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad) // Show number pad
                        .onChange(of: WatchLog.CallerNumber, initial: false) { old, value in
                            WatchLog.CallerNumber = value.filter { $0.isNumber }
                            } // Allow only numeric characters
                        


                    
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Name")
                        .font(Font.custom(LabelFont, size: LabelFontHeight))
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: TextFieldHeight, alignment: .leading)
                        .border(.red)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        
                    
                    
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $WatchLog.CallerName)
                        .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
                        //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
                        //.textInputAutocapitalization(.characters)
                        .border(.green)
                        .lineLimit(1)
                        .foregroundStyle(.blue)
                        .fixedSize(horizontal: false, vertical: true)
                        .onChange(of: WatchLog.CallerName, initial: false) { print(WatchLog.CallerName)
                        }
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Geburtsdatum")
                        .font(Font.custom(LabelFont, size: LabelFontHeight))
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: TextFieldHeight, alignment: .leading)
                        .border(.red)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                        
                        
                    
                    TextField("01.01.2009", text: $WatchLog.CallerDOB)
                        .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
                        //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
                        .border(.green)
                        .lineLimit(1)
                        .foregroundStyle(.blue)
                        .fixedSize(horizontal: false, vertical: true)
                        .textContentType(.birthdate)
                        .keyboardType(.numberPad) // Show number pad
                        .onChange(of: WatchLog.CallerDOB, initial: false) { old, value in
                            if value.isNumber {
                                if value.count == 8 {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "de_DE_POSIX")
                                    dateFormatter.dateFormat = "ddMMyyyy"
                                    if dateFormatter.date(from:value) != nil {
                                        let date = dateFormatter.date(from:value)!
                                        let formatDate = DateFormatter()
                                        formatDate.dateFormat = "dd.MM.yyyy"
                                        WatchLog.CallerDOB = formatDate.string(from: date)
                                    } else {
                                        WatchLog.CallerDOB = ""
                                    }
                                } else {
                                    if value.count > 8 {
                                        WatchLog.CallerDOB = ""
                                    } else {
                                        WatchLog.CallerDOB = value
                                    }
                                }
                            } else {
                                if value.isDate {
                                    WatchLog.CallerDOB = value
                                } else {
                                    WatchLog.CallerDOB = ""
                                }
                            }
                        }
                            
                            
                            
                        


                    
                }
                
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Adresse")
                        .font(Font.custom(LabelFont, size: LabelFontHeight))
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: 30, alignment: .leading)
                        .border(.red)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                    
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
        .border(.brown)
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))

    }

}

struct AccidentView: View {
    @Binding var nameText: String
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
                    
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $nameText)
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
                .border(.green)
        }
        .border(.green)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
}
    
    extension String {
        var isDate: Bool {
            return self.range(
                of: "^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$", // 1
                options: .regularExpression) != nil
        }
}


