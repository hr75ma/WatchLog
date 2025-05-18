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
