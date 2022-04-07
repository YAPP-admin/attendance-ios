//
//  UIView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/03/31.
//

import UIKit

extension UIView {

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }

}
