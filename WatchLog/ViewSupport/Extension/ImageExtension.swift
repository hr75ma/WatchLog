//
//  ImageExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 01.06.25.
//
import SwiftUI

extension Image {
    
    func ToolbarImageStyle(_ appStyles: StylesLogEntry) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.monochrome)
            .symbolVariant(.fill)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
