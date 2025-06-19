//
//  CallerView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI
import UIKit

struct CallerDataView: View {

  @Bindable var LogEntry: WatchLogEntry
  @Environment(\.appStyles) var appStyles

  @State private var withBirthday: Bool = true
  @State private var with: Bool = true
  @State private var tempDOB: Date = Date()
    @State private var tempLocked: Bool = false

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      Image(systemName: appStyles.SectionCallerImage)
        .SectionImageStyle(appStyles)

      VStack(alignment: .leading, spacing: 5) {

        HStack(alignment: .center, spacing: 0) {
          Text("Telefon")
            .SectionTextLabel(appStyles)

          TextField("", text: $LogEntry.CallerNumber)
            .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
            .textContentType(.telephoneNumber)
            .keyboardType(.numberPad)  // Show number pad
            .checkOnNumbers(text: $LogEntry.CallerNumber)
            .limitInputLength(text: $LogEntry.CallerNumber, length: 15)
            .showClearButton($LogEntry.CallerNumber)
            .disabled(LogEntry.isLocked)
        }

        HStack(alignment: .center, spacing: 0) {
          Text("Name")
            .SectionTextLabel(appStyles)

          TextField("", text: $LogEntry.CallerName)
            .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
            .textContentType(.name)
            .autocorrectionDisabled(true)
            .showClearButton($LogEntry.CallerName)
            .disabled(LogEntry.isLocked)
        }

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
                        isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
                    )
                  )
                  .frame(height: appStyles.TextFieldHeight)
                  .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                  .isHidden(tempLocked, remove: true)
              
                  VStack {
                      
                      Text(with ? getFormatedDateFromDOB(from: tempDOB) : "")
                          .SectionTextFieldSimulatedSingleLine(appStyles, isLocked: LogEntry.isLocked)
                          .isHidden(!tempLocked, remove: true)
                      
                      DatePicker("", selection: $tempDOB, displayedComponents: [.date])
                          .labelsHidden()  // Hides the default label
                          .colorMultiply(.blue)
                          .font(.system(size: 35, weight: .bold))
                          .frame(width: 300, height: 80)
                          .clipped()
                          .datePickerStyle(WheelDatePickerStyle())
                          .environment(\.locale, Locale.current)
                          .isHidden(!with || tempLocked, remove: true)
                  }
              }
              .onChange(of: LogEntry.isLocked) {
                  withAnimation {
                      tempLocked = LogEntry.isLocked
                  }
              }
              .onChange(of: LogEntry.uuid) {
                  withAnimation {
                      if LogEntry.CallerDOB == nil {
                          tempDOB = Date()
                          withBirthday = false
                      } else {
                          tempDOB = LogEntry.CallerDOB!
                          withBirthday = true
                      }
                  }
              }
              .onChange(of: tempDOB) {
                  withAnimation {
                      print("1. onChang")
                      LogEntry.CallerDOB = tempDOB
                  }
              }
              .onChange(of: withBirthday) { old, value in
                  withAnimation {
                      print("2. onChang")
                      if !withBirthday {
                          LogEntry.CallerDOB = nil
                          with = withBirthday
                          
                      } else {
                          LogEntry.CallerDOB = tempDOB
                          with = withBirthday
                          
                      }
                  }
              }
              .onAppear {
                  withAnimation {
                      print("onapear")
                      if LogEntry.CallerDOB == nil {
                          tempDOB = Date()
                          withBirthday = false
                          with = withBirthday
                      } else {
                          tempDOB = LogEntry.CallerDOB!
                          withBirthday = true
                          with = withBirthday
                      }
                      tempLocked = LogEntry.isLocked
                  }
              }
          }
        HStack(alignment: .top, spacing: 0) {
          Text("Adresse")
            .SectionTextLabel(appStyles)
            .frame(alignment: .topLeading)

          TextField("", text: $LogEntry.CallerAdress, axis: .vertical)
            .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(4, reservesSpace: true)
            .autocorrectionDisabled(true)
            .showClearButton($LogEntry.CallerAdress)
            .disabled(LogEntry.isLocked)

        }

      }

    }

    .disabled(LogEntry.isLocked)
    //.border(.brown)
    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))

    .overlay(
      Rectangle()
        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
      alignment: .bottom
    )
    //.animation(.easeInOut(duration: 1),  value: withBirthday)
  }

}

fileprivate func getFormatedDateFromDOB(from dob: Date?) -> String {
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
