import PencilKit
import SwiftData
//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//
import SwiftUI

#Preview{
  ContentView()
}

let TextfieldBackgroundColor: Color = Color(hex: 0x3b3b3b).opacity(1)
let LabelFontHeight: CGFloat = 35
let TextFieldFontHeight: CGFloat = 32
//let TextFont: String = "Roboto-MediumItalic"
let LabelFont: String = "digital-7"
let TextFieldFont: String = "Roboto-MediumItalic"
let TextFieldHeight: CGFloat = 40

struct ContentViewTest: View {
  //@State var canvas = PKCanvasView()
  @State var toolPickerShows = true
  @State var drawing = PKDrawing()

  @State var nameText: String = ""

  @State var currentTime: Date = Date()

  @ObservedObject var LogEntry: WatchLogEntry = WatchLogEntry()

    var body: some View {
        
        // Zoomable {
        
        
        NavigationStack
        {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    DateAndTimeView(currentTime: $LogEntry.EntryTime)
                    
                    LockEditingView(WatchLog: LogEntry)
                    
                    CallerView(WatchLog: LogEntry)
                    
                    AccidentView(WatchLog: LogEntry)
                    
                    NoteView(
                        DrawData: $LogEntry.drawingData, drawing: $drawing, toolPickerShows: $toolPickerShows
                    )
                    .containerRelativeFrame([.vertical], alignment: .topLeading)
                    .disabled(LogEntry.isLocked)
                    
                }
                
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 4)
                )
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Eintrag")
                    .font(Font.custom(LabelFont, size: LabelFontHeight))
                    .foregroundStyle(.blue)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
                
                ToolbarItemGroup(placement: .automatic) {
                    Button(action:  {
                        clearEntry(LogEntry: LogEntry, drawing: &drawing)
                    }) {
                        label: do {
                            Image(systemName: "eraser.fill" )
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .symbolRenderingMode(.monochrome)
                                .symbolVariant(.fill)
                                .foregroundStyle(LogEntry.isLocked ? .gray : .blue)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .disabled(LogEntry.isLocked)
                    Button(action:  {
                    }) {
                        label: do {
                            Image(systemName: "square.and.arrow.down.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .symbolRenderingMode(.monochrome)
                                .symbolVariant(.fill)
                                .foregroundStyle(.blue)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    Button(action:  {
                        newEntry(LogEntry: LogEntry, drawing: &drawing)
                    }) {
                        label: do {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .symbolRenderingMode(.monochrome)
                                .symbolVariant(.fill)
                                .foregroundStyle(LogEntry.isLocked ? .gray : .blue)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .disabled(LogEntry.isLocked)
                    
            }
        }

        
    }

}

struct LockEditingView: View {
  @ObservedObject var WatchLog: WatchLogEntry

  let DisplaySize: CGFloat = 35

  let locale = Locale.current

  var body: some View {
    HStack(alignment: .center) {

      Text("Gesperrt")
        .font(Font.custom(LabelFont, size: LabelFontHeight))
        .foregroundStyle(.blue)
        .frame(height: TextFieldHeight, alignment: .topLeading)
        .multilineTextAlignment(.leading)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: true)
        //.border(.red)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

      Toggle("", isOn: $WatchLog.isLocked)
        .labelsHidden()
        .toggleStyle(MyStyleLock())
      //.border(.red)

      Spacer()

    }
    //.border(.cyan)
    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
    .overlay(
      Rectangle()
        .frame(height: 4)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )
  }
}

struct DateAndTimeView: View {
  @Binding var currentTime: Date

  let DisplaySize: CGFloat = 45

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
        .frame(height: 4)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )
  }
}

struct CallerView: View {

  @ObservedObject var WatchLog: WatchLogEntry

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: "phone.arrow.down.left.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
        .symbolRenderingMode(.monochrome)
        .symbolVariant(.fill)
        .foregroundStyle(.blue)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top, spacing: 0) {
          Text("Telefon")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 120, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
          // prompt: Text("Placeholder").foregroundColor(.blue))

          TextField("", text: $WatchLog.CallerNumber)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
            .textInputAutocapitalization(.characters)
            //.border(.green)
            .lineLimit(1)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .textContentType(.telephoneNumber)
            .disabled(WatchLog.isLocked)
            .keyboardType(.numberPad)  // Show number pad
            .onChange(of: WatchLog.CallerNumber, initial: false) { old, value in
              WatchLog.CallerNumber = value.filter { $0.isNumber }
            }  // Allow only numeric characters
        }

        HStack(alignment: .top, spacing: 0) {
          Text("Name")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 120, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          TextField("", text: $WatchLog.CallerName)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
            //.textInputAutocapitalization(.characters)
            //.border(.green)
            .lineLimit(1)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .autocorrectionDisabled(true)
            .disabled(WatchLog.isLocked)
            .onChange(of: WatchLog.CallerName, initial: false) {
              print(WatchLog.CallerName)
            }
        }

        HStack(alignment: .top, spacing: 0) {
          Text("DOB")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 120, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          TextField("", text: $WatchLog.CallerDOB)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
            //.border(.green)
            .lineLimit(1)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .textContentType(.birthdate)
            .disabled(WatchLog.isLocked)
            .keyboardType(.numberPad)  // Show number pad
            .onChange(of: WatchLog.CallerDOB, initial: false) { old, value in
              let trimmedValue = value.trimingLeadingSpaces()
              if trimmedValue.isNumber {
                if trimmedValue.count == 8 {
                  let dateFormatter = DateFormatter()
                  dateFormatter.locale = Locale(identifier: "de_DE_POSIX")
                  dateFormatter.dateFormat = "ddMMyyyy"
                  if dateFormatter.date(from: trimmedValue) != nil {
                    let date = dateFormatter.date(from: trimmedValue)!
                    let formatDate = DateFormatter()
                    formatDate.dateFormat = "dd.MM.yyyy"
                    WatchLog.CallerDOB = formatDate.string(from: date)
                  } else {
                    WatchLog.CallerDOB = ""
                  }
                } else {
                  if trimmedValue.count > 8 {
                    WatchLog.CallerDOB = ""
                  } else {
                    WatchLog.CallerDOB = trimmedValue
                  }
                }
              } else {
                if trimmedValue.isDate {
                  WatchLog.CallerDOB = trimmedValue
                } else {
                  WatchLog.CallerDOB = ""
                }
              }
            }
        }

        HStack(alignment: .top, spacing: 0) {
          Text("Adresse")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 120, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          TextField("", text: $WatchLog.CallerInformation, axis: .vertical)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
            //.textInputAutocapitalization(.characters)
            //.border(.green)
            .lineLimit(4, reservesSpace: true)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .autocorrectionDisabled(true)
            .disabled(WatchLog.isLocked)

        }

      }

    }
    //.border(.brown)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
    .overlay(
      Rectangle()
        .frame(height: 4)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )

  }

}

