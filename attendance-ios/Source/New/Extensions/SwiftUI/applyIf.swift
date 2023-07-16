//
//  applyIf.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI

extension View {
  @ViewBuilder
  func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func availableCheck<T: View>(apply: (Self) -> T) -> some View {
    apply(self)
  }
}

