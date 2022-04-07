//
//  UIStackView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/31.
//

import UIKit

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }

}
