//
//  ImageExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 01.06.25.
//
import SwiftUI

extension Image {
    func ToolbarImageStyle() -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.monochrome)
            .symbolVariant(.fill)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    func sectionImageStyle(primaryColor: Color, secondaryColor: Color) -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .symbolVariant(.circle)
            //.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            .foregroundStyle(primaryColor, secondaryColor)
    }
    
    func notClosedImageStyle(primaryColor: Color, secondaryColor: Color, size: CGFloat = 25) -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .symbolVariant(.none)
            //.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .foregroundStyle(primaryColor, secondaryColor)
    }
}
