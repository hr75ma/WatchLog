//
//  ViewExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 18.05.25.
//

import SwiftUI

extension View {
  @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
    switch shouldHide {
    case true: self.hidden()
    case false: self
    }
  }
}

extension View {
  /// Hide or show a view based on a boolean value.
  ///
  /// Example for hiding while reclaiming space:
  ///
  ///     Text("Label")
  ///         .isHidden(true)
  ///
  /// Example for hiding, but leaving a gap where the hidden item was:
  ///
  ///     Text("Label")
  ///         .isHidden(true, remove: false)
  ///
  /// - Parameters:
  ///   - hidden: whether to hide the view.
  ///   - remove: whether you want to reclaim the space taken by the hidden view.
  @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
    if remove {
      if !hidden {
        self
      }
    } else {
      self.opacity(hidden ? 0 : 1)
    }
  }
}


extension Image {
    
    func SectionImageStyle(_ appStyles: StylesLogEntry) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .symbolRenderingMode(.monochrome)
            .symbolVariant(.fill)
            .foregroundStyle(appStyles.GeneralTextColor)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
}