struct AccidentView: View {
  //@Binding var nameText: String
  @ObservedObject var WatchLog: WatchLogEntry

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: "car.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
        .symbolRenderingMode(.monochrome)
        .symbolVariant(.fill)
        .foregroundStyle(.blue)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

      //.frame(width: 50, height: 50)

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top, spacing: 0) {

          Text("Verkehrsunfall")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(height: TextFieldHeight, alignment: .topLeading)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
            //.border(.red)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $WatchLog.isAccient)
            .labelsHidden()
            .toggleStyle(MyStyle())
            //.border(.red)
            .disabled(WatchLog.isLocked)

          Spacer()
        }

        HStack(alignment: .top, spacing: 0) {
          Text("Kennzeichen ON01")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 250, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          TextField("", text: $WatchLog.AccientLicensePlate01)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.frame(width: .infinity, height: TextFieldHeight, alignment: .leading)
            //.textInputAutocapitalization(.characters)
            //.border(.green)
            .lineLimit(1)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .autocorrectionDisabled(true)
            .disabled(WatchLog.isLocked)

        }
        .isHidden(!WatchLog.isAccient, remove: true)

        HStack(alignment: .top, spacing: 0) {
          Text("Kennzeichen ON02")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 250, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          TextField("", text: $WatchLog.AccientLicensePlate02)
            .font(Font.custom(TextFieldFont, size: TextFieldFontHeight))
            //.border(.green)
            .lineLimit(1)
            .foregroundStyle(.blue)
            .background(TextfieldBackgroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .autocorrectionDisabled(true)
            .disabled(WatchLog.isLocked)

        }
        .isHidden(!WatchLog.isAccient, remove: true)
        Spacer()

        HStack(alignment: .top, spacing: 0) {
          Text("Verletzte")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 150, height: TextFieldHeight, alignment: .top)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          Toggle("", isOn: $WatchLog.AccientInjured)
            .labelsHidden()
            .toggleStyle(MyStyle())
            .disabled(WatchLog.isLocked)

          Spacer()

          Text("Verkehrsunfallflucht")
            .font(Font.custom(LabelFont, size: LabelFontHeight))
            .foregroundStyle(.blue)
            .frame(width: 325, height: TextFieldHeight, alignment: .topLeading)
            //.border(.red)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)

          Toggle("", isOn: $WatchLog.AccientHitAndRun)
            .labelsHidden()
            .toggleStyle(MyStyle())
            .disabled(WatchLog.isLocked)
        }

        .isHidden(!WatchLog.isAccient, remove: true)

      }

    }
    //.border(.brown)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
    .overlay(
      Rectangle()
        .frame(height: 4)  // Border thickness
        .foregroundColor(.blue),  // Border color
      alignment: .bottom
    )
  }
}

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


