//
//  ToggleExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 18.05.25.
//

import SwiftUI

struct MyStyle: ToggleStyle {
  let ImageIsOff: String = "rectangle.fill"
  let ImageIsOn: String = "checkmark.rectangle.fill"

  func makeBody(configuration: MyStyle.Configuration) -> some View {
    HStack(alignment: .center) {
      configuration.label

      Image(systemName: configuration.isOn ? ImageIsOn : ImageIsOff)
        .font(.largeTitle)
        .foregroundColor(configuration.isOn ? Color.green : Color.gray)
        .onTapGesture {
          configuration.$isOn.wrappedValue.toggle()
        }
    }
  }
}

struct MyStyleLock: ToggleStyle {
  let ImageIsOff: String = "rectangle.fill"
  let ImageIsOn: String = "checkmark.rectangle.fill"

  func makeBody(configuration: MyStyle.Configuration) -> some View {
    HStack(alignment: .center) {
      configuration.label

      Image(systemName: configuration.isOn ? ImageIsOn : ImageIsOff)
        .font(.largeTitle)
        .foregroundColor(configuration.isOn ? Color.red : Color.green)
        .onTapGesture {
          configuration.$isOn.wrappedValue.toggle()
        }
    }
  }
}





struct CustomToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Rectangle()
        .fill(configuration.isOn ? Color.green : Color.red)
        .frame(width: 50, height: 30)  // Custom height
        .cornerRadius(15)
        .onTapGesture {
          configuration.isOn.toggle()
        }
    }
    .padding()
  }
}









struct ToggleStyleLock: ToggleStyle {
  var isOffImage: String = "rectangle.fill"
  var isOnImage: String = "checkmark.rectangle.fill"

  func makeBody(configuration: MyStyle.Configuration) -> some View {
      HStack(alignment: .center, spacing:0) {
          configuration.label
          
          Image(systemName: configuration.isOn ? isOnImage : isOffImage)
              .resizable()
              .scaledToFit()
              .frame(width: 30)
              .foregroundColor(configuration.isOn ? Color.red : Color.green)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(configuration.isOn ? Color.red : Color.green, lineWidth: 2)
              )
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    }
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

  }
}

struct ToggleStyleImage: ToggleStyle {
    
    var isOnImage: String = ""
    var isOffImage: String = ""
    var isOnColorPrimary: Color = .green
    var isOnColorSecondary: Color = .green
    var isOffColorPrimary: Color = .green
    var isOffColorSecondary: Color = .green

  func makeBody(configuration: MyStyle.Configuration) -> some View {
          
      ZStack(alignment: .center) {
          
          
          Image(systemName: configuration.isOn ? isOnImage : isOffImage)
              .symbolRenderingMode(.palette)
              .resizable()
              .scaledToFit()
              
              
              .foregroundStyle(configuration.isOn ? isOnColorPrimary : isOffColorPrimary, configuration.isOn ? isOnColorSecondary : isOffColorSecondary)
              .animation(.easeInOut(duration: 1), value: configuration.isOn)
          
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6) ,isActive: configuration.isOn)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !configuration.isOn)
              .symbolEffect(.scale)
              .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
          
          
              
          //.foregroundColor(configuration.isOn ? isOnColor : isOffColor)
              
      }
      //.frame(height: 35, alignment: .center)
//      .overlay(
//        RoundedRectangle(cornerRadius: 7)
//            .stroke(configuration.isOn ? isOnColorPrimary : isOffColorPrimary, lineWidth: 2))
//            .animation(.easeInOut(duration: 1), value: configuration.isOn)
//      )
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
             
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    
  }
}

struct ToggleStyleFramedImage: ToggleStyle {
    
    var isOnImage: String = ""
    var isOffImage: String = ""
    var isOnColorPrimary: Color = .green
    var isOnColorSecondary: Color = .green
    var isOffColorPrimary: Color = .green
    var isOffColorSecondary: Color = .green

  func makeBody(configuration: MyStyle.Configuration) -> some View {
          
      ZStack(alignment: .center) {
          
          
          Image(systemName: configuration.isOn ? isOnImage : isOffImage)
              .symbolRenderingMode(.palette)
              .resizable()
              .scaledToFit()
              
              
              .foregroundStyle(configuration.isOn ? isOnColorPrimary : isOffColorPrimary, configuration.isOn ? isOnColorSecondary : isOffColorSecondary)
              .animation(.easeInOut(duration: 1), value: configuration.isOn)
          
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6) ,isActive: configuration.isOn)
              .symbolEffect(.breathe.pulse.wholeSymbol, options: .nonRepeating.speed(6), isActive: !configuration.isOn)
              .symbolEffect(.scale)
              .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
          
          
              
          //.foregroundColor(configuration.isOn ? isOnColor : isOffColor)
              
      }
      .frame(height: 35, alignment: .center)
      .overlay(
        RoundedRectangle(cornerRadius: 7)
            .stroke(configuration.isOn ? isOnColorPrimary : isOffColorPrimary, lineWidth: 2))
            .animation(.easeInOut(duration: 1), value: configuration.isOn)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
             
              .onTapGesture {
                  configuration.$isOn.wrappedValue.toggle()
              }
    
  }
}

