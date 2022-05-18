//
//  UIViewController.swift
//  attendance-ios
//
//  Created by 김보민 on 2022/02/21.
//

import SnapKit
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
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-110)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.greaterThanOrEqualTo(44)
            $0.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

// MARK: - SignUp
extension UIViewController {

    func addNavigationBackButton() {
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "back"), for: .normal)
            return button
        }()
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.left.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        backButton.addTarget(self, action: #selector(navigationBackButtonTapped), for: .touchUpInside)
    }

    @objc func navigationBackButtonTapped() {}

}
