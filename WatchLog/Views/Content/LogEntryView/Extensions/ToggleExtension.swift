//
//  ToggleExtensions.swift
//  WatchLog
//
//  Created by Marcus Hörning on 05.07.25.
//

import SwiftUI

struct toggleStyleLockImage: ToggleStyle {
    let isLocked: Bool
    let removeAnimation: Bool
    @Environment(\.appStyles) var appStyles

    func makeBody(configuration: toggleStyleLockImage.Configuration) -> some View {
        ZStack(alignment: .center) {
            Image(
                systemName: configuration.isOn ? appStyles.lockImageIsLocked : appStyles.lockImageIsUnLocked
            )
            .symbolRenderingMode(.palette)
            .resizable()
            .scaledToFit()
            .foregroundStyle(
                configuration.isOn
                    ? .watchLogIsLockedImagePrimary : .watchLogIsUnLockedImagePrimary,
                configuration.isOn
                    ? .watchLogIsLockedImageSecondary : .watchLogIsUnLockedImageSecondary
            )

            .symbolEffectsRemoved(removeAnimation)
            .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, value: configuration.isOn)
                
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .disableAnimations(disableAnimation: removeAnimation)
        .animation(.smooth(duration: 1), value: isLocked)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        //.frame(height: appStyles.sectionLabelFontSize, alignment: .center)
        .onTapGesture {
            configuration.$isOn.wrappedValue.toggle()
        }
    }
}

struct standardToggleStyleImage: ToggleStyle {
    let isLocked: Bool
    let removeAnimation: Bool
    @Environment(\.appStyles) var appStyles

    func makeBody(configuration: standardToggleStyleImage.Configuration) -> some View {
        ZStack(alignment: .center) {
            Image(
                systemName: configuration.isOn
                    ? appStyles.standardToggleIsActiveImage : appStyles.standardToggleIsUnactiveImage
            )
            .symbolRenderingMode(.palette)
            .resizable()
            .scaledToFit()
            .foregroundStyle(
                configuration.isOn
                    ? isLocked ? .watchLogStandardToogleIsLocked : .watchLogStandardToggleIsActivePrimary
                    : .watchLogStandardToggleIsUnactivePrimary,
                configuration.isOn
                    ? .watchLogStandardToggleIsActiveSecondary : .watchLogStandardToggleIsUnactiveSecondary
            )
            .symbolEffectsRemoved(removeAnimation)
            .symbolEffect(
                .breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: configuration.isOn
            )
            .symbolEffect(.scale)
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .disableAnimations(disableAnimation: removeAnimation)
        .animation(.smooth(duration: 1), value: isLocked)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .labelsHidden()
        .onTapGesture {
            configuration.$isOn.wrappedValue.toggle()
        }
    }
}

struct toggleStyleAnimationImage: ToggleStyle {
    var isOnImage: String = ""
    var isOffImage: String = ""
    var isOnColorPrimary: Color = .green
    var isOnColorSecondary: Color = .green
    var isOffColorPrimary: Color = .green
    var isOffColorSecondary: Color = .green

    var isLocked: Bool = false
    var isLockedColor: Color = .green

    func makeBody(configuration: toggleStyleAnimationImage.Configuration) -> some View {
        ZStack(alignment: .center) {
            Image(systemName: configuration.isOn ? isOnImage : isOffImage)
                .symbolRenderingMode(.palette)
                .resizable()
                .scaledToFit()

                .foregroundStyle(configuration.isOn ? isLocked ? isLockedColor : isOnColorPrimary : isOffColorPrimary, configuration.isOn ? isOnColorSecondary : isOffColorSecondary)
                .animation(.smooth(duration: 1), value: configuration.isOn)

                .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: configuration.isOn)
                .symbolEffect(.rotate.counterClockwise.byLayer, options: .nonRepeating, isActive: !configuration.isOn)

                .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2), isActive: configuration.isOn)
                .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2), isActive: !configuration.isOn)
                .symbolEffect(.scale)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        .onTapGesture {
            configuration.$isOn.wrappedValue.toggle()
        }
    }
}
