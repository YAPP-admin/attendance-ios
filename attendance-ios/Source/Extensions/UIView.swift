//
//  UIView.swift
//  attendance-ios
//
//  Created by leeesangheee on 2022/04/07.
//

import UIKit

extension UIView {

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }

    func setCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func setTopCornerRadius(radius: CGFloat) {
        setCornerRadius(corners: [.topLeft, .topRight], radius: radius)
    }

    func setBottomCornerRadius(radius: CGFloat) {
        setCornerRadius(corners: [.bottomLeft, .bottomRight], radius: radius)
    }

}
