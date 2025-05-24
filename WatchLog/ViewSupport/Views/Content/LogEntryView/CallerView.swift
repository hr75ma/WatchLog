//
//  CallerView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct CallerView: View {

  @Bindable var WatchLog: WatchLogEntry

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

          TextField("", text: $WatchLog.CallerAdress, axis: .vertical)
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
