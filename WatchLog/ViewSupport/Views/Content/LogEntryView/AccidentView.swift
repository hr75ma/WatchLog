//
//  AccidentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct AccidentView: View {
  //@Binding var nameText: String
  @Bindable var WatchLog: WatchLogEntry

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
