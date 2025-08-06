//
//  LockEditingView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//

import SwiftUI

struct StatusView: View {
    @Bindable var logEntry: WatchLogEntry
    public let viewIsReadOnly: Bool

    @Environment(\.appStyles) var appStyles

    let locale = Locale.current

    var body: some View {
        statusSection
            .frame(height: appStyles.sectionLabelFontSize, alignment: .center)
            .timeSectionPadding()
            .standardBottomBorder()
    }
}

extension StatusView {
    private var statusSection: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                Text(logEntry.isLocked ? "Gesperrt" : "Entsperrt")
                    .labelStyle(isLocked: logEntry.isLocked)
                    .disableAnimations(disableAnimation: viewIsReadOnly)
                    .animation(.smooth, value: logEntry.isLocked)
                
                Toggle("", isOn: $logEntry.isLocked)
                    .labelsHidden()
                    .toggleStyle(toggleStyleLockImage(isLocked: logEntry.isLocked, removeAnimation: viewIsReadOnly))
                    .disabled(logEntry.isNewEntryLog)
            }
            Spacer()
            HStack(alignment: .center) {
                Text("Abschlossen")
                    .freeLabelStyle(isLocked: logEntry.isClosed)
                    .disableAnimations(disableAnimation: viewIsReadOnly)
                    .animation(.smooth, value: logEntry.isClosed)
                
                ToggleView(toggleValue: $logEntry.isClosed, isLocked: logEntry.isLocked, isDimmend: false, removeAnimation: viewIsReadOnly, toggleType: .standard)
                     .disabled(logEntry.isLocked)
            }
        }
        .disabled(viewIsReadOnly)
    }
}
