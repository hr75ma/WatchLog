//
//  CallerView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI
import UIKit

struct CallerDataView: View {

  @Bindable var logEntry: WatchLogEntry
  @Environment(\.appStyles) var appStyles

  @State private var withBirthday: Bool = true
  @State private var with: Bool = true
  @State private var tempDOB: Date = Date()
  @State private var tempLocked: Bool = false
    
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
        
      SectionImage
      

      VStack(alignment: .leading, spacing: 5) {

        phoneSubSection

        nameSubSection

        dobSubSection

        adressSubSection
      }
    }
    .disabled(logEntry.isLocked)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
    .overlay(
      Rectangle()
        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
  }
}


extension CallerDataView {

  private var SectionImage: some View {
    Image(systemName: appStyles.SectionCallerImage)
          .SectionImageStyle(primaryColor: appStyles.SectionCallerImagePrimary, secondaryColor: appStyles.SectionCallerImageSecondary)
        //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
  }

  private var phoneSubSection: some View {

    HStack(alignment: .center, spacing: 0) {
      Text("Telefon")
        .SectionTextLabel(appStyles)

      TextField("", text: $logEntry.CallerNumber)
        //.SectionTextField(appStyles: appStyles, text: $logEntry.CallerNumber, isLocked: logEntry.isLocked, numberOfCharacters: 15)
        .SectionTextFieldSingleLine(appStyles, isLocked: logEntry.isLocked)
        .checkOnNumbers(text: $logEntry.CallerNumber)
        //.showClearButton($logEntry.CallerNumber)
        .textContentType(.telephoneNumber)
        .keyboardType(.numberPad)
        .disabled(logEntry.isLocked)
    }
  }

  private var nameSubSection: some View {
    HStack(alignment: .center, spacing: 0) {
      Text("Name")
        .SectionTextLabel(appStyles)

      TextField("", text: $logEntry.CallerName)
        .SectionTextFieldSingleLine(appStyles, isLocked: logEntry.isLocked)
        .textContentType(.name)
        .autocorrectionDisabled(true)
        //.showClearButton($logEntry.CallerName)
        .disabled(logEntry.isLocked)
    }
  }

  private var dobSubSection: some View {
    HStack(alignment: .top, spacing: 0) {
      Text("DOB")
        .SectionTextLabel(appStyles)

      HStack(alignment: .top, spacing: 0) {

        Toggle("", isOn: $withBirthday)
          .labelsHidden()
          .toggleStyle(
            ToggleStyleImage(
              isOnImage: appStyles.GeneralToggleIsActiveImage,
              isOffImage: appStyles.GeneralToggleIsUnactiveImage,
              isOnColorPrimary: appStyles.GeneralToggleIsActivePrimary,
              isOnColorSecondary: appStyles.GeneralToggleIsActiveSecondary,
              isOffColorPrimary: appStyles.GeneralToggleIsUnactivePrimary,
              isOffColorSecondary: appStyles.GeneralToggleIsUnactiveSecondary,
              isLocked: logEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
            )
          )
          .frame(height: appStyles.TextFieldHeight)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          .isHidden(tempLocked, remove: true)

        Toggle("", isOn: $withBirthday)
          .labelsHidden()
          .toggleStyle(
            ToggleStyleAnimationImage(
              isOnImage: "inset.filled.circle.dashed",
              isOffImage: "inset.filled.circle.dashed",
              isOnColorPrimary: appStyles.GeneralToggleIsActivePrimary,
              isOnColorSecondary: appStyles.GeneralToggleIsActiveSecondary,
              isOffColorPrimary: Color.red,
              isOffColorSecondary: appStyles.GeneralToggleIsUnactiveSecondary,
              isLocked: logEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
            )
          )
          .frame(height: appStyles.TextFieldHeight)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
          .isHidden(tempLocked, remove: true)

        VStack {

          Text(with ? getFormatedDateFromDOB(from: tempDOB) : "")
            .SectionTextFieldSimulatedSingleLine(appStyles, isLocked: logEntry.isLocked)
            .isHidden(!tempLocked, remove: true)

          DatePicker("", selection: $tempDOB, displayedComponents: [.date])
            .labelsHidden()  // Hides the default label
            .colorMultiply(.blue)
            .font(.system(size: 35, weight: .bold))
            .frame(width: 300, height: 100)
            .clipped()
            .contentShape(Rectangle())
            .datePickerStyle(WheelDatePickerStyle())
            .environment(\.locale, Locale.current)
            .isHidden(!with || tempLocked, remove: true)
        }
      }
      .onChange(of: logEntry.isLocked) {
        withAnimation(.easeInOut(duration: 1)) {
          tempLocked = logEntry.isLocked
        }
      }
      .onChange(of: logEntry.uuid) {
        withAnimation(.easeInOut(duration: 1)) {
          if logEntry.CallerDOB == nil {
            //tempDOB = Date()
            withBirthday = false
          } else {
            tempDOB = logEntry.CallerDOB!
            withBirthday = true
          }
        }
      }
      .onChange(of: tempDOB) {
        withAnimation(.easeInOut(duration: 1)) {
          print("1. onChang")
          logEntry.CallerDOB = tempDOB
        }
      }
      .onChange(of: withBirthday) { old, value in
        withAnimation(.easeInOut(duration: 1)) {
          print("2. onChang")
          if !withBirthday {
            logEntry.CallerDOB = nil
            with = withBirthday

          } else {
            logEntry.CallerDOB = tempDOB
            with = withBirthday

          }
        }
      }
      .onAppear {
        withAnimation(.easeInOut(duration: 1)) {
          print("onapear")
          if logEntry.CallerDOB == nil {
            //tempDOB = Date()
            withBirthday = false
            with = withBirthday
          } else {
            tempDOB = logEntry.CallerDOB!
            withBirthday = true
            with = withBirthday
          }
          tempLocked = logEntry.isLocked
        }
      }
    }
  }

  private var adressSubSection: some View {
    HStack(alignment: .top, spacing: 0) {
      Text("Adresse")
        .SectionTextLabel(appStyles)
        .frame(alignment: .topLeading)

      TextField("", text: $logEntry.CallerAdress, axis: .vertical)
        .SectionTextFieldSingleLine(appStyles, isLocked: logEntry.isLocked)
        .fixedSize(horizontal: false, vertical: true)
        .lineLimit(4, reservesSpace: true)
        .autocorrectionDisabled(true)
        .showClearButton($logEntry.CallerAdress)
        .disabled(logEntry.isLocked)

    }
  }

}

private func getFormatedDateFromDOB(from dob: Date?) -> String {
  if dob != nil {
    return dob!.formatted(date: .long, time: .omitted)
  }
  return ""
}

extension View {
  @ViewBuilder func applyTextColor(_ color: Color) -> some View {
    if UITraitCollection.current.userInterfaceStyle == .light {
      self.colorInvert().colorMultiply(color)
    } else {
      self.colorMultiply(color)
    }
  }
}
