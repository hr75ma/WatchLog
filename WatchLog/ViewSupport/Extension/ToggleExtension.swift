//
//  ToggleExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 18.05.25.
//

import SwiftUI

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
              
              
              .foregroundStyle(configuration.isOn ?  isLocked ? isLockedColor : isOnColorPrimary : isOffColorPrimary, configuration.isOn ? isOnColorSecondary : isOffColorSecondary)
              .animation(.easeInOut(duration: 1), value: configuration.isOn)
          
              .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: configuration.isOn)
              .symbolEffect(.rotate.counterClockwise.byLayer, options: .nonRepeating, isActive: !configuration.isOn)
          
          
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2) ,isActive: configuration.isOn)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(2), isActive: !configuration.isOn)
              .symbolEffect(.scale)
              .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
      }
      //.animation(.easeInOut(duration: 4),  value: isLocked)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
             
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    
  }
}




struct toggleStyleLockImage: ToggleStyle {
    let appStyles: StylesLogEntry
    
    var isLocked: Bool = false
    var isLockedColor: Color = .green

  func makeBody(configuration: toggleStyleLockImage.Configuration) -> some View {
          
      ZStack(alignment: .center) {
          
          
          Image(systemName: configuration.isOn ? appStyles.LockImageisLocked : appStyles.LockImageisUnLocked)
              .symbolRenderingMode(.palette)
              .resizable()
              .scaledToFit()
              
              
              .foregroundStyle(configuration.isOn ? appStyles.LockColorIsLockedPrimary: appStyles.LockColorIsUnLockedPrimary, configuration.isOn ? appStyles.LockColorIsLockedSecondary : appStyles.LockColorIsUnLockedSecondary)
              .animation(.easeInOut(duration: 1), value: configuration.isOn)
          
              .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: configuration.isOn)
              .symbolEffect(.rotate.clockwise.byLayer, options: .nonRepeating, isActive: !configuration.isOn)
              .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
      }
      .animation(.easeInOut(duration: 1),  value: isLocked)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
             
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    
  }
}


struct generalToggleStyleImage: ToggleStyle {
    let appStyles: StylesLogEntry
    
    var isLocked: Bool = false
   
  func makeBody(configuration: generalToggleStyleImage.Configuration) -> some View {
          
      ZStack(alignment: .center) {
          Image(systemName: configuration.isOn ? appStyles.GeneralToggleIsActiveImage : appStyles.GeneralToggleIsUnactiveImage)
              .symbolRenderingMode(.palette)
              .resizable()
              .scaledToFit()
              .foregroundStyle(configuration.isOn ?  isLocked ? appStyles.ToogleIsLockedColor : appStyles.GeneralToggleIsActivePrimary : appStyles.GeneralToggleIsUnactivePrimary, configuration.isOn ? appStyles.GeneralToggleIsActiveSecondary : appStyles.GeneralToggleIsUnactiveSecondary)
              .animation(.easeInOut(duration: 1), value: configuration.isOn)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6) ,isActive: configuration.isOn)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !configuration.isOn)
              .symbolEffect(.scale)
              .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
      }
      .animation(.easeInOut(duration: 1),  value: isLocked)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
      .labelsHidden()
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    
  }
}

