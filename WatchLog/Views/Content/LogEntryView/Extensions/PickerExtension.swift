//
//  PickerExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 13.06.25.
//

import Foundation
import SwiftUI

struct customSegmentedPickerView: View {
    @Binding var preselectedIndex: CallInType.CallInTypeShort
    let appStyles: StylesLogEntry

    init(preselectedIndex: Binding<CallInType.CallInTypeShort>, appStyles: StylesLogEntry) {
        _preselectedIndex = preselectedIndex
        self.appStyles = appStyles

        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.watchLogFrameBorder)
        UISegmentedControl.appearance().backgroundColor = UIColor(.watchLogTextfieldBackgroundUnlocked)

        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: appStyles.segmentedCallInFontSize, weight: .semibold, width: .standard), .foregroundColor: UIColor(.watchLogFont)], for: .normal)

        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: appStyles.segmentedCallInFontSize, weight: .semibold, width: .standard), .foregroundColor: UIColor(.watchLogSelectedCallIn)], for: .selected)

        UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    var body: some View {
        Picker("", selection: $preselectedIndex) {
            ForEach(
                Array(
                    CallInType.callInTypes.sorted { first, second -> Bool in
                        first.value < second.value
                    }), id: \.key
            ) { _, value in

                // callInItem(value: value, key: key, isLocked: false, isSelected: true).tag(key)
                Text(value)
                    // .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .frame(height: appStyles.callInFieldHeight)
        .pickerStyle(.segmented)
    }
}

extension DatePicker {
    func datePickerWheelStyle() -> some View {
        modifier(
            DatePickerModifier())
    }
}

private struct DatePickerModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .labelsHidden() // Hides the default label
            .colorMultiply(.watchLogFont)
            .background(.watchLogViewBackground)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .frame(width: 300, height: 100)
            .clipped()
            .contentShape(Rectangle())
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale.current)
    }
}

extension Picker {
    func processPickerWheelStyle() -> some View {
        modifier(
            ProcessPickerModifier())
    }
}

private struct ProcessPickerModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .labelsHidden() // Hides the default label
            .frame(height: 150)
            .clipped()
            .contentShape(Rectangle())
            .pickerStyle(.wheel)
            .background(.watchLogViewBackground)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

private struct PickerTextModifier: ViewModifier {
    @Environment(\.appStyles) var appStyles

    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .fontWidth(.standard)
            .fontDesign(.rounded)
            .foregroundStyle(.watchLogProcessionTypeFont)
    }
}

extension Text {
    func pickerTextModifier() -> some View {
        modifier(PickerTextModifier())
    }
}
