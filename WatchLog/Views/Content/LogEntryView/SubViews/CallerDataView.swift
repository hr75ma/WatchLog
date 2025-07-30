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
    let viewIsReadOnly: Bool

    @Environment(\.appStyles) var appStyles
    @Environment(\.colorScheme) var colorScheme

    @State private var withBirthday: Bool = true
    @State private var with: Bool = true
    @State private var tempLocked: Bool = false

    @Namespace private var namespace

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            SectionImageView(sectionType: SectionImageType.callerData)

            VStack(alignment: .leading, spacing: 5) {
               
                Form {
                    phoneSubSection
                 
                    
                    nameSubSection
                    
                    adressSubSection
                    
                    dobSubSection
                    
                    
                }
                .formStyle(.columns)
            }
        }
        .disabled(logEntry.isLocked)
        .standardSubViewPadding()
        .standardBottomBorder()
    }
}

extension CallerDataView {
    private var phoneSubSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            FloatingBorderLabelTextField("Telefon", textfieldContent: $logEntry.callerNumber, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 20, tint: .watchLogFont, autoResizes: true))
                //.textFieldCheckOnNumbers(text: $logEntry.callerNumber)
                .numericTextInputField(text: $logEntry.callerNumber)
                .textContentType(.telephoneNumber)
                .keyboardType(.numberPad)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
    
    private var nameSubSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            FloatingBorderLabelTextField("Name", textfieldContent: $logEntry.callerName, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, tint: .watchLogFont, autoResizes: true))
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }

    private var adressSubSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            FloatingBorderLabelTextField("Adresse", textfieldContent: $logEntry.callerAdress, isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.multiLine, textfieldLevel: TextFieldLevel.standard, limit: 200, tint: .watchLogFont, autoResizes: true))
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }

    
    
    var dobSubSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if !viewIsReadOnly && !logEntry.isLocked {
                    Text("Geburtstag")
                        .textLabel(textLabelLevel: TextLabelLevel.standard)
            }

            HStack(alignment: .top, spacing: 0) {
                if viewIsReadOnly {
                    ReadOnlyContent()

                } else {
                    EditableContent()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onChange(of: logEntry.isLocked) {
                withAnimation(.smooth(duration: 1)) {
                    tempLocked = logEntry.isLocked
                }
            }
            .onChange(of: withBirthday) { _, _ in
                withAnimation(.smooth(duration: 1)) {
                    if !withBirthday {
                        logEntry.callerDOB = nil
                        with = withBirthday
                    } else {
                        with = withBirthday
                    }
                }
            }
            .onAppear {
                if viewIsReadOnly {
                    switchBirthday()
                } else {
                    withAnimation(.smooth(duration: 1)) {
                        switchBirthday()
                    }
                }
            }
        }
    }
    
    private func switchBirthday() {
        if logEntry.callerDOB == nil {
            withBirthday = false
            with = withBirthday
        } else {
            withBirthday = true
            with = withBirthday
        }
        tempLocked = logEntry.isLocked
    }
}

extension CallerDataView {
    private func ReadOnlyContent() -> some View {
        HStack(alignment: .center, spacing: 0) {
            if tempLocked {
                
                VStack(alignment: .leading, spacing: 0) {
                    FloatingBorderLabelSimulatedTextField("Geburstag", textfieldContent: DateManipulation.getFormatedDateFromDOB(from: logEntry.callerDOB), isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, tint: .watchLogFont, autoResizes: true))
                        .isHidden(logEntry.callerDOB == nil || !tempLocked, remove: true)
                        
                }
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
//                Text(DateManipulation.getFormatedDateFromDOB(from: logEntry.callerDOB))
//                    .sectionSimulatedTextFieldSingleLine(
//                        isLocked: logEntry.isLocked
//                    )
//                    .isHidden(logEntry.callerDOB == nil || !tempLocked, remove: true)
               // Spacer()
            }
        }
    }

    private func EditableContent() -> some View {
        HStack(alignment: .top, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    ToggleView(
                        toggleValue: self.$withBirthday, isLocked: logEntry.isLocked, removeAnimation: viewIsReadOnly, toggleType: .standard
                    )
                    .isHidden(tempLocked, remove: true)

                    DatePicker("", selection: $logEntry.callerDOB ?? Date(), in: ...Date(), displayedComponents: [.date])
                        .datePickerWheelStyle()
                        .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                        .isHidden(!with || tempLocked, remove: true)
                }
            }

            if tempLocked {
                VStack(alignment: .leading, spacing: 0) {
                    FloatingBorderLabelSimulatedTextField("Geburstag", textfieldContent: DateManipulation.getFormatedDateFromDOB(from: logEntry.callerDOB), isLocked: logEntry.isLocked, disableAnimation: viewIsReadOnly, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, tint: .watchLogFont, autoResizes: true))
                        .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                        .isHidden(logEntry.callerDOB == nil || !tempLocked, remove: true)
                }
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}



public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

//            Toggle("", isOn: $withBirthday)
//              .labelsHidden()
//              .toggleStyle(
//                toggleStyleAnimationImage(
//                  isOnImage: "inset.filled.circle.dashed",
//                  isOffImage: "inset.filled.circle.dashed",
//                  isOnColorPrimary: appStyles.GeneralToggleIsActivePrimary,
//                  isOnColorSecondary: appStyles.GeneralToggleIsActiveSecondary,
//                  isOffColorPrimary: Color.red,
//                  isOffColorSecondary: appStyles.GeneralToggleIsUnactiveSecondary,
//                  isLocked: logEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
//                )
//              )
//              .frame(height: appStyles.TextFieldHeight)
//              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//              .isHidden(tempLocked, remove: true)
