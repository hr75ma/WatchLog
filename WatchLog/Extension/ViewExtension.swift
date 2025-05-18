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
