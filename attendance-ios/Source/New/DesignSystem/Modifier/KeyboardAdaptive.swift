//
//  KeyboardAdaptive.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/16.
//

import SwiftUI
import UIKit

struct KeyboardAdaptive: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
      .onDisappear(perform: UIApplication.shared.removeTapGestureRecognizer)
  }
}


extension UIApplication {
  func addTapGestureRecognizer() {
    guard let window = windows.first else { return }
    let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    tapGesture.name = "KeyboardDismissGesture"
    window.addGestureRecognizer(tapGesture)
  }
  
  func removeTapGestureRecognizer() {
    guard let window = windows.first else { return }
    
    window.gestureRecognizers?.forEach { gr in
      if gr.name == "KeyboardDismissGesture" {
        window.removeGestureRecognizer(gr)
      }
       
    }
  }
    
}

extension UIApplication: UIGestureRecognizerDelegate {
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return false
  }
}
