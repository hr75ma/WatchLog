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
  @State private var tempLocked: Bool = false

  @Namespace private var namespace

  var body: some View {
    HStack(alignment: .top, spacing: 0) {

        ViewSectionImage(sectionType: SectionImageType.callerData)

      VStack(alignment: .leading, spacing: 5) {

        phoneSubSection

        nameSubSection

        dobSubSection

        adressSubSection
      }
    }
    .disabled(logEntry.isLocked)
    .standardSubViewPadding()
    .standardBottomBorder(appStyles)
  }
}

extension CallerDataView {

  private var phoneSubSection: some View {

    HStack(alignment: .center, spacing: 0) {
      Text("Telefon")
        .sectionTextLabel()
        
      TextField("", text: $logEntry.CallerNumber)
            .sectionTextField(text: $logEntry.CallerNumber, isLocked: logEntry.isLocked,
                              numberOfCharacters: 20, appStyles: appStyles
        )
        .textFieldCheckOnNumbers(text: $logEntry.CallerNumber)
        .textContentType(.telephoneNumber)
        .keyboardType(.numberPad)

    }
  }

  private var nameSubSection: some View {
    HStack(alignment: .center, spacing: 0) {
      Text("Name")
        .sectionTextLabel()

      TextField("", text: $logEntry.CallerName)
        .sectionTextField(
            text: $logEntry.CallerName, isLocked: logEntry.isLocked, numberOfCharacters: 50,
            appStyles: appStyles)
    }
  }

  private var dobSubSection: some View {
    HStack(alignment: .top, spacing: 0) {
      Text("DOB")
        .sectionTextLabel()

      HStack(alignment: .top, spacing: 0) {

        HStack(alignment: .top, spacing: 0) {

         

          HStack(alignment: .top, spacing: 0) {

            Toggle("", isOn: $withBirthday)
              //    .matchedGeometryEffect(id: "lockedEvent", in: namespace)
              .labelsHidden()
              .toggleStyle(
                generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
              )
              .frame(height: appStyles.TextFieldHeight)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
              .isHidden(tempLocked, remove: true)

            Toggle("", isOn: $withBirthday)
               //   .matchedGeometryEffect(id: "lockedEvent", in: namespace)
              .labelsHidden()
              .toggleStyle(
                toggleStyleAnimationImage(
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

            DatePicker("", selection: $logEntry.CallerDOB ?? Date(), displayedComponents: [.date])
              .labelsHidden()  // Hides the default label
              .colorMultiply(.blue)
              .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldFontSize))
              .matchedGeometryEffect(id: "lockedEvent", in: namespace)
              .frame(width: 300, height: 100)
              .clipped()
              .contentShape(Rectangle())
              .datePickerStyle(WheelDatePickerStyle())
              .background(appStyles.GeneralBackgroundColor)
              .environment(\.locale, Locale.current)
              .isHidden(!with || tempLocked, remove: true)
          }
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
          
           if tempLocked {
               Text(DateManipulation.getFormatedDateFromDOB(from: logEntry.CallerDOB))
               .SectionTextFieldSimulatedSingleLine(
                 appStyles: appStyles, isLocked: logEntry.isLocked
               )
               .matchedGeometryEffect(id: "lockedEvent", in: namespace)
               .isHidden(logEntry.CallerDOB == nil || !tempLocked, remove: true)
             Spacer()
           }

      }
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      .onChange(of: logEntry.isLocked) {
        withAnimation(.easeInOut(duration: 1)) {
          tempLocked = logEntry.isLocked
        }
      }
      .onChange(of: logEntry.uuid) {
        withAnimation(.easeInOut(duration: 1)) {
          if logEntry.CallerDOB == nil {
            withBirthday = false
          } else {
            withBirthday = true
          }
        }
      }
      .onChange(of: withBirthday) { old, value in
        withAnimation(.easeInOut(duration: 1)) {
          print("2. onChang")
          if !withBirthday {
            logEntry.CallerDOB = nil
            with = withBirthday
          } else {
            with = withBirthday
          }
        }
      }
      .onAppear {
        withAnimation(.easeInOut(duration: 1)) {
          print("onappear")
          if logEntry.CallerDOB == nil {
            withBirthday = false
            with = withBirthday
          } else {
            withBirthday = true
            with = withBirthday
          }
          tempLocked = logEntry.isLocked
        }
      }
    }
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }

  private var adressSubSection: some View {
    HStack(alignment: .top, spacing: 0) {
      Text("Adresse")
        .sectionTextLabel()
        .frame(alignment: .topLeading)

      TextField("", text: $logEntry.CallerAdress, axis: .vertical)
        .sectionTextFieldMultiline(
          text: $logEntry.CallerAdress, isLocked: logEntry.isLocked,
          numberOfCharacters: 500, appStyles: appStyles
        )
    }
  }

}

public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
  Binding(
    get: { lhs.wrappedValue ?? rhs },
    set: { lhs.wrappedValue = $0 }
  )
}


