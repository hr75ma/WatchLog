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
        VStack(alignment: .leading, spacing: 0) {
            SectionTitle(sectionTitleType: SectionTitleType.callerData)

            VStack(alignment: .leading, spacing: 0) {
                Form {
                    phoneSubSection
                        .standardInputPadding()

                    nameSubSection
                        .standardInputPadding()
                    
                    adressSubSection
                        .standardInputPadding()

                    dobSubSection
                }
                .formStyle(.columns)
            }
            .standardSectionContentPadding()
        }
        .disabled(logEntry.isLocked)
        .standardBottomBorder()
    }
}

extension CallerDataView {
    private var phoneSubSection: some View {
        FloatingBorderLabelTextField("Telefon", textfieldContent: $logEntry.callerNumber, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 100, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
            .numericTextInputField(text: $logEntry.callerNumber)
            .textContentType(.telephoneNumber)
            .keyboardType(.numberPad)
    }

    private var nameSubSection: some View {
        FloatingBorderLabelTextField("Name", textfieldContent: $logEntry.callerName, config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, textfieldAutoCapitalization: .words, limit: 50, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
    }

    private var adressSubSection: some View {
        FloatingBorderLabelTextField("Adresse", textfieldContent: $logEntry.callerAdress, config: .init(textfieldType: TextFieldType.multiLine, textfieldLevel: TextFieldLevel.standard, textfieldAutoCapitalization: .words, limit: 200, autoResizes: true, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
    }

    private var dobSubSection: some View {
        EditableContent()
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
    private func EditableContent() -> some View {
        HStack(alignment: .top, spacing: 0) {
            
            if !logEntry.isLocked {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Geburtsdatum")
                        .textLabel(textLabelLevel: TextLabelLevel.standard, isDimmend: !self.withBirthday, disableAnimation: viewIsReadOnly)
                        .standardInputPadding()
                        .isHidden(tempLocked, remove: true)

                    HStack(alignment: .top, spacing: 0) {
                        ToggleView(
                            toggleValue: self.$withBirthday, isLocked: logEntry.isLocked, isDimmend: !withBirthday, removeAnimation: viewIsReadOnly, toggleType: .standard
                        )
                        .isHidden(tempLocked, remove: true)

                        DatePicker("", selection: $logEntry.callerDOB ?? Date(), in: ...Date(), displayedComponents: [.date])
                            .datePickerWheelStyle()
                            .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                            .isHidden(!with || tempLocked, remove: true)
                    }
                }
            }

            HStack(alignment: .center, spacing: 0) {
                if tempLocked {
                    VStack(alignment: .leading, spacing: 0) {
                        FloatingBorderLabelSimulatedTextField("Geburtsdatum", textfieldContent: DateManipulation.getFormatedDateFromDOB(from: logEntry.callerDOB), config: .init(textfieldType: TextFieldType.singleLine, textfieldLevel: TextFieldLevel.standard, limit: 50, autoResizes: true, withClearButton: false, disableAnimation: viewIsReadOnly, isLocked: logEntry.isLocked))
                            .matchedGeometryEffect(id: "lockedEvent", in: namespace)
                            .standardInputPadding()
                            .isHidden(logEntry.callerDOB == nil || !tempLocked, remove: true)
                    }
                }
            }
        }
        // .standardInputViewPadding()
        .onChange(of: logEntry.isLocked) { _, _ in
            withAnimation(.smooth) {
                tempLocked = logEntry.isLocked
            }
        }
        .onChange(of: withBirthday) { _, _ in
            withAnimation(.smooth) {
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
                withAnimation(.smooth) {
                    switchBirthday()
                }
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
