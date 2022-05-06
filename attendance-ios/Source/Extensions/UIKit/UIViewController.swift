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
        let toastLabel = UILabelWithRound(frame: .zero, color: UIColor.clear.cgColor, width: 0, inset: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24))
        toastLabel.backgroundColor = UIColor(red: 0.173, green: 0.185, blue: 0.208, alpha: 0.8)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.text = message
		toastLabel.style(.Body2)
        toastLabel.numberOfLines = 0
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(84)
            $0.leading.greaterThanOrEqualToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
            $0.width.greaterThanOrEqualTo(44)
            $0.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
