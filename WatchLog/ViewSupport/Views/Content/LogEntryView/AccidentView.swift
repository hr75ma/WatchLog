//
//  AccidentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct AccidentSelectionView: View {
  @Bindable var LogEntry: WatchLogEntry
  @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: GeneralStyles.SectionAccidentImage)
        .SectionImageStyle(GeneralStyles)

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .center, spacing: 0) {

          Text("Verkehrsunfall")
            .SectionTextLabelForToggle(GeneralStyles)

          Toggle("", isOn: $LogEntry.isAccient)
            .labelsHidden()
            .toggleStyle(
                ToggleStyleImage(
            isOnImage: GeneralStyles.AccidentImageisLocked,
            isOffImage: GeneralStyles.AccidentImageisUnLocked,
            isOnColorPrimary: GeneralStyles.AccidentColorIsLockedPrimary,
            isOnColorSecondary: GeneralStyles.AccidentColorIsLockedSecondary,
            isOffColorPrimary: GeneralStyles.AccidentColorIsUnLockedPrimary,
            isOffColorSecondary: GeneralStyles.AccidentColorIsUnLockedSecondary
            ))
            .frame(height: GeneralStyles.LabelFontSize2, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)
          Spacer()

        }
        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))

        HStack(alignment: .center, spacing: 0) {
          Text("Kennzeichen ON01")
            .SectionTextLabelSecond(GeneralStyles)
            .frame(width: 215, height: GeneralStyles.TextFieldHeight2, alignment: .topLeading)

          TextField("", text: $LogEntry.AccientLicensePlate01)
                .SectionTextFieldSingleLineSecond(GeneralStyles, isLocked: LogEntry.isLocked)
            .disabled(LogEntry.isLocked)

        }
        .isHidden(!LogEntry.isAccient, remove: true)

        HStack(alignment: .center, spacing: 0) {
          Text("Kennzeichen ON02")
            .SectionTextLabelSecond(GeneralStyles)
            .frame(width: 215, height: GeneralStyles.TextFieldHeight2, alignment: .topLeading)

          TextField("", text: $LogEntry.AccientLicensePlate02)
                .SectionTextFieldSingleLineSecond(GeneralStyles, isLocked: LogEntry.isLocked)
            .disabled(LogEntry.isLocked)

        }
        .isHidden(!LogEntry.isAccient, remove: true)
        Spacer()

        HStack(alignment: .center, spacing: 0) {
          Text("Verletzte")
            .SectionTextLabelSecond(GeneralStyles)
            .fixedSize(horizontal: true, vertical: true)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $LogEntry.AccientInjured)
            .labelsHidden()
            .toggleStyle(
            ToggleStyleImage(
        isOnImage: GeneralStyles.AccidentImageisLocked,
        isOffImage: GeneralStyles.AccidentImageisUnLocked,
        isOnColorPrimary: GeneralStyles.AccidentColorIsLockedPrimary,
        isOnColorSecondary: GeneralStyles.AccidentColorIsLockedSecondary,
        isOffColorPrimary: GeneralStyles.AccidentColorIsUnLockedPrimary,
        isOffColorSecondary: GeneralStyles.AccidentColorIsUnLockedSecondary
        ))
            .frame(height: GeneralStyles.TextFieldHeight2, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .disabled(LogEntry.isLocked)

          Spacer()

          Text("Verkehrsunfallflucht")
            .SectionTextLabelSecond(GeneralStyles)
            .fixedSize(horizontal: true, vertical: true)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

          Toggle("", isOn: $LogEntry.AccientHitAndRun)
            .labelsHidden()
            .toggleStyle(
            ToggleStyleImage(
        isOnImage: GeneralStyles.AccidentImageisLocked,
        isOffImage: GeneralStyles.AccidentImageisUnLocked,
        isOnColorPrimary: GeneralStyles.AccidentColorIsLockedPrimary,
        isOnColorSecondary: GeneralStyles.AccidentColorIsLockedSecondary,
        isOffColorPrimary: GeneralStyles.AccidentColorIsUnLockedPrimary,
        isOffColorSecondary: GeneralStyles.AccidentColorIsUnLockedSecondary
        ))
            .frame(height: GeneralStyles.TextFieldHeight2, alignment: .center)
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
        .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
  }
}

extension Text {

  fileprivate func SectionTextLabelSecond(_ generalStyles: GeneralStylesLogEntry) -> some View {
    self
      .font(Font.custom(generalStyles.LabelFont, size: generalStyles.TextFieldHeight2))
      .foregroundStyle(generalStyles.GeneralTextColor)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      .multilineTextAlignment(.leading)
      .lineLimit(1)
      .fixedSize(horizontal: false, vertical: true)

  }

}

extension TextField {

  fileprivate func SectionTextFieldSingleLineSecond(_ generalStyles: GeneralStylesLogEntry)
    -> some View
  {
    self
      .font(Font.custom(generalStyles.TextFieldFont, size: generalStyles.TextFieldHeight2))
      .textInputAutocapitalization(.characters)
      .lineLimit(1)
      .foregroundStyle(generalStyles.GeneralTextColor)
      .background(generalStyles.TextfieldBackgroundColor)
      .fixedSize(horizontal: false, vertical: true)
      .textContentType(.telephoneNumber)
  }
    
    fileprivate func SectionTextFieldSingleLineSecond(_ generalStyles: GeneralStylesLogEntry, isLocked: Bool)
      -> some View
    {
      self
        .font(Font.custom(generalStyles.TextFieldFont, size: generalStyles.TextFieldHeight2))
        .textInputAutocapitalization(.characters)
        .lineLimit(1)
        .foregroundStyle(generalStyles.GeneralTextColor)
        .background(isLocked ? generalStyles.TextfieldBackgroundColorLocked : generalStyles.TextfieldBackgroundColorUnLocked)
        .fixedSize(horizontal: false, vertical: true)
        .textContentType(.telephoneNumber)
        .animation(.easeInOut(duration: 1),  value: isLocked)
    }
}
