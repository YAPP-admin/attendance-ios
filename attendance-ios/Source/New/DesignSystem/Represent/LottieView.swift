//
//  LottieView.swift
//  attendance-ios
//
//  Created by 이호영 on 2023/07/08.
//

import Lottie
import SwiftUI
import UIKit
 
struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    var filename: String
    var completion: LottieCompletionBlock
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play(completion: completion)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
    
}
