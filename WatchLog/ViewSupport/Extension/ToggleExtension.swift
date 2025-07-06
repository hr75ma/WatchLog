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


