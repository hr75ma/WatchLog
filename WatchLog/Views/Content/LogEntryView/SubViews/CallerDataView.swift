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
            .sectionTextLabel(appStyles: appStyles)

      TextField("", text: $logEntry.CallerNumber)
        .sectionTextField(appStyles: appStyles, text: $logEntry.CallerNumber, isLocked: logEntry.isLocked, numberOfCharacters: 20)
        .textFieldCheckOnNumbers(text: $logEntry.CallerNumber)
        .textContentType(.telephoneNumber)
        .keyboardType(.numberPad)

    }
  }

  private var nameSubSection: some View {
    HStack(alignment: .center, spacing: 0) {
      Text("Name")
            .sectionTextLabel(appStyles: appStyles)
            

      TextField("", text: $logEntry.CallerName)
        .sectionTextField(appStyles: appStyles, text: $logEntry.CallerName, isLocked: logEntry.isLocked, numberOfCharacters: 50)
    }
  }

  private var dobSubSection: some View {
    HStack(alignment: .top, spacing: 0) {
      Text("DOB")
            .sectionTextLabel(appStyles: appStyles)


      HStack(alignment: .top, spacing: 0) {
          

              
              HStack {
                  Toggle("", isOn: $withBirthday)
                      .labelsHidden()
                      .toggleStyle(
                        generalToggleStyleImage(appStyles: appStyles, isLocked: logEntry.isLocked)
                      )
                      .frame(height: appStyles.TextFieldHeight)
                      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                      .isHidden(tempLocked, remove: true)
                  
                  Toggle("", isOn: $withBirthday)
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
                  
                      .frame(width: 300, height: 100)
                      .clipped()
                      .contentShape(Rectangle())
                      .datePickerStyle(WheelDatePickerStyle())
                      .background(appStyles.GeneralBackgroundColor)
                      .environment(\.locale, Locale.current)
                      .isHidden(!with || tempLocked, remove: true)
              }
              .matchedGeometryEffect(id: "lockedEvent", in: namespace)
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
         
              
          Text(getFormatedDateFromDOB(from: logEntry.CallerDOB))
                      .SectionTextFieldSimulatedSingleLine(appStyles: appStyles, isLocked: logEntry.isLocked)
                      .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                      .isHidden(!tempLocked, remove: true)
          
          
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
            .sectionTextLabel(appStyles: appStyles)
        .frame(alignment: .topLeading)

      TextField("", text: $logEntry.CallerAdress, axis: .vertical)
        .sectionTextField(appStyles: appStyles, text: $logEntry.CallerAdress, isLocked: logEntry.isLocked, numberOfCharacters: 500)
        .lineLimit(4, reservesSpace: true)
    }
  }

}

public func ??<T: Sendable>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

private func getFormatedDateFromDOB(from dob: Date?) -> String {
  if dob != nil {
    return dob!.formatted(date: .long, time: .omitted)
  }
  return ""
}
