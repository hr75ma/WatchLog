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









struct AccidentSelectionView: View {
  @Bindable var LogEntry: WatchLogEntry
    @EnvironmentObject var textStyles: TextFieldStyleLogEntry
    
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
        Image(systemName: textStyles.AccidentImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
        .symbolRenderingMode(.monochrome)
        .symbolVariant(.fill)
        .foregroundStyle(.blue)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .top, spacing: 0) {

          Text("Verkehrsunfall")
                .font(Font.custom(textStyles.LabelFont, size: textStyles.LabelFontSize2))
                .foregroundStyle(.blue)
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $LogEntry.isAccient)
                .labelsHidden()
                .toggleStyle(ToggleStyleLock())
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)

          Spacer()
            
        }

          HStack(alignment: .center, spacing: 0) {
          Text("Kennzeichen ON01")
                .font(Font.custom(textStyles.LabelFont, size: textStyles.TextFieldHeight2))
                .foregroundStyle(.blue)
                .frame(width:208, height: textStyles.TextFieldHeight2, alignment: .topLeading)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          TextField("", text: $LogEntry.AccientLicensePlate01)
                .font(Font.custom(textStyles.TextFieldFont, size: textStyles.TextFieldHeight2))
                .textInputAutocapitalization(.characters)
                .lineLimit(1)
                .foregroundStyle(.blue)
                .background(textStyles.TextfieldBackgroundColor)
                .fixedSize(horizontal: false, vertical: true)
                .textContentType(.telephoneNumber)
                .disabled(LogEntry.isLocked)

        }
        .isHidden(!LogEntry.isAccient, remove: true)

        HStack(alignment: .center, spacing: 0) {
          Text("Kennzeichen ON02")
                .font(Font.custom(textStyles.LabelFont, size: textStyles.TextFieldHeight2))
                .foregroundStyle(.blue)
                .frame(width:208, height: textStyles.TextFieldHeight2, alignment: .topLeading)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          TextField("", text: $LogEntry.AccientLicensePlate02)
                .font(Font.custom(textStyles.TextFieldFont, size: textStyles.TextFieldHeight2))
                .textInputAutocapitalization(.characters)
                .lineLimit(1)
                .foregroundStyle(.blue)
                .background(textStyles.TextfieldBackgroundColor)
                .fixedSize(horizontal: false, vertical: true)
                .textContentType(.telephoneNumber)
                .disabled(LogEntry.isLocked)

        }
        .isHidden(!LogEntry.isAccient, remove: true)
        Spacer()

        HStack(alignment: .top, spacing: 0) {
          Text("Verletzte")
                .font(Font.custom(textStyles.LabelFont, size: textStyles.TextFieldHeight2))
                .foregroundStyle(.blue)
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $LogEntry.AccientInjured)
                .labelsHidden()
                .toggleStyle(ToggleStyleLock())
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)

          Spacer()

          Text("Verkehrsunfallflucht")
                .font(Font.custom(textStyles.LabelFont, size: textStyles.TextFieldHeight2))
                .foregroundStyle(.blue)
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $LogEntry.AccientHitAndRun)
                .labelsHidden()
                .toggleStyle(ToggleStyleLock())
                .frame(height: textStyles.TextFieldHeight, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)
        }

        .isHidden(!LogEntry.isAccient, remove: true)

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
