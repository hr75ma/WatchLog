//
//  ImageExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 01.06.25.
//
import SwiftUI

extension Image {

  func ToolbarImageStyle() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .symbolRenderingMode(.monochrome)
      .symbolVariant(.fill)
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }

  func SectionImageStyle(primaryColor: Color, secondaryColor: Color) -> some View {
    self.resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 40, height: 40)
      .symbolVariant(.circle)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
      .foregroundStyle(primaryColor, secondaryColor)
  }

}
