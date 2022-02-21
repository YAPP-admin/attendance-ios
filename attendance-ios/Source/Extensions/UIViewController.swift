//
//  UIViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/02/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message: String) {
        let toastLabel = UILabelWithRound(frame: .zero, color: UIColor.clear.cgColor, width: 0, inset: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.width.greaterThanOrEqualTo(20)
            $0.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