fileprivate func clearEntry(LogEntry:WatchLogEntry, drawing:inout PKDrawing) {
    LogEntry.clear()
    drawing = PKDrawing()
    
}

fileprivate func newEntry(LogEntry:WatchLogEntry, drawing:inout PKDrawing) {
    LogEntry.new()
    drawing = PKDrawing()
    
}

struct MyStyle: ToggleStyle {
  let ImageIsOff: String = "rectangle.fill"
  let ImageIsOn: String = "checkmark.rectangle.fill"

  func makeBody(configuration: MyStyle.Configuration) -> some View {
    HStack(alignment: .center) {
      configuration.label

      Image(systemName: configuration.isOn ? ImageIsOn : ImageIsOff)
        .font(.largeTitle)
        .foregroundColor(configuration.isOn ? Color.green : Color.gray)
        .onTapGesture {
          configuration.$isOn.wrappedValue.toggle()
        }
    }
  }
}

struct MyStyleLock: ToggleStyle {
  let ImageIsOff: String = "rectangle.fill"
  let ImageIsOn: String = "checkmark.rectangle.fill"

  func makeBody(configuration: MyStyle.Configuration) -> some View {
    HStack(alignment: .center) {
      configuration.label

      Image(systemName: configuration.isOn ? ImageIsOn : ImageIsOff)
        .font(.largeTitle)
        .foregroundColor(configuration.isOn ? Color.red : Color.green)
        .onTapGesture {
          configuration.$isOn.wrappedValue.toggle()
        }
    }
  }
}

extension View {
  @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
    switch shouldHide {
    case true: self.hidden()
    case false: self
    }
  }
}

extension View {
  /// Hide or show a view based on a boolean value.
  ///
  /// Example for hiding while reclaiming space:
  ///
  ///     Text("Label")
  ///         .isHidden(true)
  ///
  /// Example for hiding, but leaving a gap where the hidden item was:
  ///
  ///     Text("Label")
  ///         .isHidden(true, remove: false)
  ///
  /// - Parameters:
  ///   - hidden: whether to hide the view.
  ///   - remove: whether you want to reclaim the space taken by the hidden view.
  @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
    if remove {
      if !hidden {
        self
      }
    } else {
      self.opacity(hidden ? 0 : 1)
    }
  }
}

struct CustomToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Rectangle()
        .fill(configuration.isOn ? Color.green : Color.red)
        .frame(width: 50, height: 30)  // Custom height
        .cornerRadius(15)
        .onTapGesture {
          configuration.isOn.toggle()
        }
    }
    .padding()
  }
}

extension String {
  var isNumber: Bool {
    return self.range(
      of: "^[0-9]*$",  // 1
      options: .regularExpression) != nil
  }
}

extension String {
  var isDate: Bool {
    return self.range(
      of: "^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$",  // 1
      options: .regularExpression) != nil
  }
}

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xff0000) >> 16) / 255.0
    let green = Double((hex & 0xff00) >> 8) / 255.0
    let blue = Double((hex & 0xff) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
}

extension String {
  func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
    guard
      let index = firstIndex(where: {
        !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet)
      })
    else {
      return self
    }

    return String(self[index...])
  }
}
